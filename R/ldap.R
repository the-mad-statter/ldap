#' Generic LDAP query
#'
#' Perform generic LDAP queries
#'
#' @param hostname name (or ip address) of the LDAP server
#' @param base_dn distinguished name (DN) of an entry in the directory. This
#' DN identifies the entry that is the starting point of the search. If no base
#' DN is specified, the search starts at the root of the directory tree.
#' @param attributes The attributes to be returned. To specify more than one
#' attribute, use commas to separate the attributes (for example,
#' "cn,mail,telephoneNumber"). If no attributes are specified in the URL,
#' all attributes are returned.
#' @param scope The scope of the search, which can be one of these values:
#' 1. base
#'     * retrieves information about the distinguished name (base_dn) specified
#'     in the URL only.
#' 1. one
#'     * retrieves information about entries one level below the distinguished
#'     name (base_dn) specified in the URL. The base entry is not included in
#'     this scope.
#' 1. sub
#'     * retrieves information about entries at all levels below the
#'     distinguished name (base_dn) specified in the URL. The base entry is
#'     included in this scope.
#' @param filter Search filter to apply to entries within the specified scope of
#'  the search.
#' @param user username
#' @param pass password
#' @param protocol connection protocol to use
#' @param port override the default port number (LDAP = 389, LDAPS = 636)
#'
#' @return curl response object
#' @export
#'
#' @examples
#' ldap_query(
#'   hostname = "ldap.forumsys.com",
#'   base_dn = "dc=example,dc=com",
#'   scope = "sub",
#'   user = "cn=read-only-admin,dc=example,dc=com",
#'   pass = "password",
#'   protocol = "ldap",
#'   port = 389
#' ) %>%
#'   content_to_tibble()
#'
ldap_query <- function(hostname,
                       base_dn = "",
                       attributes = "",
                       scope = c("base", "one", "sub"),
                       filter = "(objectClass=*)",
                       user,
                       pass,
                       protocol = c("ldaps", "ldap"),
                       port = c(636, 389)) {
  protocol <- match.arg(protocol)
  port <- ifelse(!missing(port), sprintf(":%i", port), "")
  attributes <- paste(attributes, collapse = ",")
  scope <- match.arg(scope)

  url <- sprintf(
    "%s://%s%s/%s?%s?%s?%s",
    protocol,
    hostname,
    port,
    base_dn,
    attributes,
    scope,
    filter
  )

  h <- curl::new_handle()
  if (!missing(user) && !missing(pass)) {
    h <- curl::handle_setopt(h, userpwd = sprintf("%s:%s", user, pass))
  }

  x <- curl::curl_fetch_memory(url, h)
  class(x) <- c("ldap_response", class(x))
  return(x)
}

#' Coerce an LDAP response to a data frame
#'
#' @param x an object of class `ldap_response`
#' @param separate logical to detect and expand recursive columns
#'
#' @return a [tibble::tibble] representation of the LDAP response
#' @export
#'
#' @examples
#' ldap_query(
#'   hostname = "ldap.forumsys.com",
#'   base_dn = "dc=example,dc=com",
#'   scope = "sub",
#'   user = "cn=read-only-admin,dc=example,dc=com",
#'   pass = "password",
#'   protocol = "ldap",
#'   port = 389
#' ) %>%
#'   content_to_tibble()
#'
content_to_tibble <- function(x, separate = FALSE) {
  stopifnot(inherits(x, "ldap_response"))

  x <- x[["content"]]
  x <- x[!x == "00"]
  x <- rawToChar(x)

  gsub("[\n]+DN: ", "\n\n\n\nDN: ", x) %>% # win/mac: [\n]{2}; lin: [\n]{3}
    strsplit("\n\n\n\n") %>%
    unlist() %>%
    lapply(function(x) {
      x <- x %>%
        strsplit("\n\n\t") %>%
        unlist() %>%
        tibble::as_tibble_col(column_name = "key_value_pairs") %>%
        tidyr::separate_wider_delim(
          cols = dplyr::all_of("key_value_pairs"),
          delim = ": ",
          names = c("key", "value"),
          too_many = "merge"
        ) %>%
        tidyr::pivot_wider(names_from = dplyr::all_of("key"))

      if (separate) {
        for (col in setdiff(names(x)[grepl("\n\t", x)], "DN")) {
          x <- tidyr::separate_wider_delim(
            data = x,
            cols = dplyr::all_of(col),
            delim = paste0("\n\t", col, ": "),
            names_sep = "_",
            names_repair = "unique"
          )
        }
      }

      x
    }) %>%
    dplyr::bind_rows()
}

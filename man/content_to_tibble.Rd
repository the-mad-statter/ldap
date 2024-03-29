% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ldap.R
\name{content_to_tibble}
\alias{content_to_tibble}
\title{Coerce an LDAP response to a data frame}
\usage{
content_to_tibble(x, separate = FALSE)
}
\arguments{
\item{x}{an object of class \code{ldap_response}}

\item{separate}{logical to detect and expand recursive columns}
}
\value{
a \link[tibble:tibble]{tibble::tibble} representation of the LDAP response
}
\description{
Coerce an LDAP response to a data frame
}
\examples{
ldap_query(
  hostname = "ldap.forumsys.com",
  base_dn = "dc=example,dc=com",
  scope = "sub",
  user = "cn=read-only-admin,dc=example,dc=com",
  pass = "password",
  protocol = "ldap",
  port = 389
) \%>\%
  content_to_tibble()

}

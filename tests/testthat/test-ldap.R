test_that("ldap_query works", {
  testthat::expect_snapshot(
    ldap_query(
      hostname = "ldap.forumsys.com",
      base_dn = "dc=example,dc=com",
      scope = "sub",
      user = "cn=read-only-admin,dc=example,dc=com",
      pass = "password",
      protocol = "ldap",
      port = 389
    ) %>%
      content_to_tibble(TRUE)
  )
})

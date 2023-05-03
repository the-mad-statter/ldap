# ldap_query works

    Code
      ldap_query(hostname = "ldap.forumsys.com", base_dn = "dc=example,dc=com",
        scope = "sub", user = "cn=read-only-admin,dc=example,dc=com", pass = "password",
        protocol = "ldap", port = 389) %>% content_to_tibble(TRUE)
    Output
      # A tibble: 21 x 25
         DN    o     dc    cn    description objectClass_1 objectClass_2 objectClass_3
         <chr> <chr> <chr> <chr> <chr>       <chr>         <chr>         <chr>        
       1 "dc=~ exam~ exam~ <NA>  <NA>        <NA>          <NA>          <NA>         
       2 "cn=~ <NA>  <NA>  admin LDAP admin~ <NA>          <NA>          <NA>         
       3 "uid~ <NA>  <NA>  Isaa~ <NA>        inetOrgPerson organization~ person       
       4 "uid~ <NA>  <NA>  Albe~ <NA>        <NA>          <NA>          <NA>         
       5 "uid~ <NA>  <NA>  Niko~ <NA>        <NA>          <NA>          <NA>         
       6 "uid~ <NA>  <NA>  Gali~ <NA>        <NA>          <NA>          <NA>         
       7 "uid~ <NA>  <NA>  Leon~ <NA>        <NA>          <NA>          <NA>         
       8 "uid~ <NA>  <NA>  Carl~ <NA>        <NA>          <NA>          <NA>         
       9 "uid~ <NA>  <NA>  Bern~ <NA>        <NA>          <NA>          <NA>         
      10 "uid~ <NA>  <NA>  Eucl~ <NA>        inetOrgPerson organization~ person       
      # i 11 more rows
      # i 17 more variables: objectClass_4 <chr>, uid <chr>, mail <chr>, sn <chr>,
      #   telephoneNumber <chr>, uidNumber <chr>, gidNumber <chr>,
      #   homeDirectory <chr>, ou <chr>, userPassword <chr>, givenName <chr>,
      #   displayName <chr>, initials <chr>, uniqueMember_1 <chr>,
      #   uniqueMember_2 <chr>, uniqueMember_3 <chr>, uniqueMember_4 <chr>


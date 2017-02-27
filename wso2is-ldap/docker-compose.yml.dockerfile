version: "3"

services:

  wso2:
    build:
      context: .
      dockerfile: Dockerfile-wso2is
    container_name: wso2is
    ports:
      - "9443:9443"
    depends_on:
      - openldap

  openldap:
    image: kleysonr/openldap:1.0.0
    container_name: openldap
    ports:
      - "389:389"
      - "636:636"
    environment:
      # docker exec openldap ldapsearch -x -h localhost -b dc=example,dc=com -D "cn=admin,dc=example,dc=com" -w admin
      LDAP_ORGANISATION: "Example Company"
      LDAP_DOMAIN: "example.com"
      LDAP_ADMIN_PASSWORD: "admin"

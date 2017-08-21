Overview
-------------

WSO2 Identity Server - SAML (http://docs.wso2.org/identity-server) integrated with an OpenLDAP server.

SAML is a specification that provides a means to exchange an authentication assertion of the principal (user) between an Identity Provider (IdP) and a Service Provider (SP). 

WSO2 Identity Server is an identity and entitlement management server that facilitates security while connecting and managing multiple identities across different applications. It enables enterprise architects and developers to improve customer experience through a secure single sign-on environment.

Pentaho provides a [**plugin sample** that implements the SAML protocol](https://github.com/pentaho/pentaho-engineering-samples/tree/7.0/Samples%20for%20Extending%20Pentaho/Reference%20Implementations/Security/SAML%202.0). Once the plugin is built, installed and configured, the Pentaho/BA Server will become in a SAML Service Provider, relying on the assertion from the IdP to provide authentication.

> **Note:**
>
> - Tested on Pentaho 7.0
> - Applied [patch for LDAP](http://jira.pentaho.com/browse/BISERVER-13491)

----------

Configuring
-------------

- Configure a LDAP server following [this steps](https://github.com/kleysonr/docker-openldap). Make sure that you can authenticate on Pentaho against the OpenLDAP.

- (Optional) Build the SAML plugin following [this steps](https://github.com/pentaho/pentaho-engineering-samples/tree/7.0/Samples%20for%20Extending%20Pentaho/Reference%20Implementations/Security/SAML%202.0).

- Clone or download this repository and move to the project directory.

- Stops any running OpenLDAP container.

- Execute the following comands.
> **docker rm openldap**
>
> **docker rm wso2is**
>
> **docker-compose rm**

- Build the WSO2 IS server.
> **docker-compose build**

- Starts new WSO2 IS and OpenLDAP containers.
> **docker-compose up**
> 
> **Note:**
>
> - You will see a error on the WSO2IS logs. That happens because we have a fresh OpenLDAP server and it's necessary to import the users again.

- Open a new terminal and import the users into the OpenLDAP
> **docker exec -it openldap /bin/bash**
>
> **ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin -H ldap:// -f /sample.ldif**

- In the previous terminal, press CTRL+C to stop the containers and start both again
> **docker-compose start**

- Use the docker compose to manage the containers
> **docker-compose up**
>
>Creates a fresh wso2is and openldap containers.
> 
> **docker-compose stop**
>
>Stops a running wso2is and openldap containers.
>
> **docker-compose start**
>
>Resumes a wso2is and openldap containers.

-  Open the browser and enter **https://localhost:9443/carbon** and sign-in using **admin/password**.

-  Click in **Service Providers -> Add** to add a new service provider. Use **pentaho** as the **Service Provider Name**.

-  After register click in **Inbound Authentication Configuration -> SAML2 Web SSO Configuration -> Configure**.

-  Select **Metadata File Configuration** and upload the **pentaho-security-samples/wso2is-ldap/metadata/pentaho-sp.xml** file.

-  Click **Edit** for the new pentaho Issuer created.

-  Select **Enable Response Signing**.

-  For **SLO Response URL** set **http://localhost:8080/pentaho/saml/SingleLogout** and update.

-  Expand **Local & Outbound Authentication Configuration**, select **Use user store domain in local subject identifier** and update.

-  Click in **Identity Providers -> Resident**.

-  Expand **Inbound Authentication Configuration -> SAML2 Web SSO Configuration**.

-  For **Identity Provider Entity Id** set the value as **Wso2SSO** and update.

-  Copy recursively the **pentaho-server** folder to **install_pentaho_folder/pentaho-server** folder.

- (EE Only) Edit the **system/pentaho-spring-beans.xml** file and change the **``<import resource="applicationContext-spring-security-saml-ce.xml" />``** to **``<import resource="applicationContext-spring-security-saml-ee.xml"``** />

- Clear the jackrabbit repository
> rm -rf **``install_pentaho_folder/pentaho-server/pentaho-solutions/system/jackrabbit/repository/*``**

- Clear the karaf cache
> rm -rf **``install_pentaho_folder/pentaho-server/pentaho-solutions/system/karaf/caches/default/*``**

- Edit the **tomcat/webapps/pentaho/WEB-INF/web.xml** file, search for the tag **``<session-config>``** and make sure to have the configuration below:
> ``<session-config>``
>
> ``  <session-timeout>120</session-timeout>``
>
> ``  <cookie-config>``
>
> ``    <name>JSESSIONID_PENTAHO</name>``
>
> ``  </cookie-config>``
>  
> ``</session-config>``

- Start BA Server.

- Enter on the browser **http://localhost:8080/pentaho/Home** and you should be redirected to authenticate on the IdP server.

----------

More info
-------------

Read 

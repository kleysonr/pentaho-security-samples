keytool -genkey -noprompt \
 -alias pentaho \
 -dname "CN=admin, OU=services, O=pentaho, L=orlando, ST=fl, C=us" \
 -keystore saml.keystore.jks \
 -storepass password \
 -keypass password \
 -keyalg RSA \
 -validity 3650

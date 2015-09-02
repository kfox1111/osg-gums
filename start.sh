#!/bin/bash -e

: ${GUMS_PORT:=8443}
: ${GUMS_SERVER_PORT:=8005}
: ${GUMS_KEY:=/etc/grid-security/http/httpkey.pem}
: ${GUMS_CERT:=/etc/grid-security/http/httpcert.pem}
: ${MYSQL_HOST:=localhost}
: ${MYSQL_PORT:=3306}
: ${MYSQL_DB:=GUMS_1_3}
: ${MYSQL_USER:=gums}
: ${MYSQL_PASSWD:=mysecret}
: ${STORE_CONFIG:=false} 

sed -i 's/sslCertFile="[^"]*"/sslCertFile="'$GUMS_CERT'"/' /etc/tomcat6/server.xml
sed -i 's/sslKey="[^"]*"/sslKey="'$GUMS_KEY'"/' /etc/tomcat6/server.xml
sed -i 's/Connector port="[0-9]*"/Connector port="'$GUMS_PORT'"/' /etc/tomcat6/server.xml
sed -i 's/Server port="[0-9]*"/Server port="'$GUMS_SERVER_PORT'"/' /etc/tomcat6/server.xml
sed -i "s/\(storeConfig=\).*/\1'$STORE_CONFIG'/" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.username=\).*/\1'$MYSQL_USER'/" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.url=\).*/\1'jdbc:mysql:\/\/$MYSQL_HOST:$MYSQL_PORT\/$MYSQL_DB'/" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.password=\).*/\1'$MYSQL_PASSWD'\/>/" /etc/gums/gums.config

#Force timestamp on gums config into the past, so it will not be copied to the database, but so that the db's copy will be copied back to the node.
touch -t 201212121212.12 /etc/gums/gums.config

if [ ! -f /etc/inited ]; then
	mkdir -p /srv/var/log/tomcat6
	chown tomcat /srv/var/log/tomcat6
	mv /var/log/tomcat6 /var/log/tomcat6.orig
	ln -s /srv/var/log/tomcat6 /var/log/tomcat6
	touch /etc/inited
fi

/etc/init.d/tomcat6 start

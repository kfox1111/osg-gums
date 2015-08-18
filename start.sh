#!/bin/bash -e

: ${MYSQL_HOST:=localhost}
: ${MYSQL_PORT:=3306}
: ${MYSQL_DB:=GUMS_1_3}
: ${MYSQL_USER:=gums}
: ${MYSQL_PASSWD:=mysecret}
: ${STORE_CONFIG:=false} 
: ${parameter_name:=value}

sed -i "s/\(storeConfig=\).*/\1'$STORE_CONFIG'" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.username=\).*/\1'$MYSQL_USER'" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.url=\).*/\1'jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DB'/" /etc/gums/gums.config
sed -i "s/\(hibernate.connection.password=\).*/\1'$MYSQL_PASSWD'/>" /etc/gums/gums.config

/etc/init.d/tomcat6 start

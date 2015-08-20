FROM kfox1111/osg-base
MAINTAINER Kevin Fox "Kevin.Fox@pnnl.gov"

RUN yum install -y osg-gums
ADD ./start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

ADD ./tomcat-run.patch /tmp/tomcat-run.patch
RUN pushd /; patch -p0 < /tmp/tomcat-run.patch; popd
RUN rm -f /tmp/tomcat-run.patch

RUN /var/lib/trustmanager-tomcat/configure.sh

CMD ["/etc/start.sh"]

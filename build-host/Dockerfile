FROM tomcat:9.0
LABEL maintainer="Praveen"

ADD ./target/SimpleServlet-1.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]

FROM jboss-fuse-6/fis-java-openshift:1.0
MAINTAINER docker-maven-plugin@jolokia.org
ENV HTTP_PORT=9123 JAVA_LIB_DIR=/deployments/lib JAVA_MAIN_CLASS=org.apache.camel.spring.Main
EXPOSE 9123
COPY maven /deployments/

FROM ubuntu:12.04

ADD jetty-runner.jar /usr/local/scape/jetty-runner.jar
ADD fcrepo-webapp.war /usr/local/scape/fcrepo-webapp.war
ADD jre /usr/lib/jvm/jre

RUN chmod +x /usr/lib/jvm/jre/bin/java
RUN ln -s /usr/lib/jvm/jre/bin/java /usr/bin/
RUN echo '#!/bin/bash' > /usr/local/bin/run_fcrepo
RUN echo 'java -jar /usr/local/scape/jetty-runner.jar /usr/local/scape/fcrepo-webapp.war' >> /usr/local/bin/run_fcrepo
RUN chmod +x /usr/local/bin/run_fcrepo 

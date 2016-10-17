FROM java:8u45-jdk 

MAINTAINER Henry Yang <yanghenry2@gmail.com>

ENV JENKINS_SWARM_VERSION 2.0 
ENV HOME /home/jenkins-slave 

# install netstat to allow connection health check with 
# netstat -tan | grep ESTABLISHED 
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

USER jenkins-slave 
VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]

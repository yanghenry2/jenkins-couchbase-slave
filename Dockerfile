FROM java:8u45-jdk
MAINTAINER Henry Yang <yanghenry2@gmail.com>

ENV JENKINS_SWARM_VERSION 2.2
ENV HOME /home/jenkins-slave

# install netstat to allow connection health check with
# netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*
RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave

RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar
RUN chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh
RUN chmod 777 /usr/local/bin/jenkins-slave.sh

# Install AWS S3:
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#Install CB 4.1.2MP1:
RUN curl -fSL "http://packages.couchbase.com/releases/4.1.2/couchbase-server-enterprise_4.1.2-ubuntu12.04_amd64.deb" -o /tmp/couchbase.deb
#RUN dpkg -i /tmp/couchbase.deb

#USER jenkins-slave
USER root
VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]

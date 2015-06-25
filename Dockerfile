# Pull base image.
FROM phusion/baseimage:latest

# Install Java.
RUN \
  cd /tmp && \
  apt-get update && \
  apt-get -f install && \
  apt-get install wget && \
  wget https://s3.amazonaws.com/zxsw/jdk-latest.gz && \
  tar zxvf jdk-latest.gz && \
  mkdir -p /usr/lib/jvm && \
  mv jdk1.8.0_40 java-8-oracle && \
  mv java-8-oracle /usr/lib/jvm/ && \
  rm -f jdk-latest.gz

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ADD target/AwsTest-1.0-SNAPSHOT-fat.jar /data/

EXPOSE 8080

CMD /usr/lib/jvm/java-8-oracle/bin/java -server -XX:+DoEscapeAnalysis -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseG1GC \
		-XX:MaxGCPauseMillis=5 -XX:MaxTenuringThreshold=5 -Xmx1024M -Xms1024M -XX:+AggressiveOpts \
		-Dsun.net.inetaddr.ttl=1200 -Dsun.net.inetaddr.negative.ttl=10 \
		-jar AwsTest-1.0-SNAPSHOT-fat.jar > /srv/log/console.log 2>&1

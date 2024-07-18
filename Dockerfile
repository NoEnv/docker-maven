FROM noenv/openjdk:22.0.2

ARG MAVEN_VERSION=3.9.8
ARG SHA=7d171def9b85846bf757a2cec94b7529371068a0670df14682447224e57983528e97a6d1b850327e4ca02b139abaab7fcb93c4315119e6f0ffb3f0cbc0d0b9a2
ARG BASE_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update \
  && apt-get install -y gnupg curl procps zip \
  && mkdir -p /opt/maven /root/.m2 /drone/volume \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /opt/maven --strip-components=1 \
  && rm -rf /var/lib/apt/lists/* /tmp/apache-maven.tar.gz \
  && cp -f /opt/maven/conf/settings.xml /drone/volume/ \
  && ln -s /opt/maven/bin/mvn /usr/bin/mvn \
  && ln -s /drone/volume/settings.xml /root/.m2/ \
  && echo "JAVA_HOME=/docker-java-home" > /etc/mavenrc

ENV MAVEN_HOME "/opt/maven"
ENV MAVEN_CONFIG "/root/.m2"
ENV JAVA_HOME "/docker-java-home"

CMD ["/usr/bin/mvn"]

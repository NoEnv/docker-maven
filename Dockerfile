FROM noenv/openjdk:15.0.1

ARG MAVEN_VERSION=3.6.3
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update \
  && apt-get install -y gnupg curl procps \
  && mkdir -p /opt/maven /root/.m2 /drone/volume \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /opt/maven --strip-components=1 \
  && rm -rf /var/lib/apt/lists/* /tmp/apache-maven.tar.gz \
  && cp -f /opt/maven/conf/settings.xml /drone/volume/ \
  && ln -s /opt/maven/bin/mvn /usr/bin/mvn \
  && ln -s /drone/volume/settings.xml /root/.m2/

ENV MAVEN_HOME "/opt/maven"
ENV MAVEN_CONFIG "/root/.m2"
ENV JAVA_HOME "/docker-java-home"

CMD ["/usr/bin/mvn"]

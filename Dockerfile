FROM noenv/openjdk:25.0.4

ARG MAVEN_VERSION=3.10.0
ARG SHA=908b1501bfb420bf7c8affb855534a9c407fd6099367bfb9f2f2dcb8e9799102bffb84518cde74c679bd76870247c6528683abdd620581bffa90f95d92d175aa
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

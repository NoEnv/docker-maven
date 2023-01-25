FROM noenv/openjdk:19.0.2

ARG MAVEN_VERSION=3.8.7
ARG SHA=21c2be0a180a326353e8f6d12289f74bc7cd53080305f05358936f3a1b6dd4d91203f4cc799e81761cf5c53c5bbe9dcc13bdb27ec8f57ecf21b2f9ceec3c8d27
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

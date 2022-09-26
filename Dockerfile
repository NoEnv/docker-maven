FROM noenv/openjdk:19.0.0

ARG MAVEN_VERSION=3.8.6
ARG SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26
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

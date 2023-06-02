FROM openjdk:8-jdk-alpine
LABEL Docker image for maven and docker. Verify that settings.xml is in the current directory

RUN apk add --no-cache curl tar bash procps

# Downloading and installing Maven

ARG MAVEN_VERSION=3.9.2
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref
RUN echo "Downloading maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1
RUN echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

CMD ["sh", "-c", "mvn --version"]
RUN mkdir -p /root/.m2 \
    && mkdir /root/.m2/repository
# Copy maven settings, containing repository configurations
COPY settings.xml /root/.m2
RUN apk add --update docker openrc
RUN rc-update add docker boot

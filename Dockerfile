FROM maven:3.6-jdk-12 as build
WORKDIR /sputnik-ena-parent
COPY pom.xml .
COPY config-server config-server/
RUN mvn -f config-server/pom.xml clean package

#FROM frolvlad/alpine-oraclejdk8:slim
FROM openjdk:12
COPY --from=build /sputnik-ena-parent/config-server/target/*.jar app.jar
RUN mkdir /var/lib/config-repo
COPY --from=build /sputnik-ena-parent/config-server/src/main/resources/config-repo /var/lib/config-repo
EXPOSE 8088 8787
ENV JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8787,suspend=n"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=docker -jar /app.jar" ]
VOLUME /var/lib/config-repo


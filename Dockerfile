FROM frolvlad/alpine-oraclejdk8:slim
ADD ["target/config-server-0.0.1-SNAPSHOT.jar", "app.jar"]
RUN mkdir /var/lib/config-repo
COPY src/main/resources/config-repo /var/lib/config-repo
EXPOSE 8088 8787
ENV JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8787,suspend=n"
RUN sh -c 'touch /app.jar'
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=docker -jar /app.jar" ]
VOLUME /var/lib/config-repo

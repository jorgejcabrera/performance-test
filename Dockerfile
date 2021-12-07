#
# Build stage
#
FROM gradle:6.9-jdk11 as compiler
ENV APP_HOME=/usr/app/

WORKDIR $APP_HOME

# copy source code
COPY build.gradle.kts settings.gradle.kts gradlew $APP_HOME
COPY src src

# create application jar
RUN gradle build -x test --no-daemon

# move application jar
RUN mv ./build/libs/*SNAPSHOT.jar service.jar

#
# Run stage
#
FROM adoptopenjdk/openjdk11:jre-11.0.4_11-alpine

ARG SPRING_PROFILES_ACTIVE

ENV SERVER_PORT=8080
ENV APP_HOME=/usr/app/
ENV SECURITY_OPTS="-Dnetworkaddress.cache.negative.ttl=0 -Dnetworkaddress.cache.ttl=0"
ENV CONTAINER_SUPPORT="-XX:+UseContainerSupport"
ENV MAX_RAM_PERCENTAGE="-XX:MaxRAMPercentage=80"
ENV MIN_RAM_PERCENTAGE="-XX:MinRAMPercentage=80"
ENV MAX_HEAP_SIZE="-XX:MaxHeapSize=1024m"
ENV INITIAL_HEAP_SIZE="-XX:InitialHeapSize=512m"
ENV HEAP_NEW_SIZE="-XX:NewSize=32m"
ENV GC="-XX:+UseG1GC"
ENV G1_RESERVE_PERCENT="-XX:G1ReservePercent=10"
ENV STRING_DEDUPLICATION="-XX:+UseStringDeduplication"
ENV VERIFY_NONE="-Xverify:none"
ENV TIERED_STOP_AT_LEVEL="-XX:TieredStopAtLevel=1"

# JCONSOLE
ENV JCONSOLE="-Dcom.sun.management.jmxremote.rmi.port=9090 -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9090 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.local.only=false -Djava.rmi.server.hostname=localhost"

COPY --from=compiler $APP_HOME/service.jar $APP_HOME/service.jar
WORKDIR $APP_HOME
EXPOSE ${SERVER_PORT}

ENV JAVA_OPTS="$SECURITY_OPTS $MAX_RAM_PERCENTAGE $MIN_RAM_PERCENTAGE $MAX_HEAP_SIZE $INITIAL_HEAP_SIZE $GC $G1_RESERVE_PERCENT $STRING_DEDUPLICATION $MAX_GC_PAUSE_MILLIS $CONTAINER_SUPPORT $HEAP_NEW_SIZE $VERIFY_NONE $TIERED_STOP_AT_LEVEL $JCONSOLE"
ENTRYPOINT  exec java $JAVA_OPTS -jar service.jar
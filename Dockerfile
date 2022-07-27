FROM maven:3-openjdk-11 AS build
RUN apt install git
RUN  git clone https://github.com/Ashiquedev/k8s_pipeline_activity1_spc.git && cd k8s_pipeline_activity1_spc/spring-petclinic && mvn clean package

FROM openjdk:11
COPY --from=build k8s_pipeline_activity1_spc/spring-petclinic/target/spring-petclinic-2.7.0-SNAPSHOT.jar /spring-petclinic-2.7.0-SNAPSHOT.jar
EXPOSE 8080
CMD [ "java", "-jar", "/spring-petclinic-2.7.0-SNAPSHOT.jar" ] 
# Etapa 1: Construcción (Build)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copiamos el pom.xml y descargamos dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiamos el código fuente
COPY src ./src

# Empaquetamos la aplicación
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución (Runtime)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copiamos el archivo JAR generado en la Etapa 1
# El nombre "Springboot-API-REST-DESPACHO-0.0.1-SNAPSHOT.jar" viene de tu pom.xml
COPY --from=build /app/target/Springboot-API-REST-DESPACHO-0.0.1-SNAPSHOT.jar app-despachos.jar

# Exponemos el puerto interno por defecto de Spring Boot
EXPOSE 8081

# Comando para iniciar la aplicación
ENTRYPOINT ["java", "-jar", "app-despachos.jar"]
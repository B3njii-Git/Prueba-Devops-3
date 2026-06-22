# Etapa 1: Construcción (Build)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copiamos el pom.xml primero para descargar las dependencias
# (Esto optimiza la caché de Docker y hace los builds futuros más rápidos)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiamos el código fuente de la aplicación
COPY src ./src

# Empaquetamos la aplicación ignorando los tests para agilizar el despliegue
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución (Runtime)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copiamos el archivo JAR generado en la Etapa 1
# El nombre "Springboot-API-REST-0.0.1-SNAPSHOT.jar" viene de tu pom.xml (artifactId + version)
COPY --from=build /app/target/Springboot-API-REST-0.0.1-SNAPSHOT.jar app-ventas.jar

# Exponemos el puerto interno por defecto de Spring Boot
EXPOSE 8080

# Comando para iniciar la aplicación
ENTRYPOINT ["java", "-jar", "app-ventas.jar"]
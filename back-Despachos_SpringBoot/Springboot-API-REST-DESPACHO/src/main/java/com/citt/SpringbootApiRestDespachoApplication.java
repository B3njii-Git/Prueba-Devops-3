package com.citt;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringbootApiRestDespachoApplication {

	public static void main(String[] args) {
		System.out.println("Iniciando microservicio de despachos (Despliegue CI/CD exitoso)...");
		SpringApplication.run(SpringbootApiRestDespachoApplication.class, args);
	}
}

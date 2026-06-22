package com.citt;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringbootApiRestApplication {

	public static void main(String[] args) {
		System.out.println("Iniciando microservicio de ventas (Despliegue CI/CD exitoso)...");
		SpringApplication.run(SpringbootApiRestApplication.class, args);
	}
}

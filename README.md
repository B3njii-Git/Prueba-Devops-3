# Innovatech Chile - Sistema de Ventas y Despachos (AWS ECS)

Este repositorio contiene la arquitectura de microservicios para el sistema de Innovatech Chile. El proyecto está dividido en un **Frontend** (React/Vite) y dos microservicios de **Backend** (Ventas y Despachos desarrollados en Java Spring Boot), soportados por una base de datos **MySQL**.

Toda la infraestructura está dockerizada y orquestada mediante AWS ECS (Elastic Container Service) con AWS Fargate, automatizada mediante un pipeline de CI/CD en GitHub Actions e infraestructura como código con Terraform.

## 1. Monitoreo y Observabilidad (IE1)

Para asegurar la disponibilidad y confiabilidad de los microservicios, hemos implementado el monitoreo usando **AWS CloudWatch**.
A través del archivo Terraform `cloudwatch.tf`, se provisionan:
* **Log Groups (`/ecs/laboratorio-academy`)**: Todos los microservicios envían sus logs en tiempo real a CloudWatch, lo que permite visualizar los registros y errores para auditoría y resolución de problemas.
* **Container Insights**: Permite recopilar, añadir y resumir métricas y logs de contenedores.

## 2. Orquestación y Despliegue en AWS ECS (IE2)

Hemos migrado de un entorno tradicional (EC2/EKS) a **AWS ECS (Elastic Container Service) con Fargate**, logrando un modelo serverless para contenedores.
* **Terraform (`terraform/ecs.tf`)**: Provisiona un Cluster ECS, Tareas (Task Definitions) unificadas y Servicios (ECS Services) para mantener la alta disponibilidad sin infringir las políticas de IAM de AWS Academy.

## 3. Dashboard de Métricas Clave (IE3)

La visibilidad del estado de los servicios se maneja con:
1. **CloudWatch Dashboard**: Implementado a través de Terraform, este panel en AWS muestra el **Uso de CPU**, **Uso de Memoria** y un filtro automatizado para rastrear **Errores registrados en los Logs**.
2. **GitHub Actions UI**: Sirve como panel de despliegue para verificar el **Tiempo de Despliegue**, el estado de la entrega continua y los resultados de las pruebas unitarias y auditorías de código.

## 4. Integración y Toma de Decisiones Técnicas en CI/CD (IE4)

La integración de herramientas en el pipeline y la infraestructura influye directamente en la toma de decisiones técnicas:
* **Decisión de Pase a Producción**: Gracias a los scripts de auditoría y tests obligatorios, no permitimos que código que no pasa las pruebas automatizadas o que expone credenciales se despliegue.
* **Decisión de Escalabilidad**: CloudWatch nos indica cuándo un servicio específico está consumiendo demasiada CPU o Memoria de su Task Definition. Esto permite a los ingenieros tomar decisiones basadas en datos para incrementar la capacidad.

## 5. Políticas de Cumplimiento (IE5)

La calidad y seguridad del software se garantizan mediante políticas de cumplimiento:
* **Scripts Personalizados de Auditoría y Pruebas**: En nuestros flujos de GitHub Actions, analizamos el código para buscar vulnerabilidades mediante `npm audit` (para frontend) y garantizamos la calidad mediante `mvn clean test` (para el backend). Además, agregamos comprobaciones mediante expresiones regulares (`grep`) para asegurar que no se filtren contraseñas o AWS Keys en el código.
* **Branch Protection en GitHub**: Configuradas a nivel de repositorio. Nadie puede hacer push directo a `main`. Se requiere aprobación mediante Pull Request, y el pipeline de CI/CD (incluyendo las pruebas de auditoría de seguridad) debe pasar de manera exitosa obligatoriamente antes de habilitar el "Merge" o integración.

## 6. Falla Crítica Detiene el Pipeline (IE6)

En nuestros archivos de workflows (`.github/workflows/*.yml`), implementamos verificaciones que detienen obligatoriamente el flujo en caso de errores:
* **Demostración en Backend**: Si las pruebas unitarias (`mvn test`) fallan o si el script de seguridad detecta "password=" configurado en texto plano (`exit 1`), el paso falla.
* **Demostración en Frontend**: Se implementa `npm audit --audit-level=critical`. Si se descubre alguna vulnerabilidad de dependencias catalogada como crítica, el proceso retorna un error de salida y falla.
* **Resultado del bloqueo**: GitHub Actions recibe este estado negativo, el paso de validación falla automáticamente, y **el pipeline se detiene por completo**, cancelando todos los pasos posteriores y bloqueando la ejecución del despliegue (`aws ecs update-service`). Esto garantiza de forma robusta que ningún código defectuoso llegue a AWS ECS.

---

### Infraestructura con Terraform
Para provisionar la infraestructura:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

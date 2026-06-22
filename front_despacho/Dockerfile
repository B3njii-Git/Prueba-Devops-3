# --- ETAPA 1: Construcción (Builder) ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# --- ETAPA 2: Producción con Nginx ---
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# AQUÍ AGREGAS TU CONFIGURACIÓN DE NGINX PARA LOS DOS BACKENDS
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
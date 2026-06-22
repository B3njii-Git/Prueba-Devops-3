import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      // 1. Proxy local para Despachos
      '/backend-despachos': {
        target: 'http://54.157.186.66:8082', // Reemplaza con la IP actual de desarrollo si cambia
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/backend-despachos/, '')
      },
      // 2. Proxy local para Ventas
      '/backend-ventas': {
        target: 'http://54.157.186.66:8081', // Asumiendo que están en la misma máquina, pero en el puerto 8081
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/backend-ventas/, '')
      }
    }
  }
})
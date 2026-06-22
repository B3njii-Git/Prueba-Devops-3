import React from "react";
import ReactDOM from "react-dom/client";
import AppRoutes from "./Routes/AppRoutes.jsx";
import "./index.css";

console.log("Iniciando aplicación frontend - Despliegue CI/CD exitoso");

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <AppRoutes />
  </React.StrictMode>
);

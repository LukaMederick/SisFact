# SisFact - Backend en Go (Golang) & Base de Datos PostgreSQL / PostgREST

Este backend provee la API RESTful de alta velocidad para el sistema de ventas y facturación **SisFact**, con compatibilidad nativa para PostgreSQL y PostgREST.

## 🚀 Requisitos
- Go 1.22 o superior (o Goland IDE)
- Docker y Docker Compose (opcional para PostgreSQL y PostgREST)

## 📁 Estructura del Proyecto
- `cmd/api/main.go`: Punto de entrada del servidor Go.
- `internal/handlers/`: Controladores de endpoints REST (`/api/dashboard`, `/api/products`, `/api/shifts`, `/api/sales`, `/api/cash-registers`).
- `internal/models/`: Estructuras de datos (Branch, Product, Shift, Sale, etc.).
- `internal/repository/`: Capa de datos con soporte en memoria + PostgreSQL (`pgx`/`sql`).
- `sql/01_schema.sql`: DDL completo de PostgreSQL optimizado para PostgREST.
- `sql/02_seed.sql`: Datos semilla para sucursal inicial, usuario y caja principal.
- `docker-compose.yml`: Orquestación de PostgreSQL 15, PostgREST v12 y Go API.

## 💻 Ejecución Local

### Opción 1: Ejecutar solo el servidor Go (Modo local / Autónomo)
```bash
go run ./cmd/api/main.go
```
El servidor iniciará en `http://localhost:8080`.

### Opción 2: Levantar PostgreSQL + PostgREST + Go API con Docker
```bash
docker-compose up -d
```
- **Go API**: `http://localhost:8080/api/health`
- **PostgREST API**: `http://localhost:3000`
- **PostgreSQL**: `localhost:5432` (Usuario: `sisfact_user`, Base de datos: `sisfact_db`)

## 🛠️ Endpoints Principales
- `GET /api/dashboard`: Métricas en vivo del día, total 7 días, promedio y estado de jornada.
- `GET /api/products`: Lista de productos en inventario.
- `POST /api/products`: Crear un nuevo producto con código de barras, precio, costo y stock.
- `GET /api/shifts/current`: Obtener jornada activa.
- `POST /api/shifts/open`: Abrir jornada de caja con monto inicial y notas.
- `POST /api/shifts/close`: Cerrar jornada con arqueo y notas de cierre.
- `GET /api/sales`: Historial de ventas filtradas por fecha.
- `GET /api/sales/kpis`: KPIs (Total Ventas, Ingresos S/, Ticket Promedio S/, Productos Vendidos).
- `POST /api/sales`: Registrar nueva venta y actualizar stock.
- `GET /api/cash-registers`: Lista de cajas registradoras y estados.

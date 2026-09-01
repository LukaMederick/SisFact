# SisFact - Backend en Go (Golang) & Base de Datos PostgreSQL / PostgREST

Este backend provee la API RESTful de alta velocidad para el sistema de ventas y facturación **SisFact**, con compatibilidad nativa para PostgreSQL y PostgREST.

## 🚀 Requisitos y Versiones
- **Go**: 1.22 o superior (Probado en `go1.26.x` / `go1.22.x`)
- **Docker & Docker Compose**: Opcional para PostgreSQL 15 y PostgREST v12

## 📁 Estructura del Proyecto
- `main.go`: Punto de entrada directo en la raíz del backend.
- `cmd/api/main.go`: Punto de entrada modular estándar.
- `internal/handlers/`: Controladores de endpoints REST (`/api/dashboard`, `/api/products`, `/api/shifts`, `/api/sales`, `/api/cash-registers`).
- `internal/models/`: Estructuras de datos (Branch, Product, Shift, Sale, etc.).
- `internal/repository/`: Capa de datos con soporte en memoria + PostgreSQL (`pgx`/`sql`).
- `sql/01_schema.sql`: DDL completo de PostgreSQL optimizado para PostgREST.
- `sql/02_seed.sql`: Datos semilla para sucursal inicial, usuario y caja principal.
- `docker-compose.yml`: Orquestación de PostgreSQL 15, PostgREST v12 y Go API.

## 💻 Ejecución Local

### Opción 1: Ejecutar solo el servidor Go (Modo local / Autónomo)

1. Posiciónate en la carpeta `backend`:
   ```bash
   cd backend
   ```

2. Descarga dependencias:
   ```bash
   go mod download
   ```

3. Inicia el servidor:
   ```bash
   go run main.go
   ```
   *(o también `go run ./cmd/api/main.go`)*

El servidor iniciará en: `http://localhost:8080`.

---

### Opción 2: Levantar PostgreSQL + PostgREST + Go API con Docker
```bash
docker compose up -d
```
- **Go API**: `http://localhost:8080/api/health`
- **PostgREST API**: `http://localhost:3000`
- **PostgreSQL**: `localhost:5432` (Usuario: `sisfact_user`, Base de datos: `sisfact_db`)

## 🛠️ Endpoints Principales
- `GET /api/health`: Estado del servicio.
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

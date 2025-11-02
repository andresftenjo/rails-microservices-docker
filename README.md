Ruby on Rails Microservices — Customers, Invoices & Audit
📘 Overview

This repository implements a simple microservices-based system in Ruby on Rails 7 using PostgreSQL.
It includes three independent services that communicate via REST APIs:

Service Description Port
Customers Service Manages client registration and lookup. 3001
Invoices Service Handles invoice creation, validation, and listing. 3002
Audit Service Records events and errors from other services. 3003

All services use:

Rails + MVC

PostgreSQL

RSwag (Swagger) for API documentation

Docker Compose for orchestration

🚀 How to Run
Option 1 — Run Everything via Docker

🐳 Requires Docker Desktop
or Docker Engine + Compose Plugin.

# From the repo root

docker compose build
docker compose up

✅ Once running:

Service URL Swagger Docs
Customers http://localhost:3001
http://localhost:3001/api-docs

Invoices http://localhost:3002
http://localhost:3002/api-docs

Audit http://localhost:3003
http://localhost:3003/api-docs

PostgreSQL runs internally on postgres:5432 (or 5555 externally if you mapped the port).

Option 2 — Run Locally (WSL or Linux)

Start PostgreSQL locally:

sudo service postgresql start

Run each service individually:

# Terminal 1

cd customers_service
rails s -p 3001

# Terminal 2

cd invoices_service
rails s -p 3002

# Terminal 3

cd audit_service
rails s -p 3003

Access the same URLs as above.

🧩 Folder Structure & Architecture

Each service follows a simplified Clean Architecture layered with MVC (Model-View-Controller) principles.

service_name/
├── app/
│ ├── controllers/ # Entry points (REST endpoints)
│ ├── models/ # Business entities (ActiveRecord)
│ └── services/ # Optional application logic layer
├── config/
│ ├── database.yml # PostgreSQL config
│ └── routes.rb # REST endpoint mapping
├── db/
│ └── migrate/ # Schema migrations
├── spec/ # RSpec + RSwag tests
├── swagger/ # Swagger API docs
├── Dockerfile
└── Gemfile

🧠 Clean Architecture in Action
Layer Responsibility Example
Domain (Model) Core data entities and validations Customer, Invoice, AuditEvent
Application (Services) Business rules and operations Validation and audit logging
Infrastructure DB persistence and HTTP communication PostgreSQL, Faraday requests
Presentation (Controller) Handles API requests and responses ClientesController, FacturasController

All API responses follow a standardized JSON format:

{
"data": {...},
"status": "ok",
"errors": []
}

🧪 Example Endpoints
🔹 Customers Service (http://localhost:3001
)

Create Customer

curl -X POST http://localhost:3001/clientes \
 -H "Content-Type: application/json" \
 -d '{
"name": "TechCorp",
"identification": "900123456",
"email": "info@techcorp.com",
"address": "123 Main St"
}'

✅ Response:

{
"data": {
"id": 1,
"name": "TechCorp",
"identification": "900123456",
"email": "info@techcorp.com",
"address": "123 Main St"
},
"status": "ok",
"errors": []
}

Get All Customers

curl http://localhost:3001/clientes

🔹 Invoices Service (http://localhost:3002
)

Create Invoice

curl -X POST http://localhost:3002/facturas \
 -H "Content-Type: application/json" \
 -d '{
"customer_id": 1,
"amount": 1250.50,
"issued_on": "2025-10-31",
"notes": "October service fee"
}'

✅ Response:

{
"data": {
"id": 1,
"customer_id": 1,
"amount": "1250.5",
"issued_on": "2025-10-31",
"notes": "October service fee"
},
"status": "ok",
"errors": []
}

List Invoices

curl "http://localhost:3002/facturas?fechaInicio=2025-01-01&fechaFin=2025-12-31"

🔹 Audit Service (http://localhost:3003
)

Create Audit Record

curl -X POST http://localhost:3003/auditoria \
 -H "Content-Type: application/json" \
 -d '{
"event_type": "CREATE_INVOICE",
"entity": "Invoice",
"details": "Invoice ID 1 created for customer 1"
}'

✅ Response:

{
"data": {
"id": 1,
"event_type": "CREATE_INVOICE",
"entity": "Invoice",
"details": "Invoice ID 1 created for customer 1"
},
"status": "ok",
"errors": []
}

Get Audit Logs

curl http://localhost:3003/auditoria/1

🧠 Environment Variables

Each service uses a .env file with the following variables:

PGUSER=andres
PGPASSWORD=your_password
PGHOST=postgres
PGPORT=5432
PGDATABASE=audit_service_development
CUSTOMERS_BASE_URL=http://customers_service:3001
AUDIT_BASE_URL=http://audit_service:3003

(Each service has its own database name.)

📚 API Documentation (Swagger)

Each service includes a Swagger UI available at /api-docs:

Customers → http://localhost:3001/api-docs

Invoices → http://localhost:3002/api-docs

Audit → http://localhost:3003/api-docs

These interfaces allow you to visualize and test endpoints interactively.

🧩 Clean Development Workflow

Edit code in your local service folders.

Rebuild with:

docker compose build

Test all APIs:

curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health

Access Swagger UIs for visual validation.

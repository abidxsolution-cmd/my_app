# Backend API

This folder contains a Dart backend for your website/app.

## Endpoints

- `GET /api/health` – health check.
- `POST /api/calculate` – returns calculator result.

### Request body for `/api/calculate`

```json
{
  "num1": 12,
  "num2": 3,
  "operation": "/"
}
```

Supported operations: `+`, `-`, `*`, `×`, `/`, `÷`.

## Run locally

```bash
cd backend
dart pub get
dart run bin/server.dart
```

Server starts on `http://localhost:8080` by default.

Set custom port:

```bash
PORT=3000 dart run bin/server.dart
```

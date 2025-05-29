# Big Bad Monolith

A Jakarta EE sample application with Derby database integration.

## Features

- JAX-RS REST API endpoints
- DAO pattern with raw JDBC for database persistence
- Embedded Derby database for local development
- User management with CRUD operations

## Build & Run

```bash
# Build the project
./gradlew build

# Run tests
./gradlew test

# Generate WAR file
./gradlew war
```

## API Endpoints

- `GET /api/users` - List all users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user

Example user creation:
```json
{
  "email": "user@example.com",
  "name": "John Doe"
}
```

## Database

The application uses an embedded Derby database stored in `./data/bigbadmonolith`. The database and tables are automatically created on first run using raw JDBC.

# Big Bad Monolith

A Jakarta EE sample application implementing a billing platform where users can track billable hours for customers across different categories. Features Derby database integration and comprehensive REST API endpoints.

## Features

- DAO pattern with raw JDBC for database persistence
- Embedded Derby database for local development
- Complete billing platform functionality
- User and customer management
- Billable hours tracking with categories
- Billing reports and revenue calculations
- Sample data auto-initialization
- Legacy JSP web interface demonstrating anti-patterns

## Domain Model

### Core Entities
- **User**: Represents employees who log billable hours
- **Customer**: Companies that are billed for services
- **BillingCategory**: Categories of work with associated hourly rates (e.g., Development, Consulting, Support)
- **BillableHour**: Individual time entries with hours (BigDecimal), notes, and date logged

### Database Schema
```sql
users (id, email, name)
customers (id, name, email, address, created_at)
billing_categories (id, name, description, hourly_rate)
billable_hours (id, customer_id, user_id, category_id, hours, note, date_logged, created_at)
```

## Build & Run

```bash
# Build the project
./gradlew build

# Run tests
./gradlew test

# Generate WAR file
./gradlew war
```

## Architecture

This application demonstrates a legacy JSP-based architecture with the following anti-patterns:

### Data Access Layer
- **DAO Pattern**: Raw JDBC implementation for database operations
- **Connection Management**: Manual connection handling (legacy pattern)
- **Transaction Management**: No explicit transaction boundaries

### Presentation Layer (JSP)
- **Scriptlets**: Java code mixed directly with HTML markup
- **Business Logic in JSP**: Complex calculations and validations in presentation layer
- **Direct DAO Instantiation**: DAOs created directly in JSP pages
- **Resource Management**: Database connections handled in JSP

### Anti-Patterns Demonstrated
- **Scriptlet Hell**: Extensive use of `<% %>` blocks
- **Tight Coupling**: Direct instantiation of dependencies
- **Mixed Concerns**: Presentation, business logic, and data access in same files
- **Poor Error Handling**: Technical errors exposed to users
- **No Input Validation**: Raw form parameters used without sanitization

## Sample Data

The application automatically initializes with sample data including:
- 2 users (John Doe, Jane Smith)
- 3 customers (Acme Corp, TechStart Inc, MegaCorp Ltd)
- 3 billing categories (Development $150/hr, Consulting $200/hr, Support $100/hr)
- Multiple billable hour entries across different customers and categories

## Database

The application uses an embedded Derby database stored in `./data/bigbadmonolith`. The database and tables are automatically created on first run using raw JDBC.

## Running the Application

### Option 1: WebSphere Liberty (Recommended)

#### Development Mode
```bash
# Start Liberty in development mode (auto-reload on changes)
./liberty-dev.sh        # Linux/macOS
liberty-dev.bat         # Windows
```

#### Manual Liberty Deployment
```bash
# Build the application
./gradlew build

# Start Liberty server with the application
./gradlew libertyStart

# Stop Liberty server
./gradlew libertyStop
```

#### Docker Deployment
```bash
# Build and run with Docker Compose
docker-compose up --build

# Or build Docker image manually
docker build -t big-bad-monolith .
docker run -p 9080:9080 -p 9443:9443 big-bad-monolith
```

### Option 2: Other Jakarta EE Application Servers

1. Build: `./gradlew build`
2. Deploy the generated WAR file (`build/libs/big-bad-monolith-1.0-SNAPSHOT.war`) to your Jakarta EE application server
3. Access API at: `http://localhost:[port]/big-bad-monolith/api/`

## Access Points

### Web Interface
- **Liberty Development**: `http://localhost:9080/big-bad-monolith/`
- **Liberty HTTPS**: `https://localhost:9443/big-bad-monolith/`
- **Docker**: `http://localhost:9080/big-bad-monolith/`

## Web Interface

The application includes a complete JSP-based web interface providing:

- **Dashboard** - Overview of customers, users, and revenue metrics
- **Customer Management** - Add, view, and manage customer information
- **User Management** - Add and view system users  
- **Billing Categories** - Manage work categories and hourly rates
- **Time Logging** - Log billable hours with detailed tracking
- **Reporting** - Generate customer bills, monthly summaries, and revenue reports

The web interface demonstrates traditional JSP-based architecture patterns commonly found in legacy enterprise applications that need modernization. The application showcases numerous anti-patterns that training participants will learn to identify and refactor.

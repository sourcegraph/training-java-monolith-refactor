# Agent Instructions for big-bad-monolith

## ⚠️ Important: This is a Legacy Training Application

This application intentionally contains **legacy anti-patterns** and **security vulnerabilities** for educational purposes. It demonstrates common issues found in legacy enterprise applications that need modernization.

**DO NOT use patterns from this codebase in production applications.**

## Application Architecture (Current Legacy State)

- **Presentation Layer**: JSP files with extensive Java scriptlets (anti-pattern)
- **Business Logic**: Mixed between JSP pages and service classes (anti-pattern)
- **Data Access**: DAO classes with inconsistent error handling
- **Database**: Apache Derby embedded database
- **No REST APIs**: Pure JSP/servlet-based web application
- **No Tests**: Part of training is to add comprehensive test coverage

## Build/Test Commands
- **Build**: `./gradlew build` (compiles application, currently no tests)
- **Clean build**: `./gradlew clean build`
- **Test only**: `./gradlew test` (will show NO-SOURCE until tests are added)
- **Single test**: `./gradlew test --tests "ClassName.methodName"`
- **Compile only**: `./gradlew compileJava`
- **Generate WAR**: `./gradlew war`

## Liberty Server Commands
- **Start Liberty dev mode**: `./liberty-dev.sh` (Linux/macOS) or `liberty-dev.bat` (Windows)
- **Start Liberty server**: `./gradlew libertyStart`
- **Stop Liberty server**: `./gradlew libertyStop`
- **Deploy to Liberty**: `./gradlew libertyDeploy`
- **Check server status**: `./gradlew libertyStatus`

## Docker Commands
- **Build and run**: `docker-compose up --build`
- **Run in background**: `docker-compose up -d`
- **Stop containers**: `docker-compose down`
- **View logs**: `docker-compose logs -f`

## Application URLs (when running)
- **Main Application**: http://localhost:9080/big-bad-monolith/
- **Customer Management**: http://localhost:9080/big-bad-monolith/customers.jsp
- **Hours Logging**: http://localhost:9080/big-bad-monolith/hours.jsp
- **Reports**: http://localhost:9080/big-bad-monolith/reports.jsp
- **Categories**: http://localhost:9080/big-bad-monolith/categories.jsp
- **Users**: http://localhost:9080/big-bad-monolith/users.jsp

## Current Legacy Code Patterns (Intentional Anti-Patterns)

### JSP Layer Issues
- **Scriptlet Hell**: Hundreds of lines of Java code in JSP files
- **Direct Database Access**: JDBC connections opened in presentation layer
- **Business Logic in JSPs**: Calculations and validations in presentation
- **SQL Injection Vulnerability**: String concatenation in `categories.jsp`
- **Resource Leaks**: Database connections not properly managed
- **No Input Validation**: Raw form parameters used directly

### DAO Layer Issues
- **Inconsistent Null Handling**: Some DAOs check nulls, others don't
- **Mixed Error Handling**: SQLException vs RuntimeException inconsistency
- **No Transaction Management**: Auto-commit mode for all operations

### Service Layer Issues
- **Tight Coupling**: Direct instantiation instead of dependency injection
- **Mixed Responsibilities**: Utility methods mixed with business logic

### Utility Classes Issues
- **Legacy Date/Time**: Uses deprecated Joda-Time instead of java.time
- **Thread Safety Issues**: Static SimpleDateFormat (not thread-safe)
- **Magic Numbers**: Hardcoded values without constants

## File Structure
```
src/main/
├── java/com/sourcegraph/demo/bigbadmonolith/
│   ├── dao/                    # Data Access Objects (mixed quality)
│   │   ├── CustomerDAO.java    # GOOD: Has null checks
│   │   ├── UserDAO.java        # BAD: No null checking, NPE vulnerable
│   │   ├── BillableHourDAO.java # BAD: No null checking
│   │   └── BillingCategoryDAO.java # MIXED: Partial null checking
│   ├── entity/                 # Entity classes (use Joda-Time)
│   ├── service/                # Service classes (tight coupling)
│   └── util/                   # Utilities (thread safety issues)
└── webapp/                     # JSP files (scriptlet hell)
    ├── index.jsp               # Dashboard with business logic
    ├── customers.jsp           # Customer CRUD with validation in JSP
    ├── hours.jsp               # Complex reporting logic in JSP
    ├── reports.jsp             # Advanced business calculations in JSP
    ├── categories.jsp          # SQL INJECTION VULNERABLE
    └── users.jsp               # Complex aggregations in JSP
```

## Training Objectives

Trainees should learn to identify and fix:
1. **Security vulnerabilities** (SQL injection in categories.jsp)
2. **Null pointer exceptions** (UserDAO, BillableHourDAO)
3. **Resource management** issues (connection leaks in JSPs)
4. **Thread safety** problems (DateTimeUtils)
5. **Architectural issues** (business logic in presentation layer)
6. **Legacy dependencies** (Joda-Time migration)

## Development Guidelines for Refactoring

### Testing Strategy (Add Tests First!)
- **Characterization Tests**: Document current behavior before changing
- **Integration Tests**: Test JSP workflows end-to-end
- **Security Tests**: Prove vulnerabilities exist, then verify fixes
- **Performance Tests**: Measure before/after improvements

### Refactoring Approach
1. **Phase 1**: Fix critical security issues and NPEs
2. **Phase 2**: Extract business logic from JSPs to services
3. **Phase 3**: Modernize date/time handling
4. **Phase 4**: Implement proper MVC pattern with JAX-RS
5. **Phase 5**: Add dependency injection and clean architecture

### Code Style (For New/Refactored Code)
- **Java 17** with modern features
- **Package structure**: `com.sourcegraph.demo.bigbadmonolith`
- **Testing**: JUnit 5 framework (`org.junit.jupiter.*`)
- **Date/Time**: Use `java.time.*` not Joda-Time
- **Database**: Keep DAO pattern but add proper error handling
- **REST APIs**: When adding, use JAX-RS annotations
- **Validation**: Add proper input validation and sanitization
- **Error Handling**: Consistent exception handling strategies
- **Dependencies**: Add to `build.gradle`
- **Resources**: Keep web resources in `src/main/webapp/`

## Useful Sourcegraph Searches for Training

### Finding Anti-Patterns
```bash
# SQL injection vulnerabilities
content:"executeUpdate.*\\+" file:.jsp

# Null pointer vulnerabilities  
content:"\\w+\\.get\\w+\\(" -content:"null.*check" lang:java

# Resource leaks
content:"getConnection" -content:"try.*resources" file:.jsp

# Thread safety issues
content:"static.*SimpleDateFormat" lang:java

# Business logic in JSPs
content:"while.*rs\\.next" file:.jsp

# Joda-Time usage
content:"import org.joda.time" lang:java
```

### Tracking Refactoring Progress
```bash
# After adding null safety
content:"throw new IllegalArgumentException" lang:java

# After adding tests
file:Test.java content:"@Test"

# After modernizing dates
content:"java.time.Local" lang:java

# After adding REST APIs
content:"@Path" lang:java
```

## Database Information
- **Type**: Apache Derby (embedded)
- **Location**: `./data/bigbadmonolith` directory
- **Schema**: Auto-created by `ConnectionManager.java`
- **Tables**: customers, users, billing_categories, billable_hours
- **Test Data**: Created by `DataInitializationService.java`

## Common Issues During Development

### Build Issues
- Run `./gradlew clean build` if encountering compilation errors
- JSP compilation errors may not show clearly - check Liberty logs

### Database Issues
- Delete `./data/` directory to reset database
- Derby sometimes locks - restart Liberty server if needed

### Liberty Server Issues
- Check `logs/messages.log` for detailed error information
- Use `./gradlew libertyStop` then `./gradlew libertyStart` to restart

Remember: This is intentionally bad code for educational purposes!

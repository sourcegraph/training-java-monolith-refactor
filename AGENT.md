# Agent Instructions for big-bad-monolith

## Build/Test Commands
- **Build**: `./gradlew build` (compiles and runs tests)
- **Clean build**: `./gradlew clean build`
- **Test only**: `./gradlew test`
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

## Code Style Guidelines
- **Java 17** project with Jakarta EE and JAX-RS
- **Package structure**: `com.sourcegraph.demo.bigbadmonolith`
- **Imports**: Use Jakarta EE (`jakarta.*`) not Java EE (`javax.*`)
- **REST endpoints**: Use JAX-RS annotations (`@Path`, `@GET`, `@POST`, etc.)
- **Database access**: Use DAO pattern with raw JDBC, not JPA/Hibernate
- **Naming**: CamelCase for classes, camelCase for methods/variables
- **Encoding**: UTF-8 for all source files
- **Testing**: JUnit 5 framework (`org.junit.jupiter.*`)
- **Error handling**: Use JAX-RS exception mappers for REST APIs
- **Dependencies**: Add to `build.gradle`, prefer Jakarta EE APIs
- **Resources**: Place web resources in `src/main/webapp/`
- **Configuration**: Use standard Jakarta EE configuration patterns

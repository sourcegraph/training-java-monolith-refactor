# Agent Instructions for big-bad-monolith

## Build/Test Commands
- **Build**: `./gradlew build` (compiles and runs tests)
- **Clean build**: `./gradlew clean build`
- **Test only**: `./gradlew test`
- **Single test**: `./gradlew test --tests "ClassName.methodName"`
- **Compile only**: `./gradlew compileJava`
- **Generate WAR**: `./gradlew war`

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

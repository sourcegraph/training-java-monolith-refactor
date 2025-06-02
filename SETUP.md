# Developer Setup Guide

## Prerequisites

### Required Software (Install Yourself)

#### Java Runtime
- **Java 17 or higher** (OpenJDK recommended)
  - Download from [Eclipse Temurin](https://adoptium.net/) or [Oracle](https://www.oracle.com/java/technologies/downloads/)
  - Verify installation: `java -version`
  - Must have `JAVA_HOME` environment variable set



#### Git
- **Git** version control
  - [Download Git](https://git-scm.com/downloads)
  - Verify installation: `git --version`

#### IDE (Recommended)
- **IntelliJ IDEA** (Community or Ultimate)
  - [Download IntelliJ IDEA](https://www.jetbrains.com/idea/download/)
  - Alternative: Eclipse IDE with Java EE support
  - Alternative: Visual Studio Code with Java extensions

### What Gradle Handles Automatically

The following are **automatically downloaded and managed** by Gradle - you don't need to install these:

#### Application Dependencies
- **Open Liberty** server runtime
- **Apache Derby** database drivers
- **Joda-Time** library (legacy dependency)
- **JSTL** (JSP Standard Tag Library)
- **Servlet API** specifications
- **JUnit 5** testing framework (when tests are added)

#### Build Tools
- **Gradle Wrapper** (included in project)
- **Liberty Gradle Plugin** for server management
- **War Plugin** for web application packaging
- All build and runtime dependencies defined in `build.gradle`

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/sourcegraph/training-java-monolith-refactor.git
cd big-bad-monolith
```

### 2. Verify Java Installation
```bash
java -version
javac -version
echo $JAVA_HOME    # Linux/macOS
echo %JAVA_HOME%   # Windows
```

**Expected output**: Java 17+ version information

### 3. Build the Application
```bash
# Initial build (downloads all dependencies)
./gradlew build

# Clean build if needed
./gradlew clean build
```

**What happens during build:**
- Gradle downloads Liberty server runtime
- Downloads all Java dependencies
- Compiles Java source code
- Packages application as WAR file
- No tests run (they don't exist yet - part of training!)

### 4. Start the Application

#### Option A: Liberty Development Mode (Recommended)
```bash
# Linux/macOS
./liberty-dev.sh

# Windows
liberty-dev.bat
```

#### Option B: Standard Liberty Server
```bash
./gradlew libertyStart
./gradlew libertyDeploy
```



### 5. Verify Setup
- Open browser to: http://localhost:9080/big-bad-monolith/
- You should see the application dashboard
- Test navigation to different pages (customers, hours, reports)

## Development Environment Configuration

### IDE Setup (IntelliJ IDEA)

1. **Import Project**
   - File → Open → Select `big-bad-monolith` directory
   - Choose "Import Gradle project"
   - Use Gradle wrapper

2. **Configure Project SDK**
   - File → Project Structure → Project
   - Set Project SDK to Java 17+

3. **Enable Auto-Import**
   - File → Settings → Build → Gradle
   - Check "Auto-import"

### IDE Setup (Eclipse)

1. **Import Project**
   - File → Import → Existing Gradle Project
   - Select `big-bad-monolith` directory

2. **Configure Build Path**
   - Right-click project → Properties → Java Build Path
   - Verify Java 17+ is selected

### Environment Variables

Set these environment variables for optimal development:

```bash
# Required
export JAVA_HOME=/path/to/java17

# Optional (for development)
export GRADLE_OPTS="-Xmx2g -XX:MaxMetaspaceSize=512m"
export JAVA_OPTS="-Xmx1g"
```

## Directory Structure Overview

```
big-bad-monolith/
├── src/main/java/               # Java source code
│   └── com/sourcegraph/demo/
├── src/main/webapp/             # JSP files and web resources
├── src/test/java/               # Test code (to be created)
├── build/                       # Generated build files
├── data/                        # Derby database files
├── gradle/                      # Gradle wrapper files
├── logs/                        # Liberty server logs
└── build.gradle                 # Build configuration
```

## Common Build Commands

### Basic Operations
```bash
# Build application
./gradlew build

# Clean and rebuild
./gradlew clean build

# Compile only (no packaging)
./gradlew compileJava

# Run tests (when they exist)
./gradlew test

# Generate WAR file
./gradlew war
```

### Liberty Server Management
```bash
# Start server
./gradlew libertyStart

# Stop server
./gradlew libertyStop

# Deploy application
./gradlew libertyDeploy

# Check server status
./gradlew libertyStatus

# Development mode with hot reload
./liberty-dev.sh
```



## Troubleshooting

### Java Issues
- **Problem**: `JAVA_HOME not set`
  - **Solution**: Set JAVA_HOME environment variable to Java installation path

- **Problem**: `java.lang.UnsupportedClassVersionError`
  - **Solution**: Upgrade to Java 17 or higher

### Build Issues
- **Problem**: `Permission denied: ./gradlew`
  - **Solution**: `chmod +x gradlew` (Linux/macOS)

- **Problem**: Build fails with dependency errors
  - **Solution**: `./gradlew clean build --refresh-dependencies`

### Server Issues
- **Problem**: Port 9080 already in use
  - **Solution**: Stop other applications or change port in `build.gradle`

- **Problem**: Derby database locked
  - **Solution**: Stop Liberty server, delete `data/` directory, restart

- **Problem**: Hot reload not working
  - **Solution**: Use Liberty dev mode: `./liberty-dev.sh`

### Database Issues
- **Problem**: Database corruption or strange data
  - **Solution**: Delete `data/` directory and restart application

- **Problem**: Connection timeout errors
  - **Solution**: Restart Liberty server: `./gradlew libertyStop libertyStart`

## Development Workflow

### Making Code Changes
1. **JSP Changes**: Auto-reload in Liberty dev mode
2. **Java Changes**: Compile with `./gradlew compileJava`
3. **Configuration Changes**: Restart server
4. **Database Schema Changes**: Delete `data/` directory

### Adding Dependencies
1. Edit `build.gradle`
2. Add dependency to appropriate configuration block
3. Run `./gradlew build --refresh-dependencies`

### Running Tests (When Added)
```bash
# All tests
./gradlew test

# Specific test class
./gradlew test --tests "CustomerDAOTest"

# Specific test method
./gradlew test --tests "CustomerDAOTest.testFindById"

# Tests with output
./gradlew test --info
```

## Performance Considerations

### Development Mode Settings
- Liberty dev mode provides hot reload but may be slower
- Use standard server mode for performance testing

### Build Performance
- Gradle daemon improves build times (enabled by default)
- Use `./gradlew build --parallel` for faster builds
- Consider increasing Gradle heap size: `export GRADLE_OPTS="-Xmx2g"`

## Security Notes

⚠️ **This application contains intentional security vulnerabilities for training purposes:**
- SQL injection vulnerabilities
- Null pointer exception vulnerabilities
- Resource management issues

**Do not deploy this application to production environments!**

## Getting Help

### Log Locations
- **Liberty Server**: `logs/messages.log`
- **Application**: `logs/trace.log`
- **Derby Database**: `derby.log`
- **Gradle**: Build output in terminal

### Useful Commands for Debugging
```bash
# View server logs
tail -f logs/messages.log

# Check running processes
jps -l

# Check port usage
netstat -an | grep 9080    # Linux/macOS
netstat -an | findstr 9080 # Windows
```

### Additional Resources
- [Open Liberty Documentation](https://openliberty.io/docs/)
- [Gradle User Guide](https://docs.gradle.org/current/userguide/userguide.html)
- [Apache Derby Documentation](https://db.apache.org/derby/docs/)

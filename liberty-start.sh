#!/bin/bash

# Liberty Production Server Startup Script
# This script starts the Liberty server in regular mode (not development mode)

echo "Starting Big Bad Monolith on WebSphere Liberty..."
echo "======================================================="

# Build the application first
echo "Building application..."
./gradlew clean build

if [ $? -ne 0 ]; then
    echo "Build failed. Please check the errors above."
    exit 1
fi

# Enable debug options for libertyStart
echo "Enabling debug options for production mode..."
sed -i '' 's/# -Xdebug/-Xdebug/' src/main/liberty/config/jvm.options
sed -i '' 's/# -Xrunjdwp/-Xrunjdwp/' src/main/liberty/config/jvm.options

# Start Liberty server
echo "Starting Liberty server..."
./gradlew libertyStart

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Server started successfully!"
    echo "🌐 Web Interface: http://localhost:9080/big-bad-monolith"
    echo "🐛 Debug Port: 7777"
    echo ""
    echo "To stop the server, run: ./gradlew libertyStop"
    echo "To view logs, run: ./gradlew libertyStatus"
else
    echo "❌ Failed to start server. Please check the logs."
    # Restore debug options to commented state
    sed -i '' 's/-Xdebug/# -Xdebug/' src/main/liberty/config/jvm.options
    sed -i '' 's/-Xrunjdwp/# -Xrunjdwp/' src/main/liberty/config/jvm.options
    exit 1
fi

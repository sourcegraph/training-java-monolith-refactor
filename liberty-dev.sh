#!/bin/bash

# Liberty Development Server Startup Script
# This script starts the Liberty server in development mode

echo "Starting Big Bad Monolith on WebSphere Liberty..."
echo "======================================================="

# Build the application first
echo "Building application..."
./gradlew clean build

if [ $? -ne 0 ]; then
    echo "Build failed. Please check the errors above."
    exit 1
fi

# Start Liberty in development mode
echo "Starting Liberty server in development mode..."
echo "🌐 Web Interface: http://localhost:9080/big-bad-monolith"
echo "🐛 Debug Port: Automatically configured by libertyDev"
echo ""
echo "Development mode features:"
echo "  ✅ Automatic reload on code changes"
echo "  ✅ Automatic test execution"
echo "  ✅ Debug support"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

./gradlew libertyDev

echo "Server stopped."

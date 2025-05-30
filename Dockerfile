FROM icr.io/appcafe/websphere-liberty:23.0.0.12-kernel-slim-java17-openj9-ubi

# Copy Liberty server configuration
COPY --chown=1001:0 src/main/liberty/config/ /config/

# Copy the application WAR file
COPY --chown=1001:0 build/libs/big-bad-monolith-1.0-SNAPSHOT.war /config/dropins/

# Copy Derby JAR files
COPY --chown=1001:0 build/libs/derby*.jar /config/derby/

# Set environment variables
ENV WLP_LOGGING_CONSOLE_FORMAT=SIMPLE
ENV WLP_LOGGING_CONSOLE_LOG_LEVEL=INFO

# Expose ports
EXPOSE 9080 9443

# Configure Liberty features
RUN features.sh

# Run the server
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]

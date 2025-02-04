# FROM tomcat:8.0-alpine

# RUN rm -r /usr/local/tomcat/webapps/ROOT

# ADD ROOT.war /usr/local/tomcat/webapps/

# EXPOSE 8080
# CMD ["catalina.sh", "run"]

# Use the official Tomcat image as the base image
FROM tomcat:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Ensure the correct location of web.xml
RUN mkdir -p src/main/webapp/WEB-INF
COPY web/WEB-INF/web.xml src/main/webapp/WEB-INF/web.xml

# Install Maven, build the WAR, and deploy it to Tomcat
RUN apt-get update && apt-get install -y maven && \
    mvn clean package && \
    cp *.war /usr/local/tomcat/webapps/ && \
    apt-get remove -y maven && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

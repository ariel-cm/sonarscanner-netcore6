FROM openjdk:11.0.13-jre-slim

# Dockerfile meta-information
LABEL maintainer="ariel-cm" \
    app_name="netcore6-sonar"


RUN apt-get update \
    && apt-get install wget -y

# Register Microsoft key and feed
RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
   && dpkg -i packages-microsoft-prod.deb \
   && rm packages-microsoft-prod.deb

# Install DotNetCore 6 Runtime-Only for SonarScanner
RUN apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-6.0

# Install Sonar Scanner
RUN dotnet tool install --global dotnet-sonarscanner --version 5.4.1
RUN export PATH="$PATH:/root/.dotnet/tools"

# Cleanup
RUN apt-get -q autoremove -y \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin

#ENTRYPOINT ["bash"]
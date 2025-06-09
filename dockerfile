# Use the official .NET 8 SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy and restore dependencies
COPY ./BPM.API/*.csproj ./BPM.API/
RUN dotnet restore ./BPM.API/BPM.API.csproj

# Copy the entire source
COPY ./BPM.API ./BPM.API

# Build the application
WORKDIR /app/BPM.API
RUN dotnet publish -c Release -o out

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/BPM.API/out .

# Bind to port (Render provides PORT env variable)
ENV ASPNETCORE_URLS=http://+:$PORT

# Expose the port (Render will set the actual port)
EXPOSE 8080

ENTRYPOINT ["dotnet", "BPM.API.dll"]

# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy only the project file and restore
COPY BPM.API/BPM.API.csproj BPM.API/
RUN dotnet restore BPM.API/BPM.API.csproj

# Copy everything else and build
COPY BPM.API/ BPM.API/
WORKDIR /app/BPM.API
RUN dotnet publish -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .

# Set ASP.NET to listen on the port Render gives
ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE 8080

ENTRYPOINT ["dotnet", "BPM.API.dll"]

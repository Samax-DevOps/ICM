
# Use the official .NET SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the .csproj file and restore any dependencies
COPY ICM.WebSites/*.csproj ICM.WebSites/
RUN dotnet restore ICM.WebSites/ICM.WebSites.csproj

# Copy the rest of the application files
COPY . ./
COPY ICM.WebSites/wwwroot/media/* /app/wwwroot/media/

# Publish the application
RUN dotnet publish ICM.WebSites/ICM.WebSites.csproj -c Release -o /app/publish

# Use the ASP.NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .


# Run the application
ENTRYPOINT ["dotnet", "ICM.WebSites.dll"]


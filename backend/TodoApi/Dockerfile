# --- Build stage ---
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY TodoApi.csproj ./
RUN dotnet restore ./TodoApi.csproj

COPY . .
RUN dotnet publish ./TodoApi.csproj -c Release -o /app/publish --no-restore

# --- Runtime stage ---
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:5140
EXPOSE 5140

ENTRYPOINT ["dotnet", "TodoApi.dll"]

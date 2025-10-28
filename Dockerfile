# 1) Runtime osnova (.NET 9)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

# 2) Build osnova (.NET 9 SDK)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["StuDom/StuDom.csproj", "StuDom/"]
RUN dotnet restore "StuDom/StuDom.csproj"

COPY . .
WORKDIR "/src/StuDom"
RUN dotnet build "StuDom.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "StuDom.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "StuDom.dll"]

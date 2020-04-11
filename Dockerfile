FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
EXPOSE 80
EXPOSE 443

WORKDIR /
COPY ["WebApplication1/WebApplication1.csproj", "WebApplication1/"]
RUN dotnet restore "WebApplication1/WebApplication1.csproj"
COPY . . 
WORKDIR "/WebApplication1"
RUN dotnet build "WebApplication1.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
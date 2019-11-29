FROM mcr.microsoft.com/dotnet/core/runtime:3.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["netCoreMongo.csproj", "netCoreMongo/"]
RUN dotnet restore "netCoreMongo/netCoreMongo.csproj"

COPY . .
WORKDIR "/src/netCoreMongo"
RUN dotnet build "netCoreMongo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "netCoreMongo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "netCoreMongo.dll"]
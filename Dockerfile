FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["netCoreMongo.csproj", "./"]
RUN dotnet restore "./netCoreMongo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "netCoreMongo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "netCoreMongo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "netCoreMongo.dll"]

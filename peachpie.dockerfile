FROM microsoft/dotnet:2.1-sdk-stretch AS build
WORKDIR /app
COPY . .
RUN dotnet build -c Release peachpie/src/Peachpie.Compiler.Tools/Peachpie.Compiler.Tools.csproj
RUN dotnet build -c Release peachpie/src/Peachpie.CodeAnalysis/Peachpie.CodeAnalysis.csproj
RUN dotnet pack peachpie/src/Peachpie.Compiler.Tools -c Release -o ../../../packages
RUN dotnet pack peachpie/src/Peachpie.CodeAnalysis -c Release -o ../../../packages
RUN dotnet publish -c Release -o ../out Server

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
ENV COMPlus_ReadyToRun 0
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "Server.dll"]
# Build stage
FROM microsoft/aspnetcore-build:2 AS build-env

WORKDIR /generator

# Restore (Also it is possible to do single restore but for solution file)
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# --- RUN ls -alR # Uncomment to see what files are being copied in

# Copy src
COPY . .

# Test
RUN dotnet test tests/tests.csproj

# Publish
RUN dotnet publish api/api.csproj -o /publish

# Runtime stage
FROM microsoft/aspnetcore:2

COPY --from=build-env /publish /publish

WORKDIR /publish

ENTRYPOINT [ "dotnet", "api.dll" ]


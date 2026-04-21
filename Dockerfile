# ══════════════════════════════════════════════════════════════════════════════
#  PANDORA — Dockerfile
#  Resultado: un solo contenedor que sirve el frontend + backend
#
#  NOTA: El backend se empaqueta desde artefactos pre-compilados
#  (bin/Debug/net8.0/) porque el código fuente vive en almacenamiento cloud.
#  Cuando el código fuente esté disponible localmente, reemplazar Stage 2 por
#  un build estándar con `dotnet publish`.
# ══════════════════════════════════════════════════════════════════════════════

# ── Stage 1: Build del Frontend (React 18 + Vite) ────────────────────────────
FROM node:20-alpine AS frontend
LABEL stage=frontend

WORKDIR /src/frontend

# Instalar dependencias (capa de caché separada)
COPY frontend/package*.json ./
RUN npm ci --silent

# Build de producción
COPY frontend/ ./
RUN npm run build
# Salida: /src/frontend/dist/


# ── Stage 2: Imagen de runtime ────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

# curl para healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# ── Copiar artefactos pre-compilados del backend ──────────────────────────────
COPY backend/Pandora.API/bin/Debug/net8.0/ ./

# ── Copiar build del frontend sobre wwwroot/ ──────────────────────────────────
COPY --from=frontend /src/frontend/dist ./wwwroot/

# ── Directorios de datos (sobreescritos por volúmenes en compose) ─────────────
RUN mkdir -p /app/storage/libros \
             /app/storage/portadas \
             /app/biblioteca

# ── Usuario no-root ───────────────────────────────────────────────────────────
RUN groupadd --system pandora \
 && useradd  --system --gid pandora --no-create-home pandora \
 && chown -R pandora:pandora /app

USER pandora

# ── Variables de entorno base ─────────────────────────────────────────────────
ENV ASPNETCORE_URLS=http://+:80 \
    ASPNETCORE_ENVIRONMENT=Production \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

EXPOSE 80

# ── Healthcheck ───────────────────────────────────────────────────────────────
# 401 = backend vivo (endpoint protegido responde), 200 = también válido
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=5 \
  CMD curl -s -o /dev/null -w "%{http_code}" http://localhost:80/api/biblioteca/categorias \
      | grep -qE "^(200|401)" || exit 1

ENTRYPOINT ["dotnet", "Pandora.API.dll"]

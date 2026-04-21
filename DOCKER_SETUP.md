# Pandora — Configuración Docker

## Cambio requerido en Program.cs

Abre `backend/Pandora.API/Program.cs` y aplica estos 2 cambios:

### Cambio 1 — Antes de `app.UseStaticFiles();`
Agrega esta línea inmediatamente ANTES de `app.UseStaticFiles();`:

```csharp
app.UseDefaultFiles();   // ← AÑADIR (sirve index.html en la raíz)
app.UseStaticFiles();    // ← ya existe
```

### Cambio 2 — Después de `app.MapHub<ProgressHub>("/hubs/progress");`
Agrega esta línea al final de los Map*, ANTES de `await app.RunAsync();`:

```csharp
app.MapHub<ProgressHub>("/hubs/progress");     // ← ya existe
app.MapFallbackToFile("index.html");           // ← AÑADIR (SPA routing)
```

---

## Cómo levantar con Docker

### 1. Primera vez
```bash
# Copiar el archivo de variables
copy .env.example .env

# Editar .env si quieres cambiar contraseñas (opcional)
# notepad .env

# Construir y levantar
docker compose up --build -d
```

### 2. Ver logs en tiempo real
```bash
docker compose logs -f pandora
```

### 3. Abrir la app
→ http://localhost:8080
→ Usuario: admin / PandoraAdmin2024!

### 4. Detener
```bash
docker compose down
```

### 5. Detener y borrar datos (reset completo)
```bash
docker compose down -v
```

---

## Estructura de volúmenes

| Volumen | Contenido |
|---------|-----------|
| `pandora_storage` | Portadas de libros subidas |
| `pandora_sqldata` | Base de datos SQL Server |
| `../Material Bibliografico` | PDFs — bind mount desde el host |

---

## Variables de entorno (.env)

| Variable | Default | Descripción |
|----------|---------|-------------|
| `APP_PORT` | `8080` | Puerto de la aplicación |
| `DB_PASSWORD` | `PandoraAdmin2024!` | Contraseña SQL Server |
| `JWT_KEY` | `Pandora_SuperSecret...` | Clave JWT (cambiar en producción) |
| `ADMIN_USER` | `admin` | Usuario administrador |
| `ADMIN_PASS` | `PandoraAdmin2024!` | Contraseña administrador |
| `BIBLIOTECA_HOST_PATH` | `../Material Bibliografico` | Ruta a los PDFs en el host |

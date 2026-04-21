// ══════════════════════════════════════════════════════════════════════════════
//  PANDORA — PM2 Ecosystem
//
//  Comandos útiles:
//    pm2 start ecosystem.config.js   → levantar todo
//    pm2 stop all                    → detener todo
//    pm2 restart all                 → reiniciar todo
//    pm2 logs                        → ver logs en tiempo real
//    pm2 monit                       → monitor visual
//    pm2 save                        → guardar estado actual
// ══════════════════════════════════════════════════════════════════════════════

const BASE = 'C:/Users/siste/OneDrive/Desktop/Proyeto_Pandora/Pandora_Beta1.0/Pandora';

module.exports = {
  apps: [

    // ── Backend — ASP.NET Core 8 ───────────────────────────────────────────
    {
      name:        'pandora-backend',
      script:      'dotnet',
      args:        'Pandora.API.dll',
      cwd:         `${BASE}/backend/Pandora.API/bin/Debug/net8.0`,
      interpreter: 'none',
      autorestart: true,
      watch:       false,
      max_restarts: 5,
      restart_delay: 3000,
      env: {
        ASPNETCORE_ENVIRONMENT:              'Development',
        ASPNETCORE_URLS:                     'http://0.0.0.0:5000',
        Jwt__Key:                            'Pandora_SuperSecret_Docker_Key_2024_Min32Chars!',
        Jwt__Issuer:                         'PandoraAPI',
        Jwt__Audience:                       'PandoraClient',
        Jwt__ExpiresInMinutes:               '480',
        JwtSettings__Key:                    'Pandora_SuperSecret_Docker_Key_2024_Min32Chars!',
        JwtSettings__Issuer:                 'PandoraAPI',
        JwtSettings__Audience:               'PandoraClient',
        JwtSettings__ExpiresInMinutes:       '480',
        ConnectionStrings__DefaultConnection:'Server=(localdb)\\mssqllocaldb;Database=PandoraDB;Trusted_Connection=True;TrustServerCertificate=True;Encrypt=False;',
        ConnectionStrings__PandoraDb:        'Server=(localdb)\\mssqllocaldb;Database=PandoraDB;Trusted_Connection=True;TrustServerCertificate=True;Encrypt=False;',
        AdminUser__Username:                 'admin',
        AdminUser__Password:                 'PandoraAdmin2024!',
        Biblioteca__LibrosPath:              'C:\\Users\\siste\\OneDrive\\Desktop\\Proyeto_Pandora\\Material Bibliografico',
      },
    },

    // ── Frontend — Vite + React 18 ─────────────────────────────────────────
    {
      name:        'pandora-frontend',
      script:      'cmd',
      args:        '/c npm run dev',
      cwd:         `${BASE}/frontend`,
      interpreter: 'none',
      autorestart: true,
      watch:       false,
      max_restarts: 5,
      restart_delay: 2000,
      env: {
        NODE_ENV: 'development',
      },
    },

  ],
};

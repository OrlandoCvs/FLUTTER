<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PIXEL GATO — README</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Orbitron:wght@400;700;900&family=VT323&display=swap');

  :root {
    --green:   #39FF14;
    --pink:    #FF2079;
    --yellow:  #FFD700;
    --cyan:    #00F5FF;
    --bg:      #0D0D0D;
    --surface: #1A1A2E;
    --surface2:#16213E;
    --dim:     #888888;
    --border:  #333366;
  }

  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: var(--bg);
    color: #E8E8E8;
    font-family: 'Share Tech Mono', monospace;
    line-height: 1.7;
    overflow-x: hidden;
  }

  /* ── Scanline overlay ── */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background: repeating-linear-gradient(
      0deg,
      transparent,
      transparent 2px,
      rgba(0,0,0,0.08) 2px,
      rgba(0,0,0,0.08) 4px
    );
    pointer-events: none;
    z-index: 9999;
  }

  /* ── Hero ── */
  .hero {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 60px 20px;
    position: relative;
    background:
      radial-gradient(ellipse 80% 60% at 50% 0%, rgba(57,255,20,0.07) 0%, transparent 70%),
      radial-gradient(ellipse 60% 40% at 80% 80%, rgba(255,32,121,0.06) 0%, transparent 60%),
      var(--bg);
  }

  .hero::after {
    content: '';
    position: absolute;
    bottom: 0; left: 0; right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--green), transparent);
  }

  .badge {
    display: inline-block;
    border: 1px solid var(--green);
    color: var(--green);
    font-family: 'Share Tech Mono', monospace;
    font-size: 11px;
    letter-spacing: 3px;
    padding: 6px 16px;
    margin-bottom: 32px;
    animation: blink 2s step-end infinite;
  }

  @keyframes blink {
    0%, 100% { opacity: 1; }
    50%       { opacity: 0.4; }
  }

  .hero-title {
    font-family: 'Orbitron', monospace;
    font-size: clamp(56px, 12vw, 120px);
    font-weight: 900;
    line-height: 0.9;
    letter-spacing: -2px;
    color: var(--green);
    text-shadow:
      0 0 20px rgba(57,255,20,0.8),
      0 0 60px rgba(57,255,20,0.4),
      0 0 120px rgba(57,255,20,0.2);
    margin-bottom: 8px;
  }

  .hero-subtitle {
    font-family: 'VT323', monospace;
    font-size: clamp(28px, 5vw, 48px);
    color: var(--yellow);
    letter-spacing: 12px;
    text-shadow: 0 0 12px rgba(255,215,0,0.6);
    margin-bottom: 40px;
  }

  .hero-desc {
    max-width: 600px;
    color: var(--dim);
    font-size: 14px;
    letter-spacing: 1px;
    margin-bottom: 48px;
    line-height: 2;
  }

  .hero-badges {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    justify-content: center;
    margin-bottom: 48px;
  }

  .pill {
    padding: 6px 16px;
    border: 1px solid;
    font-size: 11px;
    letter-spacing: 2px;
    font-family: 'Share Tech Mono', monospace;
  }
  .pill-green  { border-color: var(--green); color: var(--green); }
  .pill-pink   { border-color: var(--pink);  color: var(--pink);  }
  .pill-cyan   { border-color: var(--cyan);  color: var(--cyan);  }
  .pill-yellow { border-color: var(--yellow);color: var(--yellow);}

  /* ── Section ── */
  section {
    max-width: 1100px;
    margin: 0 auto;
    padding: 80px 24px;
  }

  .section-label {
    font-family: 'Share Tech Mono', monospace;
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 4px;
    margin-bottom: 12px;
  }

  .section-title {
    font-family: 'Orbitron', monospace;
    font-size: clamp(24px, 4vw, 40px);
    font-weight: 700;
    margin-bottom: 48px;
    position: relative;
    display: inline-block;
  }

  .section-title.green  { color: var(--green);  text-shadow: 0 0 20px rgba(57,255,20,0.4); }
  .section-title.pink   { color: var(--pink);   text-shadow: 0 0 20px rgba(255,32,121,0.4); }
  .section-title.cyan   { color: var(--cyan);   text-shadow: 0 0 20px rgba(0,245,255,0.4); }
  .section-title.yellow { color: var(--yellow); text-shadow: 0 0 20px rgba(255,215,0,0.4); }

  .section-title::after {
    content: '';
    display: block;
    height: 2px;
    margin-top: 8px;
    background: currentColor;
    box-shadow: 0 0 8px currentColor;
  }

  hr.divider {
    border: none;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border), transparent);
    margin: 0;
  }

  /* ── Screenshots grid ── */
  .screenshots {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-top: 32px;
  }

  .screenshot-card {
    border: 1px solid var(--border);
    background: var(--surface);
    overflow: hidden;
    position: relative;
    transition: border-color 0.3s, transform 0.3s;
    cursor: default;
  }

  .screenshot-card:hover {
    border-color: var(--green);
    transform: translateY(-4px);
    box-shadow: 0 12px 40px rgba(57,255,20,0.15);
  }

  .screenshot-card img {
    width: 100%;
    height: 380px;
    object-fit: cover;
    object-position: top;
    display: block;
    filter: saturate(0.9);
    transition: filter 0.3s;
  }

  .screenshot-card:hover img { filter: saturate(1.1); }

  .screenshot-label {
    padding: 12px 16px;
    font-size: 11px;
    letter-spacing: 2px;
    color: var(--dim);
    border-top: 1px solid var(--border);
    background: var(--surface2);
  }

  /* ── Tech grid ── */
  .tech-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 16px;
  }

  .tech-card {
    border: 1px solid var(--border);
    background: var(--surface);
    padding: 24px;
    transition: border-color 0.3s, transform 0.3s;
    position: relative;
    overflow: hidden;
  }

  .tech-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 2px;
    background: var(--accent, var(--green));
    box-shadow: 0 0 8px var(--accent, var(--green));
  }

  .tech-card:hover {
    border-color: var(--accent, var(--green));
    transform: translateY(-2px);
  }

  .tech-icon {
    font-size: 32px;
    margin-bottom: 12px;
  }

  .tech-name {
    font-family: 'Orbitron', monospace;
    font-size: 13px;
    font-weight: 700;
    color: var(--accent, var(--green));
    letter-spacing: 2px;
    margin-bottom: 6px;
  }

  .tech-version {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 1px;
    margin-bottom: 8px;
  }

  .tech-desc {
    font-size: 12px;
    color: #aaa;
    line-height: 1.6;
  }

  /* ── Features ── */
  .features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 16px;
  }

  .feature-card {
    border: 1px solid var(--border);
    background: var(--surface);
    padding: 28px;
    transition: all 0.3s;
  }

  .feature-card:hover {
    border-color: var(--pink);
    box-shadow: 0 0 20px rgba(255,32,121,0.1);
  }

  .feature-icon {
    font-size: 28px;
    margin-bottom: 16px;
  }

  .feature-title {
    font-family: 'Orbitron', monospace;
    font-size: 12px;
    font-weight: 700;
    color: var(--pink);
    letter-spacing: 2px;
    margin-bottom: 10px;
  }

  .feature-desc {
    font-size: 13px;
    color: #aaa;
    line-height: 1.7;
  }

  /* ── Team ── */
  .team-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 20px;
  }

  .team-card {
    border: 1px solid var(--border);
    background: var(--surface);
    padding: 32px 28px;
    text-align: center;
    transition: all 0.3s;
    position: relative;
    overflow: hidden;
  }

  .team-card::after {
    content: '';
    position: absolute;
    bottom: 0; left: 0; right: 0;
    height: 2px;
    background: var(--cyan);
    box-shadow: 0 0 8px var(--cyan);
    transform: scaleX(0);
    transition: transform 0.3s;
  }

  .team-card:hover::after { transform: scaleX(1); }
  .team-card:hover { border-color: var(--cyan); }

  .team-avatar {
    width: 72px;
    height: 72px;
    border: 2px solid var(--cyan);
    border-radius: 0;
    margin: 0 auto 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 32px;
    background: var(--surface2);
    box-shadow: 0 0 16px rgba(0,245,255,0.2);
  }

  .team-name {
    font-family: 'Orbitron', monospace;
    font-size: 14px;
    font-weight: 700;
    color: var(--cyan);
    letter-spacing: 2px;
    margin-bottom: 6px;
  }

  .team-role {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 2px;
  }

  /* ── Install ── */
  .install-steps {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .step {
    display: grid;
    grid-template-columns: 48px 1fr;
    gap: 20px;
    align-items: start;
    border: 1px solid var(--border);
    background: var(--surface);
    padding: 24px;
    transition: border-color 0.3s;
  }

  .step:hover { border-color: var(--yellow); }

  .step-num {
    font-family: 'VT323', monospace;
    font-size: 40px;
    color: var(--yellow);
    text-shadow: 0 0 12px rgba(255,215,0,0.5);
    line-height: 1;
    text-align: center;
  }

  .step-title {
    font-family: 'Orbitron', monospace;
    font-size: 12px;
    font-weight: 700;
    color: var(--yellow);
    letter-spacing: 2px;
    margin-bottom: 8px;
  }

  .step-desc {
    font-size: 13px;
    color: #aaa;
    line-height: 1.7;
  }

  code {
    background: rgba(57,255,20,0.08);
    border: 1px solid rgba(57,255,20,0.2);
    color: var(--green);
    padding: 2px 8px;
    font-family: 'Share Tech Mono', monospace;
    font-size: 12px;
  }

  pre {
    background: var(--surface2);
    border: 1px solid var(--border);
    border-left: 3px solid var(--green);
    padding: 20px 24px;
    overflow-x: auto;
    font-family: 'Share Tech Mono', monospace;
    font-size: 13px;
    color: var(--green);
    line-height: 1.8;
    margin: 16px 0;
  }

  pre .comment { color: var(--dim); }
  pre .cmd     { color: var(--cyan); }

  /* ── DB Structure ── */
  .db-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 16px;
  }

  .collection {
    border: 1px solid var(--border);
    background: var(--surface);
    overflow: hidden;
  }

  .collection-header {
    background: var(--surface2);
    padding: 14px 20px;
    border-bottom: 1px solid var(--border);
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .collection-icon { font-size: 18px; }

  .collection-name {
    font-family: 'Orbitron', monospace;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 2px;
  }

  .collection-name.green  { color: var(--green); }
  .collection-name.pink   { color: var(--pink); }
  .collection-name.yellow { color: var(--yellow); }

  .field-list {
    padding: 16px 20px;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .field {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 12px;
    padding: 6px 0;
    border-bottom: 1px solid rgba(255,255,255,0.04);
  }

  .field:last-child { border-bottom: none; }
  .field-key   { color: var(--cyan); }
  .field-type  { color: var(--dim); font-size: 11px; }

  /* ── Footer ── */
  footer {
    text-align: center;
    padding: 60px 20px;
    border-top: 1px solid var(--border);
    position: relative;
    overflow: hidden;
  }

  footer::before {
    content: 'PIXEL GATO';
    position: absolute;
    font-family: 'Orbitron', monospace;
    font-size: clamp(80px, 20vw, 200px);
    font-weight: 900;
    color: rgba(57,255,20,0.03);
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    white-space: nowrap;
    pointer-events: none;
  }

  .footer-title {
    font-family: 'Orbitron', monospace;
    font-size: 24px;
    font-weight: 900;
    color: var(--green);
    text-shadow: 0 0 20px rgba(57,255,20,0.5);
    margin-bottom: 8px;
  }

  .footer-sub {
    color: var(--dim);
    font-size: 12px;
    letter-spacing: 3px;
    margin-bottom: 32px;
  }

  .footer-links {
    display: flex;
    gap: 24px;
    justify-content: center;
    flex-wrap: wrap;
  }

  .footer-link {
    color: var(--cyan);
    text-decoration: none;
    font-size: 12px;
    letter-spacing: 2px;
    border-bottom: 1px solid transparent;
    transition: border-color 0.2s;
    padding-bottom: 2px;
  }

  .footer-link:hover { border-color: var(--cyan); }

  /* ── Placeholder screenshot ── */
  .mock-screen {
    width: 100%;
    height: 380px;
    background: var(--surface2);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    border-bottom: 1px solid var(--border);
  }

  .mock-icon { font-size: 48px; opacity: 0.4; }

  .mock-label {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 3px;
  }

  /* ── APK button ── */
  .apk-btn {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    border: 2px solid var(--green);
    color: var(--green);
    text-decoration: none;
    padding: 16px 32px;
    font-family: 'Orbitron', monospace;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 3px;
    box-shadow: 0 0 20px rgba(57,255,20,0.2), inset 0 0 20px rgba(57,255,20,0.05);
    transition: all 0.3s;
    background: rgba(57,255,20,0.05);
  }

  .apk-btn:hover {
    background: rgba(57,255,20,0.12);
    box-shadow: 0 0 40px rgba(57,255,20,0.4), inset 0 0 20px rgba(57,255,20,0.1);
    transform: translateY(-2px);
  }

  .bg-section-alt {
    background: linear-gradient(180deg, var(--bg) 0%, var(--surface) 50%, var(--bg) 100%);
  }
</style>
</head>
<body>

<!-- ═══════════════════════════════════════════════════════ HERO -->
<div class="hero">
  <div class="badge">▶ VERSIÓN 1.0.0 — RELEASE ESTABLE</div>

  <div class="hero-title">PIXEL<br>GATO</div>
  <div class="hero-subtitle">TIC · TAC · TOE</div>

  <p class="hero-desc">
    Juego del Gato multijugador en tiempo real desarrollado con Flutter y Firebase.<br>
    Autenticación, sincronización instantánea entre dispositivos, ranking global<br>
    y una estética retro-terminal que no olvidarás.
  </p>

  <div class="hero-badges">
    <span class="pill pill-green">FLUTTER 3.41.2</span>
    <span class="pill pill-cyan">FIREBASE</span>
    <span class="pill pill-pink">ANDROID</span>
    <span class="pill pill-yellow">MULTIJUGADOR</span>
    <span class="pill pill-green">TIEMPO REAL</span>
  </div>

  <a href="./app-release.apk" class="apk-btn">
    ⬇ DESCARGAR APK v1.0.0
  </a>
</div>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ SCREENSHOTS -->
<section>
  <div class="section-label">// 01 — CAPTURAS</div>
  <h2 class="section-title green">VISTAS DE LA APP</h2>

  <div class="screenshots">

    <div class="screenshot-card">
      <!-- Reemplaza src con tus capturas reales -->
      <img src="screenshots/login.png" alt="Login"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
      <div class="mock-screen" style="display:none">
        <div class="mock-icon">🔐</div>
        <div class="mock-label">LOGIN · REGISTRO</div>
      </div>
      <div class="screenshot-label">01 — AUTENTICACIÓN</div>
    </div>

    <div class="screenshot-card">
      <img src="screenshots/lobby.png" alt="Lobby"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
      <div class="mock-screen" style="display:none">
        <div class="mock-icon">🏠</div>
        <div class="mock-label">SALA DE ESPERA</div>
      </div>
      <div class="screenshot-label">02 — LOBBY</div>
    </div>

    <div class="screenshot-card">
      <img src="screenshots/game.png" alt="Juego"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
      <div class="mock-screen" style="display:none">
        <div class="mock-icon">🎮</div>
        <div class="mock-label">PARTIDA EN VIVO</div>
      </div>
      <div class="screenshot-label">03 — JUEGO</div>
    </div>

    <div class="screenshot-card">
      <img src="screenshots/results.png" alt="Resultados"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
      <div class="mock-screen" style="display:none">
        <div class="mock-icon">🏆</div>
        <div class="mock-label">RESULTADOS</div>
      </div>
      <div class="screenshot-label">04 — RESULTADOS</div>
    </div>

    <div class="screenshot-card">
      <img src="screenshots/dashboard.png" alt="Dashboard"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
      <div class="mock-screen" style="display:none">
        <div class="mock-icon">📊</div>
        <div class="mock-label">RANKING GLOBAL</div>
      </div>
      <div class="screenshot-label">05 — DASHBOARD</div>
    </div>

  </div>
</section>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ FEATURES -->
<section class="bg-section-alt" style="max-width:100%; padding: 80px 0;">
<div style="max-width:1100px; margin:0 auto; padding: 0 24px;">
  <div class="section-label">// 02 — FUNCIONALIDADES</div>
  <h2 class="section-title pink">CARACTERÍSTICAS</h2>

  <div class="features-grid">

    <div class="feature-card">
      <div class="feature-icon">🔐</div>
      <div class="feature-title">AUTENTICACIÓN FIREBASE</div>
      <p class="feature-desc">Registro e inicio de sesión con correo, contraseña y nombre de usuario único. Sesión persistente entre aperturas de la app.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">⚡</div>
      <div class="feature-title">TIEMPO REAL</div>
      <p class="feature-desc">Cada movimiento se sincroniza instantáneamente entre ambos dispositivos usando Firestore listeners en tiempo real.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">🎯</div>
      <div class="feature-title">SALAS CON CÓDIGO</div>
      <p class="feature-desc">Crea una sala y comparte el código único de 6 caracteres con tu oponente. Sin cuentas vinculadas, solo el código.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">📼</div>
      <div class="feature-title">HISTORIAL DE MOVIMIENTOS</div>
      <p class="feature-desc">Cada partida registra todos los movimientos con jugador, símbolo, fila y columna. Permite recrear la partida completa.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">🏆</div>
      <div class="feature-title">RANKING GLOBAL</div>
      <p class="feature-desc">Dashboard con el Top 10 jugadores ordenados por victorias. Datos en tiempo real desde Firestore.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">🎵</div>
      <div class="feature-title">EFECTOS DE SONIDO</div>
      <p class="feature-desc">Sonidos retro para cada acción: colocar X/O, victoria, derrota, empate y clics en botones.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">✨</div>
      <div class="feature-title">ANIMACIONES</div>
      <p class="feature-desc">Símbolos X/O aparecen con animación elástica. Línea ganadora se ilumina con glow. Transiciones entre pantallas animadas.</p>
    </div>

    <div class="feature-card">
      <div class="feature-icon">🎨</div>
      <div class="feature-title">ESTÉTICA RETRO CRT</div>
      <p class="feature-desc">Paleta neon sobre fondo oscuro tipo terminal. Verde fosforescente para X, magenta para O. Tipografía monospace pixel.</p>
    </div>

  </div>
</div>
</section>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ TECNOLOGÍAS -->
<section>
  <div class="section-label">// 03 — STACK</div>
  <h2 class="section-title cyan">TECNOLOGÍAS</h2>

  <div class="tech-grid">

    <div class="tech-card" style="--accent: #54C5F8;">
      <div class="tech-icon">💙</div>
      <div class="tech-name">FLUTTER</div>
      <div class="tech-version">v3.41.2 — Channel Stable</div>
      <p class="tech-desc">Framework principal para el desarrollo de la interfaz móvil multiplataforma.</p>
    </div>

    <div class="tech-card" style="--accent: #FFA000;">
      <div class="tech-icon">🔥</div>
      <div class="tech-name">FIREBASE AUTH</div>
      <div class="tech-version">firebase_auth ^5.3.1</div>
      <p class="tech-desc">Autenticación de usuarios con email y contraseña. Gestión de sesiones.</p>
    </div>

    <div class="tech-card" style="--accent: #FFA000;">
      <div class="tech-icon">🗄️</div>
      <div class="tech-name">CLOUD FIRESTORE</div>
      <div class="tech-version">cloud_firestore ^5.4.4</div>
      <p class="tech-desc">Base de datos NoSQL en tiempo real. Almacena partidas, usuarios y movimientos.</p>
    </div>

    <div class="tech-card" style="--accent: var(--green);">
      <div class="tech-icon">🎵</div>
      <div class="tech-name">AUDIOPLAYERS</div>
      <div class="tech-version">audioplayers ^6.1.0</div>
      <p class="tech-desc">Reproducción de efectos de sonido .mp3 para enriquecer la experiencia.</p>
    </div>

    <div class="tech-card" style="--accent: var(--pink);">
      <div class="tech-icon">✨</div>
      <div class="tech-name">FLUTTER ANIMATE</div>
      <div class="tech-version">flutter_animate ^4.5.0</div>
      <p class="tech-desc">Librería de animaciones declarativas. Usada para las entradas de símbolos y shimmer.</p>
    </div>

    <div class="tech-card" style="--accent: var(--yellow);">
      <div class="tech-icon">🔤</div>
      <div class="tech-name">GOOGLE FONTS</div>
      <div class="tech-version">google_fonts ^6.2.1</div>
      <p class="tech-desc">Fuentes tipográficas para la identidad visual retro de la aplicación.</p>
    </div>

    <div class="tech-card" style="--accent: var(--cyan);">
      <div class="tech-icon">🆔</div>
      <div class="tech-name">UUID</div>
      <div class="tech-version">uuid ^4.5.1</div>
      <p class="tech-desc">Generación de identificadores únicos para salas y partidas.</p>
    </div>

    <div class="tech-card" style="--accent: #A78BFA;">
      <div class="tech-icon">🎭</div>
      <div class="tech-name">LOTTIE</div>
      <div class="tech-version">lottie ^3.1.2</div>
      <p class="tech-desc">Soporte para animaciones vectoriales en pantallas de resultados.</p>
    </div>

  </div>
</section>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ ESTRUCTURA DB -->
<section class="bg-section-alt" style="max-width:100%; padding: 80px 0;">
<div style="max-width:1100px; margin:0 auto; padding: 0 24px;">
  <div class="section-label">// 04 — BASE DE DATOS</div>
  <h2 class="section-title yellow">ESTRUCTURA FIRESTORE</h2>

  <div class="db-grid">

    <div class="collection">
      <div class="collection-header">
        <div class="collection-icon">👤</div>
        <div class="collection-name green">users/{uid}</div>
      </div>
      <div class="field-list">
        <div class="field"><span class="field-key">username</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">email</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">wins</span><span class="field-type">number</span></div>
        <div class="field"><span class="field-key">losses</span><span class="field-type">number</span></div>
        <div class="field"><span class="field-key">draws</span><span class="field-type">number</span></div>
        <div class="field"><span class="field-key">totalGames</span><span class="field-type">number</span></div>
      </div>
    </div>

    <div class="collection">
      <div class="collection-header">
        <div class="collection-icon">🎮</div>
        <div class="collection-name pink">games/{gameId}</div>
      </div>
      <div class="field-list">
        <div class="field"><span class="field-key">roomCode</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">playerXId / playerOId</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">playerXName / playerOName</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">board</span><span class="field-type">array[9]</span></div>
        <div class="field"><span class="field-key">currentTurn</span><span class="field-type">"X" | "O"</span></div>
        <div class="field"><span class="field-key">status</span><span class="field-type">waiting|playing|finished</span></div>
        <div class="field"><span class="field-key">winnerId / winnerSymbol</span><span class="field-type">string</span></div>
        <div class="field"><span class="field-key">winningLine</span><span class="field-type">array[int]</span></div>
        <div class="field"><span class="field-key">moves</span><span class="field-type">array[Move]</span></div>
        <div class="field"><span class="field-key">createdAt</span><span class="field-type">timestamp</span></div>
      </div>
    </div>

    <div class="collection">
      <div class="collection-header">
        <div class="collection-icon">📍</div>
        <div class="collection-name yellow">moves (embebido en game)</div>
      </div>
      <div class="field-list">
        <div class="field"><span class="field-key">playerId</span><span class="field-type">string (uid)</span></div>
        <div class="field"><span class="field-key">playerSymbol</span><span class="field-type">"X" | "O"</span></div>
        <div class="field"><span class="field-key">row</span><span class="field-type">number (0-2)</span></div>
        <div class="field"><span class="field-key">col</span><span class="field-type">number (0-2)</span></div>
        <div class="field"><span class="field-key">moveNumber</span><span class="field-type">number</span></div>
      </div>
    </div>

  </div>
</div>
</section>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ INSTALACIÓN -->
<section>
  <div class="section-label">// 05 — INSTALACIÓN</div>
  <h2 class="section-title green">CÓMO EJECUTAR</h2>

  <div class="install-steps">

    <div class="step">
      <div class="step-num">01</div>
      <div>
        <div class="step-title">CLONAR EL REPOSITORIO</div>
        <p class="step-desc">Clona el proyecto en tu máquina local.</p>
        <pre><span class="cmd">git clone</span> https://github.com/tuusuario/tictactoepvp.git
<span class="cmd">cd</span> tictactoepvp</pre>
      </div>
    </div>

    <div class="step">
      <div class="step-num">02</div>
      <div>
        <div class="step-title">INSTALAR DEPENDENCIAS</div>
        <p class="step-desc">Instala todos los paquetes necesarios con Flutter.</p>
        <pre><span class="cmd">flutter pub get</span></pre>
      </div>
    </div>

    <div class="step">
      <div class="step-num">03</div>
      <div>
        <div class="step-title">CONFIGURAR FIREBASE</div>
        <p class="step-desc">El archivo <code>firebase_options.dart</code> ya está incluido. Asegúrate de tener el <code>google-services.json</code> en <code>android/app/</code>.</p>
      </div>
    </div>

    <div class="step">
      <div class="step-num">04</div>
      <div>
        <div class="step-title">EJECUTAR EN DISPOSITIVO</div>
        <p class="step-desc">Conecta tu celular Android con depuración USB activada.</p>
        <pre><span class="cmd">flutter run</span>               <span class="comment"># En dispositivo físico</span>
<span class="cmd">flutter run -d chrome</span>    <span class="comment"># En navegador web</span>
<span class="cmd">flutter build apk --release</span>  <span class="comment"># Generar APK</span></pre>
      </div>
    </div>

  </div>
</section>

<hr class="divider">

<!-- ═══════════════════════════════════════════════════════ EQUIPO -->
<section class="bg-section-alt" style="max-width:100%; padding: 80px 0;">
<div style="max-width:1100px; margin:0 auto; padding: 0 24px;">
  <div class="section-label">// 06 — AUTORES</div>
  <h2 class="section-title cyan">EQUIPO DE DESARROLLO</h2>

  <div class="team-grid">

    <div class="team-card">
      <div class="team-avatar">👾</div>
      <div class="team-name">NOMBRE COMPLETO 1</div>
      <div class="team-role">DESARROLLADOR · UNISON</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">🕹️</div>
      <div class="team-name">NOMBRE COMPLETO 2</div>
      <div class="team-role">DESARROLLADOR · UNISON</div>
    </div>

  </div>

  <br><br>

  <p style="font-size:13px; color: var(--dim); line-height:2;">
    Desarrollado para la materia de <code>Programación de Sistemas III</code> —
    Universidad de Sonora · 2026.<br>
    Tarea 07: Juego del Gato Multijugador en Tiempo Real.
  </p>
</div>
</section>

<!-- ═══════════════════════════════════════════════════════ FOOTER -->
<footer>
  <div class="footer-title">PIXEL GATO</div>
  <div class="footer-sub">TIC · TAC · TOE — UNISON 2026</div>
  <div class="footer-links">
    <a href="#" class="footer-link">REPOSITORIO</a>
    <a href="./app-release.apk" class="footer-link">DESCARGAR APK</a>
    <a href="https://console.firebase.google.com" class="footer-link">FIREBASE</a>
  </div>
</footer>

</body>
</html>
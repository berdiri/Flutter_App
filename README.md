<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>urban_wear README</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css">
    
    <style>
        /* CSS Variables - Light & Dark Mode */
        :root {
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --primary: #3b82f6;
            --primary-hover: #2563eb;
            --border-color: #e2e8f0;
            --code-bg: #f1f5f9;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05), 0 2px 4px -2px rgb(0 0 0 / 0.05);
            
            /* Tech Stack Colors */
            --color-flutter: #02569B;
            --color-dart: #0175C2;
            --color-android: #3DDC84;
            --color-ios: #000000;
        }

        @media (prefers-color-scheme: dark) {
            :root {
                --bg-color: #0f172a;
                --card-bg: #1e293b;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --primary: #60a5fa;
                --primary-hover: #3b82f6;
                --border-color: #334155;
                --code-bg: #0f172a;
                --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.3), 0 2px 4px -2px rgb(0 0 0 / 0.3);
                --color-ios: #ffffff;
            }
        }

        /* Base Styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            line-height: 1.6;
            padding: 2rem 1rem;
        }
        .container {
            max-width: 850px;
            margin: 0 auto;
        }
        section {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        h2 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        a {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.2s ease;
        }
        a:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }

        /* Hero Section */
        .hero {
            text-align: center;
            background: linear-gradient(135deg, var(--card-bg) 0%, var(--bg-color) 100%);
        }
        .hero h1 {
            font-size: 2.5rem;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 0.5rem;
            background: linear-gradient(to right, var(--primary), #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero p {
            color: var(--text-muted);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 1.5rem;
        }
        .badges {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .badge {
            background: var(--code-bg);
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
        }
        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .btn-primary {
            background: var(--primary);
            color: #ffffff;
        }
        .btn-primary:hover {
            background: var(--primary-hover);
            color: #ffffff;
            text-decoration: none;
            transform: translateY(-1px);
        }
        .btn-secondary {
            background: transparent;
            color: var(--text-main);
            border: 1px solid var(--border-color);
        }
        .btn-secondary:hover {
            background: var(--code-bg);
            text-decoration: none;
        }

        /* Tech Stack Section */
        .tech-dots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 1rem;
        }
        .tech-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }
        .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        /* Quick Start Section */
        .steps {
            list-style: none;
        }
        .step-item {
            position: relative;
            padding-left: 3rem;
            margin-bottom: 1.5rem;
        }
        .step-item:last-child {
            margin-bottom: 0;
        }
        .step-number {
            position: absolute;
            left: 0;
            top: 0;
            width: 2rem;
            height: 2rem;
            background: var(--code-bg);
            border: 1px solid var(--border-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            color: var(--primary);
        }
        .step-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        pre {
            background: var(--code-bg);
            padding: 0.75rem 1rem;
            border-radius: 8px;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 0.9rem;
        }

        /* Features Section */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
        }
        .card {
            border: 1px solid var(--border-color);
            padding: 1.5rem;
            border-radius: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .card i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.75rem;
            display: inline-block;
        }
        .card h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        .card p {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        /* Resources Section */
        .resources-list {
            list-style: none;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .resources-list li a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            background: var(--code-bg);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            font-weight: 500;
        }
        .resources-list li a:hover {
            background: var(--border-color);
            text-decoration: none;
        }
        .resources-list i {
            font-size: 1.2rem;
        }
    </style>
</head>
<body>

<div class="container">

    <section class="hero">
        <h1>urban_wear</h1>
        <p>A modern and sleek e-commerce mobile application built for ultimate shopping experiences.</p>
        
        <div class="badges">
            <span class="badge">Flutter</span>
            <span class="badge">Dart</span>
            <span class="badge">Mobile App</span>
        </div>
        
        <div class="hero-buttons">
            <a href="https://berdiri.github.io/Flutter_App/" target="_blank" class="btn btn-primary">
                <i class="ti ti-live-view"></i> Live Demo
            </a>
            <a href="https://docs.flutter.dev/" target="_blank" class="btn btn-secondary">
                <i class="ti ti-book"></i> Flutter Docs
            </a>
        </div>
    </section>

    <section>
        <h2><i class="ti ti-stack-2"></i> Tech Stack</h2>
        <div class="tech-dots">
            <div class="tech-item">
                <span class="dot" style="background-color: var(--color-flutter);"></span> Flutter
            </div>
            <div class="tech-item">
                <span class="dot" style="background-color: var(--color-dart);"></span> Dart
            </div>
            <div class="tech-item">
                <span class="dot" style="background-color: var(--color-android);"></span> Android
            </div>
            <div class="tech-item">
                <span class="dot" style="background-color: var(--color-ios);"></span> iOS
            </div>
        </div>
    </section>

    <section>
        <h2><i class="ti ti-rocket"></i> Quick Start</h2>
        <div class="steps">
            <div class="step-item">
                <div class="step-number">1</div>
                <div class="step-title">Install SDK</div>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 0.5rem;">Pastikan Flutter SDK sudah terinstal di perangkat Anda.</p>
            </div>
            <div class="step-item">
                <div class="step-number">2</div>
                <div class="step-title">Clone repo</div>
                <pre><code>git clone https://github.com/berdiri/urban_wear.git</code></pre>
            </div>
            <div class="step-item">
                <div class="step-number">3</div>
                <div class="step-title">Install dependencies</div>
                <pre><code>flutter pub get</code></pre>
            </div>
            <div class="step-item">
                <div class="step-number">4</div>
                <div class="step-title">Run app</div>
                <pre><code>flutter run</code></pre>
            </div>
        </div>
    </section>

    <section>
        <h2><i class="ti ti-apps"></i> Features</h2>
        <div class="grid">
            <div class="card">
                <i class="ti ti-shirt"></i>
                <h3>Product Catalog</h3>
                <p>Browse and filter through curated urban wear collections.</p>
            </div>
            <div class="card">
                <i class="ti ti-shopping-cart"></i>
                <h3>Cart & Checkout</h3>
                <p>Seamless management of items and smooth checkout flow.</p>
            </div>
            <div class="card">
                <i class="ti ti-heart"></i>
                <h3>Wishlist</h3>
                <p>Save your favorite outfits and clothes for later purchase.</p>
            </div>
            <div class="card">
                <i class="ti ti-user"></i>
                <h3>User Profile</h3>
                <p>Manage addresses, orders status, and profile settings.</p>
            </div>
        </div>
    </section>

    <section>
        <h2><i class="ti ti-school"></i> Learning Resources</h2>
        <ul class="resources-list">
            <li>
                <a href="https://docs.flutter.dev/get-started/learn-flutter" target="_blank">
                    <i class="ti ti-device-laptop"></i> Learn Flutter
                </a>
            </li>
            <li>
                <a href="https://docs.flutter.dev/get-started/codelab" target="_blank">
                    <i class="ti ti-code"></i> Write your first app
                </a>
            </li>
            <li>
                <a href="https://docs.flutter.dev/resources/videos" target="_blank">
                    <i class="ti ti-video"></i> Flutter Resources
                </a>
            </li>
            <li>
                <a href="https://api.flutter.dev/" target="_blank">
                    <i class="ti ti-api"></i> Full API Reference
                </a>
            </li>
        </ul>
    </section>

</div>

</body>
</html>

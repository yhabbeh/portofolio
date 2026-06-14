<p align="center">
  <img src="assets/images/profile_placeholder.png" alt="Yousef Habbeh" width="120" style="border-radius: 50%;"/>
</p>

<h1 align="center">Yousef Habbeh — Portfolio</h1>

<p align="center">
  <a href="https://flutter.dev" target="_blank"><img src="https://img.shields.io/badge/Flutter-3.11+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev" target="_blank"><img src="https://img.shields.io/badge/Dart-3.11+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License" /></a>
  <br/>
  <a href="https://github.com/yhabbeh"><img src="https://img.shields.io/badge/GitHub-yhabbeh-181717?style=flat-square&logo=github" alt="GitHub" /></a>
  <a href="https://www.linkedin.com/in/yhabbeh/"><img src="https://img.shields.io/badge/LinkedIn-yhabbeh-0A66C2?style=flat-square&logo=linkedin" alt="LinkedIn" /></a>
</p>

<p align="center">
  <b>Mobile Software Engineer</b> · <b>Flutter Developer</b> · <b>AI Engineer</b>
  <br/>
  A responsive Flutter web portfolio built with clean architecture, modern UI/UX, and attention to performance.
</p>

---

## ✨ Features

- **Interactive UI** — Particle background, falling code snippets, cursor glow effect, Lottie character
- **Fully Responsive** — Adapts seamlessly from mobile to desktop via `ResponsiveContainer`
- **8 Sections** — Hero, About, Experience, Skills, Projects, Certifications, Awards, Contact
- **Dynamic Navbar** — Smooth scroll navigation with active section tracking
- **Data-driven** — All content loaded from a local JSON asset via BLoC pattern

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Web) |
| **Language** | Dart (^3.11.0) |
| **Architecture** | Clean Architecture, BLoC pattern, Component-based UI |
| **State Management** | flutter_bloc |
| **Packages** | `url_launcher`, `flutter_bloc`, `equatable`, `shared_preferences`, `get_it`, `lottie` |

## 🚀 Getting Started

```bash
# Prerequisites: Flutter SDK ^3.11.0
git clone https://github.com/yhabbeh/portfolio.git
cd portfolio
flutter pub get
```

### Run in development
```bash
flutter run -d chrome
```

### Build for production
```bash
flutter build web
```

Deploy the `build/web/` directory to any static host (GitHub Pages, Vercel, Netlify, etc.).

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry point
├── app.dart                         # MaterialApp, theming, DI setup
├── core/
│   ├── constants.dart               # App-wide constants
│   ├── app_colors.dart              # Color palette
│   └── app_text_styles.dart         # Typography
├── features/portfolio/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── portfolio_local_data_source.dart  # Loads portfolio.json
│   │   └── models/
│   │       └── portfolio_data_model.dart         # JSON → Entity mapping
│   ├── domain/
│   │   └── entities/
│   │       └── portfolio_data.dart               # Domain model
│   └── presentation/
│       ├── blocs/portfolio/                      # BLoC state management
│       ├── pages/
│       │   └── home_page.dart                    # Main scaffold
│       └── sections/                             # One file per section
│           ├── hero_section.dart
│           ├── about_section.dart
│           ├── experience_section.dart
│           ├── skills_section.dart
│           ├── projects_section.dart
│           ├── certifications_section.dart
│           ├── awards_section.dart
│           └── contact_section.dart
└── widgets/                          # Reusable UI components
    ├── navbar.dart
    ├── section_title.dart
    ├── primary_button.dart
    ├── particle_background.dart
    ├── falling_code_snippets.dart
    ├── grid_background.dart
    ├── cursor_glow.dart
    ├── roaming_lottie_character.dart
    └── responsive_container.dart
```

## 🧑‍💻 Customization

All portfolio content lives in **`assets/data/portfolio.json`**:
- Personal info, bio, and contact links
- Work experience entries
- Skill categories and tags
- Projects with descriptions, technologies, and URLs
- Certifications and awards

Edit that file, and the portfolio updates everywhere.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  Built with ❤️ by <a href="https://github.com/yhabbeh">Yousef Habbeh</a>
</p>

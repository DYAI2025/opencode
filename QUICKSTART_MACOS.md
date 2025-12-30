# 🚀 OpenCode macOS Quick Start Guide

## Installation in 60 Sekunden

### Option 1: Automatisches Setup (Empfohlen)

```bash
# 1. Setup-Script ausführen
./setup-macos.sh

# 2. Shell neu laden
source ~/.zshrc  # oder ~/.bashrc

# 3. OpenCode starten
opencode
```

### Option 2: Manuelle Installation

```bash
# 1. OpenCode installieren
brew install opencode

# 2. API-Keys setzen
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
echo 'export GOOGLE_API_KEY="AIza..."' >> ~/.zshrc
echo 'export XAI_API_KEY="xai-..."' >> ~/.zshrc
echo 'export OPENROUTER_API_KEY="sk-or-..."' >> ~/.zshrc

# 3. Shell neu laden
source ~/.zshrc

# 4. Konfiguration kopieren
mkdir -p ~/.config/opencode
cp opencode.macos.example.jsonc ~/.config/opencode/opencode.jsonc

# 5. OpenCode starten
opencode
```

---

## 🔑 API-Keys besorgen

| Provider | Website | Env Variable |
|----------|---------|--------------|
| **Claude** | https://console.anthropic.com/ | `ANTHROPIC_API_KEY` |
| **Gemini** | https://makersuite.google.com/app/apikey | `GOOGLE_API_KEY` |
| **Grok** | https://console.x.ai/ | `XAI_API_KEY` |
| **OpenRouter** (Qwen) | https://openrouter.ai/keys | `OPENROUTER_API_KEY` |
| **OpenAI** | https://platform.openai.com/api-keys | `OPENAI_API_KEY` |

---

## 🤖 Modelle verwenden

```bash
# Claude Sonnet 4.5 (Standard, beste Balance)
opencode

# Oder spezifisch angeben:
opencode --model anthropic/claude-sonnet-4-5-20250929

# Grok
opencode --model xai/grok-beta

# Gemini
opencode --model google/gemini-2.5-flash-latest

# Qwen via OpenRouter
opencode --model openrouter/qwen/qwen-2.5-72b-instruct

# Claude Opus (höchste Qualität)
opencode --model anthropic/claude-opus-4-5
```

---

## 📁 Dateistruktur

```
~/.config/opencode/
├── opencode.jsonc         # Globale Konfiguration
└── auth/                  # API-Keys (verschlüsselt)

dein-projekt/
├── opencode.jsonc         # Projekt-spezifische Config (optional)
└── .opencode/
    └── opencode.jsonc     # Alternative Location
```

---

## 💡 Häufige Kommandos

```bash
# Version anzeigen
opencode --version

# Verfügbare Provider anzeigen
opencode providers

# Alle verfügbaren Modelle anzeigen
opencode models

# Mit Debug-Logging starten
OPENCODE_LOG_LEVEL=debug opencode

# GitHub Copilot authentifizieren
opencode auth login github-copilot

# Auth-Status anzeigen
opencode auth list
```

---

## ⚙️ Modell wechseln im Terminal

Während OpenCode läuft:
- Drücke `Tab` um zwischen **build** und **plan** Agent zu wechseln
- **build**: Voller Zugriff (Standard)
- **plan**: Read-only Modus (für Analyse)

---

## 🛠️ Troubleshooting

### Problem: "No providers found"
```bash
# Überprüfe ob API-Keys gesetzt sind
env | grep -E "ANTHROPIC|GOOGLE|XAI"

# Shell neu laden
source ~/.zshrc
```

### Problem: "Model not found"
```bash
# Zeige verfügbare Modelle
opencode models

# Zeige verfügbare Provider
opencode providers
```

### Problem: Grok funktioniert nicht
```bash
# Stelle sicher dass xAI-Config in ~/.config/opencode/opencode.jsonc existiert
# Siehe opencode.macos.example.jsonc für die vollständige Konfiguration
```

---

## 📚 Weitere Informationen

- **Vollständige Anleitung**: [SETUP_MACOS_AI_MODELS.md](./SETUP_MACOS_AI_MODELS.md)
- **Beispiel-Konfiguration**: [opencode.macos.example.jsonc](./opencode.macos.example.jsonc)
- **Setup-Script**: [setup-macos.sh](./setup-macos.sh)
- **Offizielle Docs**: https://opencode.ai/docs
- **Discord**: https://discord.gg/opencode

---

## 🎯 Empfohlene Modell-Auswahl

### Für beste Code-Qualität:
```bash
opencode --model anthropic/claude-sonnet-4-5-20250929
```

### Für maximale Leistung:
```bash
opencode --model anthropic/claude-opus-4-5
```

### Für kostengünstiges Entwickeln:
```bash
opencode --model google/gemini-2.5-flash-latest
```

### Für Experimente mit Grok:
```bash
opencode --model xai/grok-beta
```

---

**Viel Erfolg mit OpenCode! 🚀**

# OpenCode Installation & AI-Modell-Setup für macOS

## 📋 Übersicht

OpenCode ist ein 100% Open-Source AI Coding Agent für das Terminal, der mit mehreren AI-Providern funktioniert. Diese Anleitung zeigt dir, wie du OpenCode auf macOS installierst und die folgenden AI-Modelle konfigurierst:

- **Claude** (Anthropic)
- **Codex** (OpenAI/GitHub Copilot)
- **Gemini** (Google)
- **Qwen** (Alibaba)
- **Grok** (xAI)

---

## 🚀 Installation auf macOS

### Option 1: Homebrew (Empfohlen)

```bash
brew install opencode
```

### Option 2: npm/bun

```bash
npm i -g opencode-ai@latest
# oder
bun i -g opencode-ai@latest
```

### Option 3: Curl-Installer

```bash
curl -fsSL https://opencode.ai/install | bash
```

### Option 4: Nix

```bash
nix run nixpkgs#opencode
# oder für die Dev-Version:
nix run github:sst/opencode
```

### Unterstützte macOS-Versionen

- **Apple Silicon** (M1/M2/M3/M4): `darwin-arm64`
- **Intel Macs**: `darwin-x64`
- Automatische Rosetta 2 Erkennung

---

## 🔑 API-Keys einrichten

Setze die API-Keys als Umgebungsvariablen in deiner Shell-Konfiguration (`~/.zshrc`, `~/.bashrc` oder `~/.config/fish/config.fish`):

```bash
# Anthropic Claude
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI (für Codex falls nicht über GitHub Copilot)
export OPENAI_API_KEY="sk-..."

# Google Gemini
export GOOGLE_API_KEY="AIza..."

# xAI Grok
export XAI_API_KEY="xai-..."

# Optional: Qwen über OpenRouter oder andere Provider
export OPENROUTER_API_KEY="sk-or-..."
```

Nach dem Hinzufügen:
```bash
source ~/.zshrc  # oder ~/.bashrc
```

---

## ⚙️ Konfiguration

### Globale Konfiguration

Erstelle `~/.config/opencode/opencode.jsonc`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",

  // Standard-Modell (empfohlen: Claude Sonnet 4.5)
  "model": "anthropic/claude-sonnet-4-5-20250929",

  // Kleines Modell für einfache Aufgaben
  "small_model": "anthropic/claude-haiku-4-5",

  // Provider-Konfiguration
  "provider": {
    // Anthropic Claude
    "anthropic": {
      "name": "Anthropic",
      "env": ["ANTHROPIC_API_KEY"],
      "options": {}
    },

    // Google Gemini
    "google": {
      "name": "Google Gemini",
      "env": ["GOOGLE_API_KEY"],
      "options": {}
    },

    // xAI Grok
    "xai": {
      "name": "xAI",
      "env": ["XAI_API_KEY"],
      "api": "https://api.x.ai/v1",
      "npm": "@ai-sdk/openai-compatible",
      "models": {
        "grok-beta": {
          "id": "grok-beta",
          "name": "Grok Beta",
          "cost": {
            "input": 5.0,
            "output": 15.0
          },
          "limit": {
            "context": 131072,
            "output": 4096
          },
          "temperature": true,
          "tool_call": true
        },
        "grok-vision-beta": {
          "id": "grok-vision-beta",
          "name": "Grok Vision Beta",
          "cost": {
            "input": 5.0,
            "output": 15.0
          },
          "limit": {
            "context": 8192,
            "output": 4096
          },
          "temperature": true,
          "tool_call": true,
          "attachment": true,
          "modalities": {
            "input": ["text", "image"],
            "output": ["text"]
          }
        }
      }
    },

    // OpenRouter (für Qwen und andere Modelle)
    "openrouter": {
      "name": "OpenRouter",
      "env": ["OPENROUTER_API_KEY"],
      "options": {}
    },

    // GitHub Copilot (für Codex)
    "github-copilot": {
      "name": "GitHub Copilot",
      "options": {}
    }
  }
}
```

### Projekt-spezifische Konfiguration

Erstelle `opencode.jsonc` in deinem Projektordner:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",

  // Projekt-spezifisches Modell
  "model": "anthropic/claude-sonnet-4-5-20250929",

  // Plugins laden (für GitHub Copilot/Codex)
  "plugin": ["opencode-openai-codex-auth"],

  // Provider-Overrides für dieses Projekt
  "provider": {
    "opencode": {
      "options": {
        // Optional: Lokaler OpenCode-Server
        // "baseURL": "http://localhost:8080"
      }
    }
  }
}
```

---

## 🤖 Modell-spezifische Konfiguration

### 1. Claude (Anthropic)

**Verfügbare Modelle:**
- `claude-opus-4-5` - Bestes Modell
- `claude-sonnet-4-5` - Schnell und leistungsstark (empfohlen)
- `claude-haiku-4-5` - Schnell und günstig

**Setup:**
```bash
# API-Key besorgen von: https://console.anthropic.com/
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Verwendung:**
```bash
opencode --model anthropic/claude-sonnet-4-5-20250929
```

---

### 2. Codex (OpenAI/GitHub Copilot)

**Option A: GitHub Copilot (empfohlen)**

1. Plugin installieren:
```bash
npm install -g opencode-openai-codex-auth
```

2. Authentifizierung:
```bash
opencode auth login github-copilot
```

3. Konfiguration in `opencode.jsonc`:
```jsonc
{
  "plugin": ["opencode-openai-codex-auth"],
  "provider": {
    "github-copilot": {
      "options": {}
    }
  }
}
```

**Option B: Direkt über OpenAI**

```bash
export OPENAI_API_KEY="sk-..."
```

**Verfügbare Modelle:**
- `gpt-5-chat`
- `gpt-4.5-turbo`
- `o3-mini`

---

### 3. Gemini (Google)

**Verfügbare Modelle:**
- `gemini-2.5-pro-latest`
- `gemini-2.5-flash-latest`
- `gemini-exp-1206`

**Setup:**
```bash
# API-Key besorgen von: https://makersuite.google.com/app/apikey
export GOOGLE_API_KEY="AIza..."
```

**Verwendung:**
```bash
opencode --model google/gemini-2.5-flash-latest
```

---

### 4. Qwen (Alibaba)

Qwen ist über verschiedene Provider verfügbar:

**Option A: OpenRouter (empfohlen)**

```bash
export OPENROUTER_API_KEY="sk-or-..."
```

Verfügbare Qwen-Modelle über OpenRouter:
- `qwen/qwen-2.5-72b-instruct`
- `qwen/qwen-2-72b-instruct`
- `qwen/qwq-32b-preview`

```bash
opencode --model openrouter/qwen/qwen-2.5-72b-instruct
```

**Option B: Direkt über Together AI**

```bash
export TOGETHER_API_KEY="..."
```

---

### 5. Grok (xAI)

**Setup:**
```bash
# API-Key besorgen von: https://console.x.ai/
export XAI_API_KEY="xai-..."
```

**Manuelle Konfiguration in `~/.config/opencode/opencode.jsonc`:**

```jsonc
{
  "provider": {
    "xai": {
      "name": "xAI",
      "env": ["XAI_API_KEY"],
      "api": "https://api.x.ai/v1",
      "npm": "@ai-sdk/openai-compatible",
      "models": {
        "grok-beta": {
          "id": "grok-beta",
          "name": "Grok Beta",
          "cost": {
            "input": 5.0,
            "output": 15.0,
            "cache_read": 0.5,
            "cache_write": 6.25
          },
          "limit": {
            "context": 131072,
            "output": 4096
          },
          "temperature": true,
          "reasoning": false,
          "attachment": false,
          "tool_call": true,
          "modalities": {
            "input": ["text"],
            "output": ["text"]
          }
        },
        "grok-vision-beta": {
          "id": "grok-vision-beta",
          "name": "Grok Vision Beta",
          "cost": {
            "input": 5.0,
            "output": 15.0
          },
          "limit": {
            "context": 8192,
            "output": 4096
          },
          "temperature": true,
          "reasoning": false,
          "attachment": true,
          "tool_call": true,
          "modalities": {
            "input": ["text", "image"],
            "output": ["text"]
          }
        }
      }
    }
  }
}
```

**Verwendung:**
```bash
opencode --model xai/grok-beta
```

---

## 🎯 Modell-Auswahl im Terminal

### Beim Start:
```bash
opencode --model anthropic/claude-sonnet-4-5-20250929
```

### Während der Nutzung:
Drücke `Tab` um zwischen verschiedenen Agents zu wechseln:
- **build** - Standard-Agent mit vollem Zugriff
- **plan** - Read-only Agent für Analyse

### Alle verfügbaren Modelle anzeigen:
```bash
opencode models
```

---

## 📁 Konfigurationspfade (Priorität)

OpenCode lädt die Konfiguration in dieser Reihenfolge:

1. `$OPENCODE_CONFIG` (benutzerdefinierte Config-Datei)
2. `opencode.jsonc` / `opencode.json` im Projektordner oder Parent-Verzeichnissen
3. `.opencode/opencode.jsonc` im Projektordner
4. `$HOME/.config/opencode/opencode.jsonc` (globale Config)
5. `$OPENCODE_CONFIG_CONTENT` (Inline JSON)
6. `.well-known/opencode` Endpoints

---

## 🧪 Installation testen

```bash
# OpenCode starten
opencode

# Mit spezifischem Modell
opencode --model anthropic/claude-sonnet-4-5-20250929

# Mit Debug-Logging
OPENCODE_LOG_LEVEL=debug opencode

# Verfügbare Provider anzeigen
opencode providers

# Verfügbare Modelle anzeigen
opencode models
```

---

## 🛠️ Development Setup (optional)

Falls du an OpenCode entwickeln möchtest:

```bash
# Repository klonen
git clone https://github.com/sst/opencode
cd opencode

# Dependencies installieren
bun install

# Dev-Server starten
bun dev

# Build
./packages/opencode/script/build.ts

# Tests
bun test
```

**System-Anforderungen:**
- Bun >= 1.3.3
- Node.js 20
- Go 1.24+ (für SDK-Entwicklung)
- Git

---

## 📊 Modell-Vergleich

| Modell | Provider | Kosten (Input/Output) | Context | Empfehlung |
|--------|----------|----------------------|---------|------------|
| Claude Sonnet 4.5 | Anthropic | $3/$15 pro 1M Tokens | 200K | ⭐ Beste Balance |
| Claude Opus 4.5 | Anthropic | $15/$75 pro 1M Tokens | 200K | Höchste Qualität |
| Gemini 2.5 Flash | Google | $0.10/$0.30 pro 1M | 1M | Sehr günstig |
| Grok Beta | xAI | $5/$15 pro 1M Tokens | 131K | Gut für Experimente |
| Qwen 2.5 72B | OpenRouter | ~$0.60/$0.60 pro 1M | 32K | Open Source Alternative |
| GPT-5 Chat | OpenAI/Copilot | Variiert | Variiert | Via Copilot |

---

## 🔧 Troubleshooting

### API-Keys werden nicht erkannt
```bash
# Überprüfen ob Env-Variablen gesetzt sind
env | grep -E "ANTHROPIC|OPENAI|GOOGLE|XAI"

# Shell neu laden
source ~/.zshrc
```

### Provider nicht verfügbar
```bash
# Provider-Liste anzeigen
opencode providers

# Mit Debug-Logging starten
OPENCODE_LOG_LEVEL=debug opencode
```

### Homebrew Installation fehlgeschlagen
```bash
# Homebrew aktualisieren
brew update
brew upgrade

# Neu installieren
brew uninstall opencode
brew install opencode
```

### Grok/xAI Modell nicht gefunden
Stelle sicher, dass die Konfiguration in `~/.config/opencode/opencode.jsonc` korrekt ist und der `XAI_API_KEY` gesetzt ist.

---

## 📚 Weitere Ressourcen

- **Dokumentation:** https://opencode.ai/docs
- **Discord:** https://discord.gg/opencode
- **GitHub:** https://github.com/sst/opencode
- **X/Twitter:** https://x.com/opencode

---

## 🎉 Fertig!

Du bist jetzt bereit, OpenCode mit allen gewünschten AI-Modellen zu nutzen:

```bash
# Mit Claude starten
opencode

# Mit Grok starten
opencode --model xai/grok-beta

# Mit Gemini starten
opencode --model google/gemini-2.5-flash-latest
```

Viel Erfolg! 🚀

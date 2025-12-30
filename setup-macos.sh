#!/usr/bin/env bash
#
# OpenCode macOS Setup Script
# Automatisierte Installation und Konfiguration für macOS
#

set -euo pipefail

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emoji support
CHECKMARK="✅"
ROCKET="🚀"
GEAR="⚙️"
WARN="⚠️"
INFO="ℹ️"

echo ""
echo "${BLUE}${ROCKET} OpenCode macOS Setup${NC}"
echo "=================================================="
echo ""

# ============================================================================
# Schritt 1: System-Überprüfung
# ============================================================================
echo "${GEAR} Überprüfe System..."

# Überprüfe ob macOS läuft
if [[ "$(uname)" != "Darwin" ]]; then
    echo "${RED}${WARN} Fehler: Dieses Script ist nur für macOS!${NC}"
    exit 1
fi

# Überprüfe Architektur
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    echo "${GREEN}${CHECKMARK} Apple Silicon (M-Series) erkannt${NC}"
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "${GREEN}${CHECKMARK} Intel Mac erkannt${NC}"
else
    echo "${RED}${WARN} Unbekannte Architektur: $ARCH${NC}"
    exit 1
fi

# ============================================================================
# Schritt 2: Package Manager überprüfen
# ============================================================================
echo ""
echo "${GEAR} Überprüfe Package Manager..."

HAS_BREW=false
HAS_NPM=false
HAS_BUN=false

if command -v brew &> /dev/null; then
    echo "${GREEN}${CHECKMARK} Homebrew gefunden: $(brew --version | head -1)${NC}"
    HAS_BREW=true
else
    echo "${YELLOW}${INFO} Homebrew nicht gefunden${NC}"
fi

if command -v npm &> /dev/null; then
    echo "${GREEN}${CHECKMARK} npm gefunden: v$(npm --version)${NC}"
    HAS_NPM=true
else
    echo "${YELLOW}${INFO} npm nicht gefunden${NC}"
fi

if command -v bun &> /dev/null; then
    echo "${GREEN}${CHECKMARK} bun gefunden: v$(bun --version)${NC}"
    HAS_BUN=true
else
    echo "${YELLOW}${INFO} bun nicht gefunden${NC}"
fi

# ============================================================================
# Schritt 3: OpenCode Installation
# ============================================================================
echo ""
echo "${ROCKET} Installiere OpenCode..."

if command -v opencode &> /dev/null; then
    CURRENT_VERSION=$(opencode --version 2>/dev/null || echo "unknown")
    echo "${YELLOW}${INFO} OpenCode ist bereits installiert: $CURRENT_VERSION${NC}"
    read -p "Möchtest du OpenCode aktualisieren? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "${INFO} Überspringe Installation"
    else
        if [[ "$HAS_BREW" == true ]]; then
            brew upgrade opencode
        elif [[ "$HAS_NPM" == true ]]; then
            npm update -g opencode-ai
        elif [[ "$HAS_BUN" == true ]]; then
            bun update -g opencode-ai
        fi
    fi
else
    # Wähle beste Installations-Methode
    if [[ "$HAS_BREW" == true ]]; then
        echo "${INFO} Installiere via Homebrew..."
        brew install opencode
    elif [[ "$HAS_BUN" == true ]]; then
        echo "${INFO} Installiere via bun..."
        bun install -g opencode-ai@latest
    elif [[ "$HAS_NPM" == true ]]; then
        echo "${INFO} Installiere via npm..."
        npm install -g opencode-ai@latest
    else
        echo "${INFO} Installiere via curl..."
        curl -fsSL https://opencode.ai/install | bash
        export PATH="$HOME/.opencode/bin:$PATH"
    fi
fi

# Überprüfe Installation
if command -v opencode &> /dev/null; then
    echo "${GREEN}${CHECKMARK} OpenCode erfolgreich installiert!${NC}"
    opencode --version
else
    echo "${RED}${WARN} OpenCode Installation fehlgeschlagen!${NC}"
    exit 1
fi

# ============================================================================
# Schritt 4: Konfigurationsverzeichnis erstellen
# ============================================================================
echo ""
echo "${GEAR} Erstelle Konfigurationsverzeichnis..."

CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$CONFIG_DIR"
echo "${GREEN}${CHECKMARK} Verzeichnis erstellt: $CONFIG_DIR${NC}"

# ============================================================================
# Schritt 5: API-Keys konfigurieren
# ============================================================================
echo ""
echo "${GEAR} API-Keys konfigurieren..."
echo ""
echo "Für welche AI-Provider möchtest du API-Keys einrichten?"
echo "(Drücke Enter um zu überspringen)"
echo ""

# Bestimme Shell-Config-Datei
SHELL_CONFIG=""
if [[ "$SHELL" == */zsh ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
    echo "${INFO} Verwende zsh: $SHELL_CONFIG"
elif [[ "$SHELL" == */bash ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
    echo "${INFO} Verwende bash: $SHELL_CONFIG"
elif [[ "$SHELL" == */fish ]]; then
    SHELL_CONFIG="$HOME/.config/fish/config.fish"
    echo "${INFO} Verwende fish: $SHELL_CONFIG"
else
    echo "${YELLOW}${WARN} Unbekannte Shell: $SHELL${NC}"
    echo "Du musst die API-Keys manuell zu deiner Shell-Config hinzufügen."
fi

# Backup der Shell-Config
if [[ -n "$SHELL_CONFIG" ]] && [[ -f "$SHELL_CONFIG" ]]; then
    cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
    echo "${GREEN}${CHECKMARK} Backup erstellt: $SHELL_CONFIG.backup${NC}"
fi

declare -A API_KEYS

# Anthropic Claude
echo ""
read -p "Anthropic API Key (für Claude) [Enter zum Überspringen]: " ANTHROPIC_KEY
if [[ -n "$ANTHROPIC_KEY" ]]; then
    API_KEYS[ANTHROPIC_API_KEY]="$ANTHROPIC_KEY"
fi

# Google Gemini
echo ""
read -p "Google API Key (für Gemini) [Enter zum Überspringen]: " GOOGLE_KEY
if [[ -n "$GOOGLE_KEY" ]]; then
    API_KEYS[GOOGLE_API_KEY]="$GOOGLE_KEY"
fi

# xAI Grok
echo ""
read -p "xAI API Key (für Grok) [Enter zum Überspringen]: " XAI_KEY
if [[ -n "$XAI_KEY" ]]; then
    API_KEYS[XAI_API_KEY]="$XAI_KEY"
fi

# OpenRouter (für Qwen)
echo ""
read -p "OpenRouter API Key (für Qwen) [Enter zum Überspringen]: " OPENROUTER_KEY
if [[ -n "$OPENROUTER_KEY" ]]; then
    API_KEYS[OPENROUTER_API_KEY]="$OPENROUTER_KEY"
fi

# OpenAI
echo ""
read -p "OpenAI API Key (optional) [Enter zum Überspringen]: " OPENAI_KEY
if [[ -n "$OPENAI_KEY" ]]; then
    API_KEYS[OPENAI_API_KEY]="$OPENAI_KEY"
fi

# Schreibe API-Keys in Shell-Config
if [[ -n "$SHELL_CONFIG" ]] && [[ ${#API_KEYS[@]} -gt 0 ]]; then
    echo "" >> "$SHELL_CONFIG"
    echo "# OpenCode API Keys - Added by setup-macos.sh on $(date)" >> "$SHELL_CONFIG"

    for KEY in "${!API_KEYS[@]}"; do
        if [[ "$SHELL" == */fish ]]; then
            echo "set -gx $KEY \"${API_KEYS[$KEY]}\"" >> "$SHELL_CONFIG"
        else
            echo "export $KEY=\"${API_KEYS[$KEY]}\"" >> "$SHELL_CONFIG"
        fi
        echo "${GREEN}${CHECKMARK} $KEY hinzugefügt${NC}"
    done

    echo "${GREEN}${CHECKMARK} API-Keys zu $SHELL_CONFIG hinzugefügt${NC}"
    echo "${INFO} Führe 'source $SHELL_CONFIG' aus oder starte ein neues Terminal"
fi

# ============================================================================
# Schritt 6: Konfigurationsdatei erstellen
# ============================================================================
echo ""
echo "${GEAR} Erstelle Konfigurationsdatei..."

CONFIG_FILE="$CONFIG_DIR/opencode.jsonc"

if [[ -f "$CONFIG_FILE" ]]; then
    echo "${YELLOW}${INFO} Konfigurationsdatei existiert bereits: $CONFIG_FILE${NC}"
    read -p "Möchtest du sie überschreiben? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "${INFO} Behalte existierende Konfiguration"
        CONFIG_FILE="${CONFIG_DIR}/opencode.new.jsonc"
        echo "${INFO} Neue Konfiguration wird nach $CONFIG_FILE geschrieben"
    fi
fi

# Kopiere Beispiel-Konfiguration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_CONFIG="$SCRIPT_DIR/opencode.macos.example.jsonc"

if [[ -f "$EXAMPLE_CONFIG" ]]; then
    cp "$EXAMPLE_CONFIG" "$CONFIG_FILE"
    echo "${GREEN}${CHECKMARK} Konfiguration erstellt: $CONFIG_FILE${NC}"
else
    echo "${YELLOW}${WARN} Beispiel-Konfiguration nicht gefunden: $EXAMPLE_CONFIG${NC}"
    echo "${INFO} Erstelle minimale Konfiguration..."

    cat > "$CONFIG_FILE" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5-20250929",
  "small_model": "anthropic/claude-haiku-4-5",
  "provider": {
    "anthropic": {
      "env": ["ANTHROPIC_API_KEY"]
    },
    "google": {
      "env": ["GOOGLE_API_KEY"]
    },
    "xai": {
      "env": ["XAI_API_KEY"],
      "api": "https://api.x.ai/v1",
      "npm": "@ai-sdk/openai-compatible"
    },
    "openrouter": {
      "env": ["OPENROUTER_API_KEY"]
    }
  }
}
EOF
    echo "${GREEN}${CHECKMARK} Minimale Konfiguration erstellt${NC}"
fi

# ============================================================================
# Schritt 7: GitHub Copilot Plugin (optional)
# ============================================================================
echo ""
read -p "Möchtest du das GitHub Copilot Plugin installieren? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "${GEAR} Installiere GitHub Copilot Plugin..."

    if [[ "$HAS_NPM" == true ]]; then
        npm install -g opencode-openai-codex-auth
        echo "${GREEN}${CHECKMARK} Plugin installiert${NC}"
        echo "${INFO} Führe 'opencode auth login github-copilot' aus um dich zu authentifizieren"
    elif [[ "$HAS_BUN" == true ]]; then
        bun install -g opencode-openai-codex-auth
        echo "${GREEN}${CHECKMARK} Plugin installiert${NC}"
        echo "${INFO} Führe 'opencode auth login github-copilot' aus um dich zu authentifizieren"
    else
        echo "${YELLOW}${WARN} npm oder bun wird benötigt für Plugin-Installation${NC}"
    fi
fi

# ============================================================================
# Fertig!
# ============================================================================
echo ""
echo "=================================================="
echo "${GREEN}${ROCKET} Setup abgeschlossen!${NC}"
echo "=================================================="
echo ""
echo "${INFO} Nächste Schritte:"
echo ""
echo "1. Starte ein neues Terminal oder führe aus:"
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "   ${BLUE}source $SHELL_CONFIG${NC}"
fi
echo ""
echo "2. Teste die Installation:"
echo "   ${BLUE}opencode --version${NC}"
echo ""
echo "3. Zeige verfügbare Provider:"
echo "   ${BLUE}opencode providers${NC}"
echo ""
echo "4. Zeige verfügbare Modelle:"
echo "   ${BLUE}opencode models${NC}"
echo ""
echo "5. Starte OpenCode:"
echo "   ${BLUE}opencode${NC}"
echo ""
echo "6. Mit spezifischem Modell:"
echo "   ${BLUE}opencode --model anthropic/claude-sonnet-4-5-20250929${NC}"
echo "   ${BLUE}opencode --model xai/grok-beta${NC}"
echo "   ${BLUE}opencode --model google/gemini-2.5-flash-latest${NC}"
echo ""
echo "${INFO} Konfigurationsdatei:"
echo "   $CONFIG_FILE"
echo ""
echo "${INFO} Dokumentation:"
echo "   https://opencode.ai/docs"
echo ""
echo "${GREEN}Viel Erfolg! 🚀${NC}"
echo ""

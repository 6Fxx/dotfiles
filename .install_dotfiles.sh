#!/usr/bin/env bash
# install_dotfiles.sh — Télécharge .bashrc, .vimrc et .tmux.conf depuis GitHub (6Fxx/dotfiles)
# et propose remplacement ou sauvegarde en .new

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/6Fxx/dotfiles/main"
DOTFILES=(".bashrc" ".vimrc" ".tmux.conf")
DEST="$HOME"

# Couleurs
RED='\033[0;31m'
YEL='\033[1;33m'
GRN='\033[0;32m'
CYA='\033[0;36m'
NC='\033[0m'

# Dépendance : curl
if ! command -v curl &>/dev/null; then
    echo -e "${RED}[ERREUR]${NC} curl est introuvable. Installe-le et relance le script."
    exit 1
fi

echo -e "${CYA}══════════════════════════════════════════${NC}"
echo -e "${CYA}   Installer les dotfiles de 6Fxx/dotfiles${NC}"
echo -e "${CYA}══════════════════════════════════════════${NC}"
echo

for FILE in "${DOTFILES[@]}"; do
    TARGET="${DEST}/${FILE}"
    TMP_FILE=$(mktemp /tmp/dotfile_XXXXXX)
    URL="${REPO_RAW}/${FILE}"

    echo -e "${YEL}▶ Traitement de ${FILE}...${NC}"

    # Téléchargement
    HTTP_CODE=$(curl -fsSL -w "%{http_code}" -o "$TMP_FILE" "$URL" 2>/dev/null || true)
    if [[ "$HTTP_CODE" != "200" ]] || [[ ! -s "$TMP_FILE" ]]; then
        echo -e "  ${RED}[ERREUR]${NC} Impossible de télécharger ${FILE} (HTTP ${HTTP_CODE}). Fichier ignoré."
        rm -f "$TMP_FILE"
        echo
        continue
    fi
    echo -e "  ${GRN}[OK]${NC} Téléchargé avec succès."

    # Cas 1 : le fichier cible n'existe pas
    if [[ ! -e "$TARGET" ]]; then
        cp "$TMP_FILE" "$TARGET"
        echo -e "  ${GRN}[INSTALLÉ]${NC} ${TARGET} créé (aucun fichier préexistant)."
        rm -f "$TMP_FILE"
        echo
        continue
    fi

    # Affiche la différence si les fichiers sont identiques
    if cmp -s "$TMP_FILE" "$TARGET"; then
        echo -e "  ${GRN}[IDENTIQUE]${NC} ${FILE} est déjà à jour. Aucune action nécessaire."
        rm -f "$TMP_FILE"
        echo
        continue
    fi

    # Fichier existant et différent → demander l'action
    echo -e "  ${YEL}[CONFLIT]${NC} Un fichier ${TARGET} existe déjà et diffère de la version distante."
    echo -e "  Que souhaitez-vous faire ?"
    echo -e "    ${GRN}[1]${NC} Remplacer l'existant"
    echo -e "    ${GRN}[2]${NC} Enregistrer la version distante sous ${FILE}.new"
    echo -e "    ${GRN}[3]${NC} Ignorer (ne rien faire)"

    while true; do
        read -r -p "  Votre choix [1/2/3] : " CHOICE
        case "$CHOICE" in
            1)
                cp "$TMP_FILE" "$TARGET"
                echo -e "  ${GRN}[REMPLACÉ]${NC} ${TARGET} mis à jour."
                break
                ;;
            2)
                NEW_TARGET="${TARGET}.new"
                # Si le .new existe déjà → proposer écrasement
                if [[ -e "$NEW_TARGET" ]]; then
                    echo -e "  ${YEL}[AVERTISSEMENT]${NC} Le fichier ${FILE}.new existe déjà."
                    read -r -p "  Écraser ${FILE}.new ? [o/N] : " OVERWRITE
                    if [[ "$OVERWRITE" =~ ^[oO]$ ]]; then
                        cp "$TMP_FILE" "$NEW_TARGET"
                        echo -e "  ${GRN}[ÉCRASÉ]${NC} ${NEW_TARGET} mis à jour."
                    else
                        echo -e "  ${YEL}[IGNORÉ]${NC} ${FILE}.new conservé tel quel."
                    fi
                else
                    cp "$TMP_FILE" "$NEW_TARGET"
                    echo -e "  ${GRN}[SAUVEGARDÉ]${NC} Version distante enregistrée sous ${NEW_TARGET}."
                fi
                break
                ;;
            3)
                echo -e "  ${YEL}[IGNORÉ]${NC} ${FILE} inchangé."
                break
                ;;
            *)
                echo -e "  ${RED}[INVALIDE]${NC} Entrez 1, 2 ou 3."
                ;;
        esac
    done

    rm -f "$TMP_FILE"
    echo
done

echo -e "${CYA}══════════════════════════════════════════${NC}"
echo -e "${GRN}  Installation terminée.${NC}"
echo -e "${CYA}══════════════════════════════════════════${NC}"

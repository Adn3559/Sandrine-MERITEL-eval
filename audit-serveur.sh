#!/bin/bash
set -euo pipefail

# --- Variables globales ---
VERBOSE=false
OUTPUT=""

# --- Fonction : afficher l'aide ---
afficher_aide() {
  echo "Usage : $0 [-o fichier] [-v] [-h] <dossier>"
  echo ""
  echo "Options :"
  echo "  -o FICHIER   Sauvegarde le rapport dans FICHIER"
  echo "  -v           Mode verbose"
  echo "  -h           Affiche l'aide"
}

# --- Fonction : afficher les statistiques ---
afficher_stats() {
  local dossier="$1"
  local nb_fichiers nb_dossiers taille nb_vides

  nb_fichiers=$(find "$dossier" -type f | wc -l)
  nb_dossiers=$(find "$dossier" -type d | wc -l)
  taille=$(du -sh "$dossier" | cut -f1)
  nb_vides=$(find "$dossier" -type f -empty | wc -l)

  echo "📊 STATISTIQUES"
  echo "  Nombre de fichiers  : $nb_fichiers"
  echo "  Nombre de dossiers  : $nb_dossiers"
  echo "  Taille totale       : $taille"
  echo "  Fichiers vides      : $nb_vides"
  echo ""
}

# --- Fonction : top 3 extensions ---
afficher_extensions() {
  local dossier="$1"

  echo "📂 TOP 3 EXTENSIONS"
  find "$dossier" -type f | grep -o '\.[^.]*$' | sed 's/\.//' | sort | uniq -c | sort -rn | head -3
  echo ""
}

# --- Fonction : fichiers sensibles ---
afficher_sensibles() {
  local dossier="$1"
  local mots="DB_HOST\|API_KEY\|PASSWORD\|SECRET\|TOKEN"

  echo "🔒 FICHIERS SENSIBLES DÉTECTÉS"
  grep -rl "$mots" "$dossier" | while read -r fichier; do
    mot=$(grep -o "$mots" "$fichier" | head -1)
    echo "  $fichier  (contient : $mot)"
  done
  echo ""
}

# --- Fonction : mode verbose ---
afficher_verbose() {
  local dossier="$1"

  echo "📋 FICHIERS VIDES DÉTAILLÉS"
  find "$dossier" -type f -empty | while read -r f; do
    echo "  $f"
  done
  echo ""

  echo "📝 TODOs DÉTECTÉS"
  grep -rn "TODO" "$dossier" 2>/dev/null || echo "  Aucun TODO trouvé."
  echo ""
}

# =========================================
# PARSING DES OPTIONS avec getopts
# =========================================
while getopts "o:vh" option; do
  case "$option" in
    o) OUTPUT="$OPTARG" ;;
    v) VERBOSE=true ;;
    h) afficher_aide; exit 0 ;;
    *) afficher_aide; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# --- Vérification de l'argument <dossier> ---
if [ $# -eq 0 ]; then
  echo "Erreur : aucun dossier spécifié."
  afficher_aide
  exit 1
fi

dossier="$1"

if [ ! -d "$dossier" ]; then
  echo "Erreur : '$dossier' n'est pas un dossier."
  exit 1
fi

# =========================================
# GÉNÉRATION DU RAPPORT
# =========================================
generer_rapport() {
  local dossier="$1"
  local date_rapport
  date_rapport=$(date '+%Y-%m-%d %H:%M:%S')

  echo "========================================="
  echo "   AUDIT SERVEUR - $date_rapport"
  echo "========================================="
  echo ""
  echo "📁 Dossier analysé  : $dossier"
  echo ""
  afficher_stats "$dossier"
  afficher_extensions "$dossier"
  afficher_sensibles "$dossier"

  if [ "$VERBOSE" = true ]; then
    afficher_verbose "$dossier"
  fi

  echo "========================================="
  echo "   FIN DU RAPPORT"
  echo "========================================="
}

# --- Lancement avec ou sans sauvegarde ---
if [ -n "$OUTPUT" ]; then
  generer_rapport "$dossier" | tee "$OUTPUT"
else
  generer_rapport "$dossier"
fi

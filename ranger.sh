#!/bin/bash
set -euo pipefail

# ranger.sh - Range les fichiers d'un dossier par extension
# Usage : ./ranger.sh <dossier>

if [ -z "$1" ]; then
  echo "Usage : $0 <dossier>"
  exit 1
fi

dossier="$1"

if [ ! -d "$dossier" ]; then
  echo "Erreur : '$dossier' n'est pas un dossier."
  exit 1
fi

for fichier in "$dossier"/*; do
  if [ ! -f "$fichier" ]; then
    continue
  fi

  nom=$(basename "$fichier")
  ext="${nom##*.}"

  case "$ext" in
    jpg|jpeg|png|gif|svg)
      cible="Photos"
      ;;
    pdf|doc|docx)
      cible="Documents"
      ;;
    *)
      cible="Autres"
      ;;
  esac

  mkdir -p "$dossier/$cible"
  mv "$fichier" "$dossier/$cible/"
  echo "  $nom → $cible/"
done

echo "Rangement terminé."

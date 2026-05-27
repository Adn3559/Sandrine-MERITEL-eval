#!/bin/bash
set -euo pipefail

# backup.sh - Sauvegarde avec rotation
# Usage : ./backup.sh

BACKUP_DIR="$HOME/eval-bash/backups"
LOG="$HOME/eval-bash/backup.log"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE="$BACKUP_DIR/backup-$DATE.tar.gz"

# Créer le dossier backups si besoin
mkdir -p "$BACKUP_DIR"

# Créer l'archive
tar -czf "$ARCHIVE" -C "$HOME/eval-bash" webstudio
echo "[$DATE] Archive créée : $ARCHIVE" >> "$LOG"

# Rotation : garder uniquement les 3 plus récentes
find "$BACKUP_DIR" -name "backup-*.tar.gz" | sort -r | tail -n +4 | while read -r old; do
  rm "$old"
  echo "[$DATE] Supprimé : $old" >> "$LOG"
done

echo "Backup terminé : $ARCHIVE"

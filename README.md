# Évaluation Bash & Automatisation

**Nom** : MERITEL Sandrine
**Date** : 27 mai 2026

## Présentation
Ce TP consiste à auditer un dossier serveur simulé (webstudio).
J'ai écrit des commandes d'inspection, analysé des logs Apache,
créé un script d'audit automatisé et planifié son exécution avec cron.

## Usage du script audit-serveur.sh
```bash
./audit-serveur.sh [-o fichier] [-v] [-h] <dossier>
```

## Installation de la tâche cron
```bash
crontab -e
# Ajouter :
0 8 * * * /home/sandrine/eval-bash/audit-serveur.sh -o /home/sandrine/eval-bash/audit-$(date +\%F).txt /home/sandrine/eval-bash/webstudio
```

## Difficultés rencontrées
L'écriture du script et que tous les tests fonctionnent.

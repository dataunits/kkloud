#!/bin/bash

# Nom du projet CLI Python
CLI_NAME="kkloud"

# Chemin où installer l'environnement virtuel
VENV_DIR="$HOME/.venvs/$CLI_NAME"

# Chemin où placer le lien symbolique pour le rendre accessible globalement
LOCAL_BIN="$HOME/.local/bin"

# Verifie si Python et pip sont installés
if ! command -v python3 &>/dev/null; then
    echo "Python3 n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

if ! command -v pip3 &>/dev/null; then
    echo "pip3 n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Crée un environnement virtuel
echo "Création de l'environnement virtuel dans $VENV_DIR..."
python3 -m venv "$VENV_DIR"

# Active l'environnement virtuel
source "$VENV_DIR/bin/activate"

file_contents=$(< ./kkloud)
echo "#! ${VENV_DIR}/bin/python3" > kkloud
echo "${file_contents}" >> kkloud

cp kkloud "$VENV_DIR/bin/"

# Installation du CLI Python 
if [ -f "requirements.txt" ]; then
    echo "Installation des dépendances à partir de requirements.txt..."
    pip install -r requirements.txt
else
    echo "Installation du CLI Python $CLI_NAME..."
    pip install "$CLI_NAME"
fi

# Création d'un lien symbolique pour rendre la commande accessible globalement
if [ ! -d "$LOCAL_BIN" ]; then
    mkdir -p "$LOCAL_BIN"
fi

echo "Création d'un lien symbolique dans $LOCAL_BIN/$CLI_NAME..."
ln -sf "$VENV_DIR/bin/$CLI_NAME" "$LOCAL_BIN/$CLI_NAME"

# Assure que ~/.local/bin est dans le PATH
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo "Ajout de ~/.local/bin au PATH dans ~/.bash_profile"
    echo "export PATH=\"$LOCAL_BIN/$CLI_NAME:\$PATH\"" >> ~/.bash_profile
    export PATH="$LOCAL_BIN/$CLI_NAME:$PATH"
fi

# Vérifie si le CLI a été installé avec succès
if ! command -v $CLI_NAME &>/dev/null; then
    echo "L'installation du CLI a échoué."
    deactivate
    exit 1
fi

# Désactive l'environnement virtuel
deactivate

echo "$CLI_NAME a été installé avec succès et est maintenant accessible globalement."

# Instructions pour l'utilisateur
echo "Si vous ne pouvez pas encore exécuter la commande, redémarrez le terminal ou exécutez :"
echo "source ~/.bash_profile"

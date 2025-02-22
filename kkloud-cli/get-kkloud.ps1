# Nom du projet CLI Python
$CLI_NAME = "kkloud"

# Chemin où installer l'environnement virtuel
$VENV_DIR = "$env:USERPROFILE\.venvs\$CLI_NAME"

# Chemin où placer le lien symbolique pour le rendre accessible globalement
$LOCAL_BIN = "$env:USERPROFILE\.local\bin"

# Verifie si Python et pip sont installés
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python n'est pas installé. Veuillez l'installer d'abord."
    exit 1
}

if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
    Write-Host "pip n'est pas installé. Veuillez l'installer d'abord."
    exit 1
}

# Crée un environnement virtuel
Write-Host "Création de l'environnement virtuel dans $VENV_DIR..."
python -m venv $VENV_DIR

# Active l'environnement virtuel
$activateScript = "$VENV_DIR\Scripts\Activate.ps1"
& $activateScript

# Copie le contenu du fichier kkloud et ajoute le shebang
$fileContents = Get-Content .\kkloud -Raw
Set-Content -Path .\kkloud -Value "#! $VENV_DIR\Scripts\python.exe`n$fileContents"

Copy-Item .\kkloud "$VENV_DIR\Scripts\"

# Installation du CLI Python (par exemple depuis un fichier requirements.txt ou un package spécifique)
if (Test-Path "requirements.txt") {
    Write-Host "Installation des dépendances à partir de requirements.txt..."
    pip install -r requirements.txt
} else {
    Write-Host "Installation du CLI Python $CLI_NAME..."
    pip install $CLI_NAME
}

# Création d'un lien symbolique pour rendre la commande accessible globalement
if (-not (Test-Path $LOCAL_BIN)) {
    New-Item -ItemType Directory -Path $LOCAL_BIN
}

Write-Host "Création d'un lien symbolique dans $LOCAL_BIN\$CLI_NAME..."
New-Item -ItemType SymbolicLink -Path "$LOCAL_BIN\$CLI_NAME" -Target "$VENV_DIR\Scripts\$CLI_NAME.exe"

# Assure que ~/.local/bin est dans le PATH
if (-not ($env:PATH -contains $LOCAL_BIN)) {
    Write-Host "Ajout de ~/.local/bin au PATH dans le profil PowerShell"
    $profilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1"
    if (-not (Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath
    }
    Add-Content -Path $profilePath -Value "`n`$env:PATH += `";$LOCAL_BIN`""
    $env:PATH += ";$LOCAL_BIN"
}

# Vérifie si le CLI a été installé avec succès
if (-not (Get-Command $CLI_NAME -ErrorAction SilentlyContinue)) {
    Write-Host "L'installation du CLI a échoué."
    & $VENV_DIR\Scripts\deactivate.ps1
    exit 1
}

# Désactive l'environnement virtuel
& $VENV_DIR\Scripts\deactivate.ps1

Write-Host "$CLI_NAME a été installé avec succès et est maintenant accessible globalement."

# Instructions pour l'utilisateur
Write-Host "Si vous ne pouvez pas encore exécuter la commande, redémarrez le terminal ou exécutez :"
Write-Host "powershell -ExecutionPolicy Bypass -File $profilePath"
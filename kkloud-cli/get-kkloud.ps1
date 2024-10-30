# Nom du projet CLI Python
$CLI_NAME = "kkloud"

# Chemin où installer l'environnement virtuel
$VENV_DIR = "$HOME\.venvs\$CLI_NAME"

# Chemin où placer le lien symbolique pour le rendre accessible globalement
$LOCAL_BIN = "$HOME\AppData\Local\Scripts"

# Verifie si Python et pip sont installés
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python n'est pas installé. Veuillez l'installer d'abord." -ForegroundColor Red
    exit 1
}

if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
    Write-Host "pip n'est pas installé. Veuillez l'installer d'abord." -ForegroundColor Red
    exit 1
}

# Crée un environnement virtuel
Write-Host "Création de l'environnement virtuel dans $VENV_DIR..." -ForegroundColor Green
python -m venv $VENV_DIR

# Active l'environnement virtuel
& "$VENV_DIR\Scripts\Activate.ps1"

$file_contents = Get-Content -Raw -Path "./kkloud"
"#! $VENV_DIR\Scripts\python.exe" | Out-File -FilePath kkloud -Encoding UTF8
$file_contents | Out-File -FilePath kkloud -Append -Encoding UTF8

Copy-Item -Path kkloud -Destination "$VENV_DIR\Scripts\"

# Installation du CLI Python (par exemple depuis un fichier requirements.txt ou un package spécifique)
if (Test-Path "requirements.txt") {
    Write-Host "Installation des dépendances à partir de requirements.txt..." -ForegroundColor Green
    pip install -r requirements.txt
} else {
    Write-Host "Installation du CLI Python $CLI_NAME..." -ForegroundColor Green
    pip install $CLI_NAME
}

# Création d'un lien symbolique pour rendre la commande accessible globalement
if (-not (Test-Path $LOCAL_BIN)) {
    New-Item -ItemType Directory -Path $LOCAL_BIN
}

Write-Host "Création d'un lien symbolique dans $LOCAL_BIN\$CLI_NAME..." -ForegroundColor Green
New-Item -ItemType SymbolicLink -Path "$LOCAL_BIN\$CLI_NAME" -Target "$VENV_DIR\Scripts\$CLI_NAME" -Force

# Assure que $LOCAL_BIN est dans le PATH
if (-not ($env:Path -like "*$LOCAL_BIN*")) {
    Write-Host "Ajout de $LOCAL_BIN au PATH dans le profil utilisateur." -ForegroundColor Green
    Add-Content -Path "$PROFILE" -Value "`$env:Path += `"$LOCAL_BIN`""
    $env:Path += $LOCAL_BIN
}

# Vérifie si le CLI a été installé avec succès
if (-not (Get-Command $CLI_NAME -ErrorAction SilentlyContinue)) {
    Write-Host "L'installation du CLI a échoué." -ForegroundColor Red
    deactivate
    exit 1
}

# Désactive l'environnement virtuel
deactivate

Write-Host "$CLI_NAME a été installé avec succès et est maintenant accessible globalement." -ForegroundColor Green

# Instructions pour l'utilisateur
Write-Host "Si vous ne pouvez pas encore exécuter la commande, redémarrez le terminal ou exécutez :" -ForegroundColor Yellow
Write-Host "powershell.exe -ExecutionPolicy Bypass -File $PROFILE" -ForegroundColor Yellow

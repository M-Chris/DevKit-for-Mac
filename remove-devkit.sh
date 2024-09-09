#!/bin/bash

# Function to back up MySQL databases
backup_mysql() {
  echo "Backing up MySQL databases..."
  if command -v mysqldump &> /dev/null; then
    timestamp=$(date +"%Y%m%d%H%M%S")
    backup_dir="$HOME/mysql_backups"
    mkdir -p "$backup_dir"
    databases=$(mysql -e "SHOW DATABASES;" -s --skip-column-names)

    for db in $databases; do
      mysqldump "$db" > "$backup_dir/${db}_${timestamp}.sql"
    done
    echo "MySQL databases backed up to $backup_dir."
  else
    echo "MySQL not found. Skipping backup."
  fi
}

# Function to back up PostgreSQL databases
backup_postgresql() {
  echo "Backing up PostgreSQL databases..."
  if command -v pg_dump &> /dev/null; then
    timestamp=$(date +"%Y%m%d%H%M%S")
    backup_dir="$HOME/postgresql_backups"
    mkdir -p "$backup_dir"
    databases=$(psql -U postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

    for db in $databases; do
      pg_dump "$db" > "$backup_dir/${db}_${timestamp}.sql"
    done
    echo "PostgreSQL databases backed up to $backup_dir."
  else
    echo "PostgreSQL not found. Skipping backup."
  fi
}

# Function to back up MongoDB databases
backup_mongodb() {
  echo "Backing up MongoDB databases..."
  if command -v mongodump &> /dev/null; then
    timestamp=$(date +"%Y%m%d%H%M%S")
    backup_dir="$HOME/mongodb_backups"
    mkdir -p "$backup_dir"
    databases=$(mongo --quiet --eval "db.adminCommand('listDatabases').databases.forEach(function(d){print(d.name)})")

    for db in $databases; do
      mongodump --db "$db" --out "$backup_dir/${db}_${timestamp}"
    done
    echo "MongoDB databases backed up to $backup_dir."
  else
    echo "MongoDB not found. Skipping backup."
  fi
}

# Function to remove Homebrew and all installed packages
uninstall_homebrew() {
  echo "Uninstalling Homebrew..."
  if command -v brew &> /dev/null; then
    echo "Removing all Homebrew packages..."
    brew list | xargs brew uninstall --force
    echo "Removing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    echo "Homebrew uninstalled."
  else
    echo "Homebrew not found. Skipping uninstallation."
  fi
}

# Function to uninstall Miniconda
uninstall_miniconda() {
  echo "Uninstalling Miniconda..."
  if command -v conda &> /dev/null; then
    conda install anaconda-clean --yes
    anaconda-clean --yes
    rm -rf "$HOME/miniconda3"
    echo "Miniconda uninstalled."
  else
    echo "Miniconda not found. Skipping uninstallation."
  fi
}

# Function to uninstall Go
uninstall_go() {
  echo "Uninstalling Go..."
  if command -v go &> /dev/null; then
    brew uninstall go
    echo "Go uninstalled."
  else
    echo "Go not found. Skipping uninstallation."
  fi
}

# Function to uninstall Rust
uninstall_rust() {
  echo "Uninstalling Rust..."
  if command -v rustc &> /dev/null; then
    rustup self uninstall -y
    echo "Rust uninstalled."
  else
    echo "Rust not found. Skipping uninstallation."
  fi
}

# Function to uninstall NVM (Node Version Manager) and Node.js
uninstall_nvm() {
  echo "Uninstalling NVM and Node.js..."
  if [ -d "$HOME/.nvm" ]; then
    rm -rf "$HOME/.nvm"
    sed -i.bak '/export NVM_DIR=\"$HOME\/\.nvm\"/d' ~/.bashrc ~/.zshrc
    echo "NVM and Node.js uninstalled."
  else
    echo "NVM not found. Skipping uninstallation."
  fi
}

# Function to uninstall Docker Desktop
uninstall_docker_desktop() {
  echo "Uninstalling Docker Desktop..."
  if command -v docker &> /dev/null; then
    brew uninstall --cask docker
    echo "Docker Desktop uninstalled."
  else
    echo "Docker Desktop not found. Skipping uninstallation."
  fi
}

# Function to uninstall Git
uninstall_git() {
  echo "Uninstalling Git..."
  if command -v git &> /dev/null; then
    brew uninstall git
    echo "Git uninstalled."
  else
    echo "Git not found. Skipping uninstallation."
  fi
}

# Function to uninstall Visual Studio Code
uninstall_vscode() {
  echo "Uninstalling Visual Studio Code..."
  if command -v code &> /dev/null; then
    brew uninstall --cask visual-studio-code
    echo "Visual Studio Code uninstalled."
  else
    echo "Visual Studio Code not found. Skipping uninstallation."
  fi
}

# Function to uninstall Azure CLI
uninstall_azure_cli() {
  echo "Uninstalling Azure CLI..."
  if command -v az &> /dev/null; then
    brew uninstall azure-cli
    echo "Azure CLI uninstalled."
  else
    echo "Azure CLI not found. Skipping uninstallation."
  fi
}

# Function to uninstall Google Cloud SDK
uninstall_google_cloud_sdk() {
  echo "Uninstalling Google Cloud SDK..."
  if command -v gcloud &> /dev/null; then
    brew uninstall --cask google-cloud-sdk
    echo "Google Cloud SDK uninstalled."
  else
    echo "Google Cloud SDK not found. Skipping uninstallation."
  fi
}

# Function to uninstall AWS CLI
uninstall_aws_cli() {
  echo "Uninstalling AWS CLI..."
  if command -v aws &> /dev/null; then
    brew uninstall awscli
    echo "AWS CLI uninstalled."
  else
    echo "AWS CLI not found. Skipping uninstallation."
  fi
}

# Function to uninstall optional libraries and tools
uninstall_optional_tools() {
  echo "Uninstalling optional libraries and tools..."

  # Uninstall Kubernetes CLI (kubectl), Helm, Terraform
  echo "Uninstalling Kubernetes CLI (kubectl), Helm, and Terraform..."
  brew uninstall kubectl terraform helm

  # Uninstall additional DevOps tools
  echo "Uninstalling additional DevOps tools..."
  brew uninstall ansible vault consul packer vagrant docker-compose

  # Uninstall Puppeteer
  echo "Uninstalling Puppeteer..."
  npm uninstall -g puppeteer

  # Uninstall data science libraries
  echo "Removing data science libraries (NumPy, Pandas, etc.)..."
  if command -v conda &> /dev/null; then
    conda remove --yes numpy pandas matplotlib scipy jupyterlab
  fi

  echo "Optional tools uninstalled."
}

# Function to remove aliases from shell profile
remove_aliases() {
  echo "Removing aliases from shell profile..."
  if [[ $SHELL == *"zsh"* ]]; then
    profile="$HOME/.zshrc"
  elif [[ $SHELL == *"bash"* ]]; then
    profile="$HOME/.bashrc"
  fi
  
  if [ -n "$profile" ]; then
    sed -i.bak '/alias mysqlstart=/d' "$profile"
    sed -i.bak '/alias mysqlstop=/d' "$profile"
    sed -i.bak '/alias pgstart=/d' "$profile"
    sed -i.bak '/alias pgstop=/d' "$profile"
    sed -i.bak '/alias mongostart=/d' "$profile"
    sed -i.bak '/alias mongostop=/d' "$profile"
    echo "Aliases removed from $profile."
  fi
}

# Function to show uninstallation warnings and disclaimer
show_disclaimer() {
  echo ""
  echo "WARNING: This script will uninstall various tools and remove their configurations."
  echo "You will lose all data associated with these tools if you do not back it up."
  echo "Please ensure you have backed up any important data before proceeding."
  echo ""
  read -p "Do you want to continue with the uninstallation? (y/n) " proceed
  if [[ "$proceed" != "y" && "$proceed" != "Y" ]]; then
    echo "Uninstallation aborted."
    exit 1
  fi
}

# Main uninstallation function
main_uninstall() {
  show_disclaimer
  backup_mysql
  backup_postgresql
  backup_mongodb

  uninstall_homebrew
  uninstall_miniconda
  uninstall_go
  uninstall_rust
  uninstall_nvm
  uninstall_docker_desktop
  uninstall_git
  uninstall_vscode
  uninstall_azure_cli
  uninstall_google_cloud_sdk
  uninstall_aws_cli
  uninstall_optional_tools

  remove_aliases

  echo "Uninstallation complete!"
}

# Execute the main uninstallation function
main_uninstall
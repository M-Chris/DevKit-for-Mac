#!/bin/bash

source_shell_profile() {
  if [[ $SHELL == *"zsh"* ]]; then
    echo "Reloading .zshrc"
    source ~/.zshrc
  elif [[ $SHELL == *"bash"* ]]; then
    echo "Reloading .bashrc"
    source ~/.bashrc
  else
    echo -e "\033[1;31mUnable to detect shell profile, please restart your terminal manually.\033[0m"
  fi
}

# Function to check if Homebrew is installed
install_homebrew() {
  source_shell_profile
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to .zshrc
    if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zshrc"; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    fi
    
    # Add Homebrew to .bashrc for bash users (optional)
    if [[ -f "$HOME/.bashrc" ]] && ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.bashrc"; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
    fi

    # Apply the Homebrew environment to the current shell session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Reload shell profile to ensure Homebrew is available
    source_shell_profile
  else
    echo "Homebrew is already installed."
  fi

  if ! command -v brew &> /dev/null; then
    echo -e "\033[1;31mError: Homebrew installation failed. Exiting setup.\033[0m"
    exit 1
  fi
}

# Function to install Miniconda using Homebrew
install_miniconda() {
  if ! command -v conda &> /dev/null; then
    echo "Installing Miniconda via Homebrew..."
    brew install --cask miniconda
    
    source_shell_profile
  else
    echo "Miniconda is already installed."
  fi
}

# Function to initialize Conda
initialize_conda() {
  echo "Initializing Conda..."
  
  # Use the correct profile for Conda initialization based on the current shell
  if [[ $SHELL == *"zsh"* ]]; then
    echo "Initializing Conda for Zsh..."
    conda init zsh
    eval "$(conda shell.zsh hook)"
  elif [[ $SHELL == *"bash"* ]]; then
    echo "Initializing Conda for Bash..."
    conda init bash
    eval "$(conda shell.bash hook)"
  else
    echo -e "\033[1;31mUnable to detect shell type. Please ensure Conda is properly initialized manually.\033[0m"
    return 1
  fi

  # Activate the base Conda environment
  conda activate base
  
  # Install Python 3.12 in the base environment
  conda install -n base python=3.12 -y
  
  # Reload the shell profile
  source_shell_profile
}

# Function to install Go
install_go() {
  if ! command -v go &> /dev/null; then
    echo "Installing Go..."
    brew install go
  else
    echo "Go is already installed."
  fi
}

# Function to install Rust
install_rust() {
  if ! command -v rustc &> /dev/null; then
    echo "Installing Rust using rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
  else
    echo "Rust is already installed."
  fi
}

# Function to install NVM (Node Version Manager)
install_nvm() {
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

  # Choose the correct profile based on the shell
  if [[ $SHELL == *"zsh"* ]]; then
    echo "Configuring NVM for Zsh..."
    profile="$HOME/.zshrc"
  elif [[ $SHELL == *"bash"* ]]; then
    echo "Configuring NVM for Bash..."
    profile="$HOME/.bashrc"
  else
    echo -e "\033[1;31mUnable to detect shell type. Please ensure NVM is properly configured manually.\033[0m"
    profile="$HOME/.bash_profile"
  fi

  # Ensure NVM_DIR and paths are added only once
  if ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$profile"; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> "$profile"
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$profile"
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> "$profile"
  else
    echo "NVM already correctly configured in $profile."
  fi

  # Reload the profile to apply NVM settings immediately
  source "$profile"
  nvm install --lts
  echo "NVM and latest LTS version of Node.js installed."
}

# Function to install Yarn via npm
install_yarn() {
  read -p "Install Yarn package manager? (y/n) " install_yarn
  if [[ "$install_yarn" == "y" || "$install_yarn" == "Y" ]]; then
    echo "Installing Yarn globally via npm..."
    npm install -g yarn
    echo "Yarn installed globally via npm."
  fi
}

# Function to install Docker Desktop (instead of Brew's Docker)
install_docker_desktop() {
  if ! command -v docker &> /dev/null; then
    echo "Installing Docker Desktop..."
    brew install --cask docker
  else
    echo "Docker Desktop is already installed."
  fi
}

# Function to install Git
install_git() {
  if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    brew install git
  else
    echo "Git is already installed."
  fi
}

# Function to install Visual Studio Code and recommended extensions
install_vscode() {
  if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
  else
    echo "Visual Studio Code is already installed."
  fi

  # Install extensions from vscode-extensions.txt
  if [ -f "vscode-extensions.txt" ]; then
    echo "Installing VS Code extensions from vscode-extensions.txt..."
    while IFS= read -r vscode-extension; do
      code --install-extension "$extension"
    done < extensions.txt
    echo "VS Code extensions installation completed."
  else
    echo -e "\033[1;31mvscode-extensions.txt file not found. Skipping extension installation.\033[0m"
  fi
}

# Function to add useful aliases to shell profile
add_aliases() {
  echo "Adding useful aliases..."

  # Detect shell and set the correct profile path
  if [[ $SHELL == *"zsh"* ]]; then
    profile="$HOME/.zshrc"
  elif [[ $SHELL == *"bash"* ]]; then
    profile="$HOME/.bashrc"
  fi

  # Function to safely add an alias if it doesn't already exist
  add_alias_if_not_exists() {
    local alias_line="$1"
    local alias_name=$(echo "$alias_line" | cut -d'=' -f1)
    
    if ! grep -q "^$alias_name" "$profile"; then
      echo "$alias_line" >> "$profile"
    else
      echo "Alias $alias_name already exists. Skipping."
    fi
  }

  # Add aliases safely
  add_alias_if_not_exists 'alias mysqlstart="brew services start mysql"'
  add_alias_if_not_exists 'alias mysqlstop="brew services stop mysql"'
  add_alias_if_not_exists 'alias pgstart="brew services start postgresql"'
  add_alias_if_not_exists 'alias pgstop="brew services stop postgresql"'
  add_alias_if_not_exists 'alias mongostart="brew services start mongodb/brew/mongodb-community@7.0"'
  add_alias_if_not_exists 'alias mongostop="brew services stop mongodb/brew/mongodb-community@7.0"'

  # Apply changes
  source "$profile"
  echo "Aliases added and applied. You may need to restart your terminal."
}

# Function to install Azure CLI
install_azure_cli() {
  echo "Installing Azure CLI..."
  brew install azure-cli
  echo "Azure CLI installation completed."
}

# Function to install Google Cloud SDK
install_google_cloud_sdk() {
  echo "Installing Google Cloud SDK..."
  brew install --cask google-cloud-sdk
  echo "Google Cloud SDK installation completed."
}

# Function to install AWS CLI
install_aws_cli() {
  echo "Installing AWS CLI..."
  brew install awscli
  echo "AWS CLI installation completed."
}

# Function to configure databases after installation
configure_databases() {
  # MySQL setup
  if ! command -v mysql &> /dev/null; then
    echo "MySQL not found. Installing MySQL..."
    brew install mysql

    # Ask user to start MySQL after installation
    read -p "Start MySQL now? (y/n) " start_mysql
    if [[ "$start_mysql" == "y" || "$start_mysql" == "Y" ]]; then
      echo "Starting MySQL..."
      brew services start mysql
      echo "Running MySQL secure installation..."
      mysql_secure_installation
      echo "MySQL setup completed."
    else
      echo "MySQL installation completed, but the service was not started."
      echo "Skipping secure installation. You can run 'mysql_secure_installation' after starting MySQL."
    fi
  else
    echo "MySQL is already installed."
    
    # Ask user to start MySQL if it's already installed
    read -p "Start MySQL now? (y/n) " start_mysql
    if [[ "$start_mysql" == "y" || "$start_mysql" == "Y" ]]; then
      echo "Starting MySQL..."
      brew services start mysql
    else
      echo "MySQL service was not started. Skipping secure installation."
    fi
  fi

  # PostgreSQL setup
  brew install postgresql
  read -p "Start PostgreSQL now? (y/n) " start_postgres
  if [[ "$start_postgres" == "y" || "$start_postgres" == "Y" ]]; then
    echo "Starting PostgreSQL..."
    brew services start postgresql
  fi
  echo "Creating default PostgreSQL user and database..."
  createuser -s postgres
  echo "PostgreSQL setup completed."

  # MongoDB setup
  if ! command -v mongod &> /dev/null; then
    echo "MongoDB not found. Installing MongoDB Community Edition 7.0..."
    brew tap mongodb/brew
    brew install mongodb-community@7.0
  else
    echo "MongoDB is already installed."
  fi

  read -p "Start MongoDB now? (y/n) " start_mongodb
  if [[ "$start_mongodb" == "y" || "$start_mongodb" == "Y" ]]; then
    echo "Starting MongoDB..."
    brew services start mongodb/brew/mongodb-community@7.0
  fi
  echo "MongoDB setup completed."
}

# Function to install optional libraries/tools
install_optional_tools() {
  echo "Optional: Installing additional libraries and tools..."
  echo ""

  # Data science/machine learning tools
  read -p "Install data science libraries (NumPy, Pandas, Matplotlib, SciPy, JupyterLab, etc.)? (y/n) " install_data_sci
  if [[ "$install_data_sci" == "y" || "$install_data_sci" == "Y" ]]; then
    echo ""
    echo "Installing data science libraries..."
    echo ""
    conda install -y pytorch::pytorch -c pytorch
    conda config --add channels conda-forge
    conda install -y numpy pandas matplotlib scipy jupyterlab scikit-learn statsmodels seaborn \
                    keras xgboost lightgbm catboost nltk spacy dask plotly altair \
                    bokeh holoviews

    # Prompt for vision and audio
    read -p "Install PyTorch vision and audio libraries (torchvision, torchaudio)? (y/n) " install_vision_audio
    if [[ "$install_vision_audio" == "y" || "$install_vision_audio" == "Y" ]]; then
      conda install -y torchvision torchaudio -c pytorch
    fi
  fi

  # Puppeteer installation
  read -p "Install Puppeteer (headless Chrome/automation tool)? (y/n) " install_puppeteer
  if [[ "$install_puppeteer" == "y" || "$install_puppeteer" == "Y" ]]; then
    npm install -g puppeteer
    echo "Puppeteer installed globally."
  fi

  # DevOps tools
  read -p "Install Kubernetes CLI (kubectl), Helm, and Terraform? (y/n) " install_devops
  if [[ "$install_devops" == "y" || "$install_devops" == "Y" ]]; then
    brew install kubectl terraform helm
  fi

  # Additional DevOps tools
  read -p "Install additional DevOps tools (Ansible, Vault, Consul, Packer, Vagrant, Docker Compose)? (y/n) " install_additional_devops
  if [[ "$install_additional_devops" == "y" || "$install_additional_devops" == "Y" ]]; then
    brew install ansible vault consul packer vagrant docker-compose
  fi
}

# Function to verify installations
verify_installations() {
  echo ""
  echo "Verifying installations..."
  echo ""
  # Helper function to check installation and display version
  check_installation() {
    if command -v $1 &> /dev/null; then
      if [[ "$1" == "go" ]]; then
        version=$(go version)
      else
        version=$($1 --version | head -n 1)
      fi
      echo -e "\033[1;32m$2: Installed ($version)\033[0m"
    else
      echo -e "\033[1;31m$2: Not installed\033[0m"
    fi
  }

  # Check each tool and display version if installed
  check_installation conda "Conda"
  check_installation go "Go"
  check_installation rustc "Rust"
  check_installation node "Node.js"
  check_installation npm "npm"
  check_installation yarn "Yarn"
  check_installation docker "Docker"
  check_installation git "Git"
  check_installation code "VS Code"
  check_installation az "Azure CLI"
  check_installation gcloud "Google Cloud SDK"
}

# Function to show post-installation notes and next steps
show_post_install_notes() {
  echo ""
  echo "Installation complete!"
  echo ""
  echo "Next steps:"
  echo "- Add your SSH public key to GitHub or GitLab (if generated)."
  echo "- Configure Git by running: git config --global user.name 'Your Name' and git config --global user.email 'your.email@example.com'."
  echo "- For Docker, try running: docker run hello-world to test the installation."
  echo "- For Azure CLI, run: az login to authenticate."
  echo "- For Google Cloud SDK, run: gcloud init to authenticate and configure."
  echo "- For AWS CLI, run: aws configure to set up your AWS credentials."
  echo "- For databases, run: mysql -u root -p, psql, and mongo to test the installations."
  echo "- For VS Code, open the editor and install recommended extensions from the Extensions view."
  echo "- For NVM, run: nvm use --lts to switch to the latest LTS version of Node.js."
  echo "- For Rust, run: rustc --version to verify the installation."
  echo "- For Go, run: go version to verify the installation."
  echo "- For Conda, run: conda --version to verify the installation."
  echo "- For Yarn, run: yarn --version to verify the installation."
  echo ""
  echo "Happy coding!"
  echo ""
  echo -e "\033[1;33mPlease restart your terminal to ensure all changes take effect.\033[0m"
}

# DevKit for Mac - Install everything without individual confirmations
devkit_for_mac_setup() {
  install_homebrew
  install_miniconda
  initialize_conda
  install_go
  install_rust
  install_nvm
  install_yarn
  install_docker_desktop
  install_git
  install_vscode
  install_azure_cli
  install_google_cloud_sdk
  install_aws_cli
  configure_databases
  install_optional_tools
  add_aliases
  verify_installations
  show_post_install_notes
}

# Main script execution
echo "Welcome to DevKit for Mac!"
read -p "Do you want to run the full DevKit for Mac setup? (y/n) " full_setup

if [[ "$full_setup" == "y" || "$full_setup" == "Y" ]]; then
  # Run the full DevKit for Mac setup
  devkit_for_mac_setup
else
  # Proceed with individual installations
  install_homebrew
  
  # Individual steps for each tool
  if [ -n "$full_setup" ]; then
    echo "Proceeding with individual installations..."
  else
    echo "Skipping full setup. Proceeding with individual installations..."
  fi
  
  read -p "Install Miniconda? (y/n) " install_miniconda
  if [[ "$install_miniconda" == "y" || "$install_miniconda" == "Y" ]]; then
    install_miniconda
    initialize_conda
  fi
  
  read -p "Install Go? (y/n) " install_go
  if [[ "$install_go" == "y" || "$install_go" == "Y" ]]; then
    install_go
  fi
  
  read -p "Install Rust? (y/n) " install_rust
  if [[ "$install_rust" == "y" || "$install_rust" == "Y" ]]; then
    install_rust
  fi
  
  read -p "Install NVM (Node Version Manager)? (y/n) " install_nvm
  if [[ "$install_nvm" == "y" || "$install_nvm" == "Y" ]]; then
    install_nvm
    install_yarn
  fi

  read -p "Install Docker Desktop? (y/n) " install_docker
  if [[ "$install_docker" == "y" || "$install_docker" == "Y" ]]; then
    install_docker_desktop
  fi
  
  read -p "Install Git? (y/n) " install_git
  if [[ "$install_git" == "y" || "$install_git" == "Y" ]]; then
    install_git
  fi
  
  read -p "Install Visual Studio Code and recommended extensions? (y/n) " install_vscode
  if [[ "$install_vscode" == "y" || "$install_vscode" == "Y" ]]; then
    install_vscode
  fi

  read -p "Install Azure CLI? (y/n) " install_azure
  if [[ "$install_azure" == "y" || "$install_azure" == "Y" ]]; then
    install_azure_cli
  fi

  read -p "Install Google Cloud SDK? (y/n) " install_gcloud
  if [[ "$install_gcloud" == "y" || "$install_gcloud" == "Y" ]]; then
    install_google_cloud_sdk
  fi
  
  read -p "Install AWS CLI? (y/n) " install_aws
  if [[ "$install_aws" == "y" || "$install_aws" == "Y" ]]; then
    install_aws_cli
  fi

  read -p "Configure databases (MySQL, PostgreSQL, MongoDB)? (y/n) " configure_dbs
  if [[ "$configure_dbs" == "y" || "$configure_dbs" == "Y" ]]; then
    configure_databases
  fi
  
  read -p "Install optional libraries and tools? (y/n) " install_optional
  if [[ "$install_optional" == "y" || "$install_optional" == "Y" ]]; then
    install_optional_tools
    add_aliases
  fi

  verify_installations
  show_post_install_notes
fi

echo "DevKit for Mac setup completed."
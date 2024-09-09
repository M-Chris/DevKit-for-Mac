# DevKit for Mac

**DevKit for Mac** is an all-in-one developer environment setup script for macOS. It installs the essential tools, libraries, and frameworks you need for software development on macOS with minimal effort.

## Features

- **Homebrew**: The package manager for macOS.
- **Miniconda**: Python environment and package management.
- **Node.js & NVM**: Node Version Manager for managing multiple Node.js versions.
- **Yarn**: Installed globally via npm for managing JavaScript packages.
- **Go**: Modern, statically typed programming language designed for building scalable systems.
- **Rust**: A systems programming language focused on safety, speed, and concurrency.
- **Docker Desktop**: For containerization.
- **Git**: Version control system.
- **Visual Studio Code**: The popular code editor, with support for extension installation.
- **Azure CLI**: For interacting with Microsoft Azure services.
- **Google Cloud SDK**: For interacting with Google Cloud services.
- **AWS CLI**: For interacting with Amazon AWS services.
- **Puppeteer**: Optional headless browser automation tool.
- **Helm**: Kubernetes package manager for managing charts and deploying applications.
- **Ansible**: Configuration management and automation tool.
- **Vault**: Secret management tool by HashiCorp for securely accessing and managing secrets.
- **Consul**: Service discovery and configuration tool by HashiCorp.
- **Packer**: Tool for creating machine images for multiple platforms.
- **Vagrant**: Tool for building and managing virtualized development environments.
- **Database Setup**: Installs MySQL, PostgreSQL, and MongoDB with optional service start and aliases for quick management.
- **Optional Tools**: Optionally install Python Data Science libraries, Kubernetes CLI, Terraform, and more.
- **Custom Aliases**: Aliases for managing MySQL, PostgreSQL, and MongoDB services easily.

## Prerequisites

Before running this script, make sure you have the following:

- A macOS system (version 10.15 or higher recommended).
- Internet access for downloading packages and tools.

## Installation

### Step 1: Check if Git is installed

   - 
      **macOS typically comes with Git pre-installed. To check if Git is available, open a terminal and run:**

      ```
      git --version
      ```
   - 
      **If Git is installed, this will return the Git version number. If Git is not installed, you can install it by running:**

      ```
      xcode-select --install
      ```

      This will install the Xcode Command Line Tools, including Git.

### Step 2: Clone the repository

   ```
   git clone https://github.com/M-Chris/DevKit-for-Mac.git
   ```

### Step 3: Navigate to the project directory

   ```
   cd DevKit-for-Mac
   ```

### Step 4: Run the setup script

   ```
   bash ./install-devkit.sh
   ```

## Full Setup Mode

When running the script, you will be prompted to choose the full **DevKit for Mac** setup or individual installations.

- If you select the full setup (`y` for yes), the script will automatically install all the key components, databases, and tools with minimal user interaction.
- If you prefer to install tools individually, you can select `n` for no and proceed with step-by-step installation prompts.

## Included Components

### Core Tools

   - **Homebrew**: The package manager for macOS.
   - **Miniconda**: Python package management.
   - **Node.js & NVM**: Node Version Manager for managing Node.js versions.
   - **Yarn**: A fast, reliable JavaScript package manager installed via npm.
   - **Go**: Installs the latest version of Go for building fast, statically typed applications.
   - **Rust**: Installs Rust using `rustup` for systems programming with a focus on safety and concurrency.
   - **Docker Desktop**: A GUI for Docker.
   - **Git**: Version control.
   - **VS Code**: Popular code editor, with extension installation support.

### Cloud & DevOps Tools

   - **Azure CLI**: Command-line tools for Azure.
   - **Google Cloud SDK**: Command-line tools for Google Cloud.
   - **AWS SDK**: Command-line tools for Amazon.
   - **Kubernetes CLI (kubectl)**: Optional installation.
   - **Terraform**: Infrastructure as code tool for managing cloud infrastructure.
   - **Ansible**: Automation tool for configuration management and deployment.
   - **Vault**: Tool for managing secrets and protecting sensitive data.
   - **Consul**: Service mesh solution for microservices networking.
   - **Packer**: Tool for creating machine images.
   - **Vagrant**: Tool for managing virtualized development environments.
   - **Docker Compose**: Tool for defining and running multi-container Docker applications.

### Databases

   - **MySQL**: Relational database with optional startup.
   - **PostgreSQL**: Relational database with optional startup.
   - **MongoDB**: NoSQL database with optional startup.
   - **Aliases for DB Management**:
   - `mysqlstart`, `mysqlstop` for starting/stopping MySQL.
   - `pgstart`, `pgstop` for starting/stopping PostgreSQL.
   - `mongostart`, `mongostop` for starting/stopping MongoDB.

### Optional Tools

You will be prompted during the setup to install:

   - **Puppeteer**: A headless Chrome browser automation tool.
   - **Python Data Science Libraries**: NumPy, Pandas, Matplotlib, JupyterLab.
   - **Kubernetes CLI (kubectl), Helm, Terraform**: DevOps tools for container orchestration and infrastructure as code.
   - **Additional DevOps Tools**: Ansible, Vault, Consul, Packer, Vagrant, Docker Compose.

## Post-Installation

Once the installation is complete, you will receive instructions on further steps, such as:

   - Adding your SSH public key to GitHub/GitLab.
   - Configuring Git with your username and email.
   - Running `docker run hello-world` to verify Docker installation.
   - Logging in to Azure (`az login`) and Google Cloud (`gcloud init`) to authenticate.

## How to Contribute

We welcome contributions! If you have ideas or want to improve this script, feel free to open a pull request.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/my-new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/my-new-feature`).
5. Open a pull request.

## Uninstall

To completely remove **DevKit for Mac** and all the installed components from your macOS system, you can use the `remove-devkit.sh` script included in the repository. Follow the steps below to perform a complete uninstallation.

### Disclaimer

**Warning:** This uninstallation process will remove all tools, libraries, databases, and configurations installed by **DevKit for Mac**. Ensure that you have backed up any important data before proceeding. The script will remove:

   - **Homebrew** and all packages installed through Homebrew.
   - **Miniconda** and its environments.
   - **Node.js**, **NVM**, and global npm packages.
   - **Go** and **Rust** installations.
   - **Docker Desktop** and its containers/images.
   - **Git**, **Visual Studio Code**, and their configurations.
   - **Cloud CLI tools** (Azure CLI, Google Cloud SDK, AWS CLI).
   - **Database services** (MySQL, PostgreSQL, MongoDB) and their data (if not backed up).

### How to Use `remove-devkit.sh`

1. **Backup Important Data**: 

   Before running the uninstallation script, ensure you manually back up your databases and any other critical data. Although the script performs a basic backup, it's highly recommended to verify and back up your data manually to ensure completeness and accuracy. This step is crucial for safeguarding your information against any unintended data loss during the uninstallation process.

   - **MySQL Backup:**
     ```bash
     mysqldump --all-databases > ~/mysql_backup.sql
     ```

   - **PostgreSQL Backup:**
     ```bash
     pg_dumpall > ~/postgresql_backup.sql
     ```

   - **MongoDB Backup:**
     ```bash
     mongodump --out ~/mongodb_backup
     ```

2. **Run the Uninstall Script**: Execute the script to remove all installed components.
     ```bash
     bash ./remove-devkit.sh
     ```

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.
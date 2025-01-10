# Competition Environment Setup

## Description
This project provides a simple, reliable, and efficient environment for web development competitions. Using Docker along with Gitea, Traefik, Watchtower, and MySQL, it allows organizers to set up a consistent competition environment with minimal effort. Competitors can focus on their work without worrying about complex configurations.

The environment includes:
1. **Docker**: Ensures consistent setups across systems.  
2. **Traefik**: Routes requests to the right services.  
3. **Watchtower**: Updates Docker containers automatically.  
4. **Gitea**: A Git server for version control.  
5. **MySQL**: Manages competition data.  

## Setting up the Environment

### Prerequisites
Ensure Docker is installed and running on your system.

### Commands
- **Initialize the environment:**  
  `./init.sh`
   
   **Note:** If you have previously run `./init.sh`, make sure to clean the environment first by running `./clean.sh` before initializing again. This ensures a fresh setup and avoids potential conflicts.

- **Stop the environment:**  
  `./stop.sh`

- **Restart the environment:**  
  `./start.sh`

- **Clean the entire system:**  
  `./clean.sh`

### Configuration
The environment is configured in the `config/main` file. Below are the key settings:

1. **Domain Name:**  The main domain for the competition.  
   **Example:** `local.skill17.com`

1. **HTTPS (Traefik):**  Enable (`true`) or disable (`false`) HTTPS.

2. **Root Credentials:**  
   - `Username` (Line 3)  
   - `Password` (Line 4)

3. **Modules (Competition Tasks):**  List the module names separated by spaces.  
   **Example:** `module_a module_b`

4. **Competitor credentials and subdomains:**  From line 6 onward, define competitors' credentials and subdomains:  
   `username password subdomain`  
   **Example:** `comp01 test123 qwer`

## Using the Environment

- **Git Server (Gitea):**  
  Access through the `git` subdomain of your configured domain.  
  **Example:** `https://git.local.skill17.com`

- **Competitors' Work:**  
  Competitors' projects can be accessed using their subdomain and the module name.  
  Format: `https://<subdomain>-<module_name>.<domain>`  
  **Example:** `https://qwer-module_a.local.skill17.com`

- **PHPMyAdmin (Database Management):**  
  Manage databases through the `pma` subdomain of your configured domain.  
  **Example:** `https://pma.local.skill17.com`

## Updates (Environment Repository)
   Before making changes to the environment repository, stop all Docker containers: `./stop.sh`


## Competitor Workflow

### Creating a Repository

1. **Access Gitea:**  
   Open your Git server (e.g., `https://git.local.skill17.com`) and log in using your credentials.

2. **Choose a Framework Template:**  
   Go to `organization -> frameworks` to pick a framework or the vanilla base for your repository. The templates include the necessary Docker and Gitea files with GitHub Actions ready to use. Check the [Frameworks Documentation](./frameworks.md) for details.  
   **Tip:** Keep frontend and backend in separate repositories for better organization.

3. **Use the Template:**  
   Click **"Use this template"** to create your repository. Name the repository to match the module name defined in the configuration file.  
   **Example:** If your module is `module_a`, name the repository `module_a`.

4. **Set Up Action Secrets:**  
   Go to **Settings → Actions → Secrets** in your new repository and add:  
   - **`USER`**: Your username (e.g., `comp01`)  
   - **`PASS`**: Your password (e.g., `test123`)

5. **Test the Setup:**  
   Make a commit to verify that GitHub Actions are working correctly.

### Cloning and using the Repository

1. Use the repository URL to clone it:  
   ```bash
   git clone https://git.local.skill17.com/<username>/<module_name>.git
   ```  
   **Example:**  
   ```bash
   git clone https://git.local.skill17.com/comp01/module_a.git
   ```

2. Edit, commit, and develop your code. Frequent commits help keep your work organized, and using branches allows you to work on features or fixes without affecting the main deployment. If competition organizers allow it, you can use third-party packages to support frameworks and enhance your project. Always keep your project README up to date with essential information about the repository, such as setup instructions and dependencies.

3. Every push automatically deploys to the competition URL (e.g., `https://<subdomain>-<module_name>.local.skill17.com`).  
   Be mindful of the number of pushes to avoid unnecessary deployments. Check your changes at the competition URL after each push.
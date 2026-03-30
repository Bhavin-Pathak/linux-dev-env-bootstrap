# 🚀 Cross-OS Dev Env Bootstrap

**One script to rule them all — now for Linux, macOS, and Windows!**  
Transform a fresh installation of your favorite OS into a **God-tier Development Machine** in minutes.

## ⚠️ Requirements

- **Linux**: Ubuntu 22.04 LTS / Debian-based distributions (`apt`, `snap`).
- **macOS**: Any modern macOS version (requires `brew`, but the script attempts to install it if missing).
- **Windows**: Windows 10/11 with PowerShell and `winget` (usually built-in).
- **Internet**: Required for downloading packages.

## ⚡ Quick Start

Forget running 20 commands. Just clone and run the OS-aware launcher:

### Mac & Linux
```bash
git clone https://github.com/Bhavin-Pathak/dev-env-bootstrap.git
cd dev-env-bootstrap
chmod +x start.sh mac/*.sh linux/*.sh
./start.sh
```

### Windows (PowerShell / CMD)
```cmd
git clone https://github.com/Bhavin-Pathak/dev-env-bootstrap.git
cd dev-env-bootstrap
.\start.bat
```

**`start`** is the master OS detector. It automatically routes you to the correct OS folder and triggers the `genesis` script, which launches an interactive menu where you can choose exactly what to install.

## 📂 Architecture

The repository is divided into 3 OS-specific folders:
- `/linux` - The original `apt`/`snap` bash scripts.
- `/mac` - Feature-matched `Homebrew` (`brew`) bash scripts.
- `/windows` - Beautiful, interactive `PowerShell` (`.ps1`) scripts utilizing `winget`.

## 🛠️ The Arsenal (Script Inventory)

Every script is standalone, but `genesis` brings them together.

| Script | Description |
| :--- | :--- |
| **`genesis`** | 🔥 **Master Menu**. The Origin. Runs all other scripts. |
| **`terminal`** | **Terminal**. Zsh/Oh-My-Posh, Hack Fonts, `bat`, `eza`, `fzf`. |
| **`ide`** | **IDEs**. VS Code, Cursor, Windsurf, Sublime, Notepad++. |
| **`browsers`** | **Browsers**. Chrome, Edge, Firefox, Brave, Vivaldi, Opera. |
| **`node-py`** | **Node & Python**. NVM, Node, Yarn, Bun, Python 3, Pip. |
| **`java-flutter`** | **Mobile**. OpenJDK 17, Flutter SDK (FVM), Android Studio. |
| **`cloud-docker`** | **DevOps**. Docker Desktop/Engine, AWS, Terraform, Kubectl. |
| **`db-tools`** | **Databases**. Postgres, Mongo, Redis, Milvus + GUIs. |
| **`api-test`** | **API Tools**. Postman, Insomnia. |
| **`essentials`** | **Apps**. Slack, Discord, Spotify, VLC, OBS, Steam. |
| **`cleaner`** | **Maintenance**. 🧹 Deep Clean: Temp, Cache, Trash, Docker. |
| **`cloudflare-warp`**| **VPN**. 🛡️ Cloudflare WARP client setup. |

---

## 🧠 Smart Features

- **OS Detection**: The root launchers automatically route you to the correct script without thinking.
- **Identical Experience**: Windows scripts aggressively mimic the exact look, feel, and colors of the Linux bash scripts!
- **Modular**: Run `genesis` for the menu, or navigate to your OS folder to run a specific script explicitly.
- **Safe Cleaning**: `cleaner` is aggressive but safe. It clears caches and unused containers but preserves projects.

---

<div align="center">
  <b>Built for Speed. Built for Devs.</b><br>
  <sub>Happy Coding! 🚀</sub>
</div>

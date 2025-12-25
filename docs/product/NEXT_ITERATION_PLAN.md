# Product Analysis & Next Iteration Scheme
**Project:** New-API Desktop (Wails Edition)
**Role:** Product Manager
**Date:** 2025-05-22

## 1. Project Analysis

### 1.1 Overview
The project aims to transform the popular server-side LLM Gateway `QuantumNous/new-api` (based on One API) into a standalone **Desktop Application** using the Wails framework (Go + React).

### 1.2 Core Value Proposition
*   **Unified Access:** Aggregate multiple LLM providers (OpenAI, Claude, DeepSeek, Google, etc.) into a single OpenAI-compatible endpoint (`http://localhost:3000/v1`).
*   **Privacy & Control:** Runs locally on the user's machine. Data (logs, keys) is stored in a local SQLite database, not in the cloud.
*   **Ease of Use:** "Download and Run" experience. Eliminates the complexity of Docker/Python setups (typical for One API/LiteLLM).
*   **Cost Control:** Detailed logging and quota management for personal or small team use.

### 1.3 Current State (Gap Analysis)
*   **Existing Asset:** A comprehensive Go backend (Gin) and React frontend designed for *server* deployment.
*   **Missing:**
    *   Desktop wrapper (Wails).
    *   Local file system integration (SQLite pathing).
    *   Single-user optimizations (Auto-login, removal of strict Redis dependencies).
    *   Frontend routing adaptation (`HashRouter`).

---

## 2. Market Research & Competitor Analysis

| Competitor / Tool | Type | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **One API / New API (Server)** | Server (Docker) | Feature rich, robust. | Hard to install for non-techs. Requires Docker/Server. |
| **LiteLLM** | Python CLI | Extremely powerful routing/proxying. | CLI only (mostly). No built-in UI for logs/keys management without extra setup. |
| **LM Studio / Ollama** | Model Runner | Runs local models easily. Exposes API. | Focuses on *inference*, not *aggregation* of external keys. Limited key management. |
| **Helicone / LangSmith** | Observability SaaS | Great analytics. | Cloud-hosted (privacy concern). SaaS pricing. |
| **NextChat / Chatbox** | Client UI | Great chat interface. Stores keys. | They are *clients*, not *gateways*. You can't point VS Code to NextChat. |

### 2.1 The Opportunity
There is a gap for a **"Desktop LLM Router"**. Power users and developers use multiple tools (IDEs, Chat Apps, CLI tools) and multiple providers (Ollama, OpenAI, Anthropic). They need a **central hub** running in the system tray to manage this traffic, switch models, and monitor costs without managing a Docker container.

---

## 3. Next Iteration Scheme (Roadmap)

The immediate goal is to reach **MVP (Minimum Viable Product)** status—a functional Desktop Port.

### Phase 1: The "Port" (MVP)
**Objective:** Get the existing server code running as a Wails desktop app.

#### 3.1 Backend Engineering
*   **Wails Integration:** Wrap the Gin engine start-up in a goroutine managed by Wails.
*   **Dependency Stripping:**
    *   **Remove Redis:** Enforce in-memory caching for tokens/quotas.
    *   **SQLite-Only:** Hardcode SQLite as the database driver.
    *   **Path Management:** utilize `os.UserConfigDir()` to store `new-api.db` (e.g., `~/AppData/Roaming/new-api/` on Windows) to prevent permission issues.
*   **Configuration:** Disable `.env` file loading or look for it in the User Data dir.
*   **Hardcode settings suitable for single-user desktop usage:**
    *   `PROD_MODE` = "true"
    *   `REDIS_ENABLED` = "false"
    *   `MEMORY_CACHE_ENABLED` = "true"

#### 3.2 Frontend Engineering
*   **Routing:** Switch React Router from `BrowserRouter` (history mode) to `HashRouter` (hash mode) to support file-protocol serving in Wails.
*   **API Client:** Hardcode the Axios base URL to `http://localhost:3000` (or the configured port) instead of relative paths.
*   **Asset Bundling:** Configure Vite to output relative paths (`./`) so assets load correctly in the Wails WebView.

#### 3.3 UX/UI Adaptations
*   **Single User Mode:**
    *   On first run, check if a root user exists.
    *   If not, auto-create one with a default password (e.g., `123456`) and display it.
    *   (Optional) Auto-fill login credentials or implement a "Localhost No-Auth" toggle for trusted local apps.

### Phase 2: Desktop Native Features (Differentiation)
**Objective:** Add features that make it superior to the Server version.

1.  **System Tray Application:**
    *   Minimize to tray.
    *   Right-click menu: "Copy API Key", "Copy Base URL", "Restart Server", "Switch Profile".
2.  **Ollama Auto-Discovery:**
    *   Periodically scan `localhost:11434/api/tags`.
    *   Automatically add running Ollama models as "Channels" in New-API.
3.  **Real-time Traffic Inspector:**
    *   A desktop window dedicated to watching streaming requests (headers, prompt tokens, response speed) in real-time.
4.  **Auto-Update:**
    *   Use Wails native updater to pull releases from GitHub.

---

## 4. Execution Plan (Next Steps)

1.  **Initialize Wails Project:** Create the skeleton.
2.  **Code Migration:** Copy `controller`, `model`, `router` from the upstream repo (or existing source) into the Wails structure.
3.  **Database Fix:** Modify `model/db.go` to use `UserConfigDir`.
4.  **Frontend Fix:** Modify `web/src/index.js` to use `HashRouter`.
5.  **Build & Test:** Verify the app launches and the API port (3000) is accessible.

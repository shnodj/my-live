# Design Document: New-API Desktop Gateway

## Overview
This document outlines the architecture and implementation strategy for transforming the [new-api](https://github.com/QuantumNous/new-api) server application into a standalone Desktop GUI application using [Wails](https://wails.io).

The goal is to provide a "single-user" local gateway for LLM services, where the user runs the application on their desktop (Windows/macOS/Linux), and it provides:
1.  A GUI to manage channels, keys, and logs.
2.  A local HTTP server (e.g., `http://localhost:3000`) acting as an OpenAI-compatible gateway.

## Architecture

### Current Architecture (Server-Side)
- **Backend**: Go (Gin framework).
- **Frontend**: React (Vite).
- **Database**: MySQL/PostgreSQL/SQLite (Server file path).
- **Cache**: Redis/Memory.
- **Deployment**: Docker/Binary on Server.

### New Architecture (Desktop)
- **Application Shell**: Wails (Go + Web).
  - Handles Window management, System Tray, and Native OS interactions.
  - Serves the frontend assets locally.
- **Backend (Embedded)**:
  - Runs the existing `new-api` Go logic *inside* the Wails binary.
  - **API Server**: A Gin HTTP server runs in a background goroutine to serve API requests (`/v1/...`) and external tool connections.
  - **Bridge**: Wails Bindings may be used for specific desktop-only interactions (e.g., "Open Config Folder", "Check Updates"), but the bulk of data fetching in the UI will still occur via HTTP requests to `localhost:3000` to minimize refactoring of the existing React frontend.
- **Frontend**:
  - Existing React app adapted to run in a "File Protocol" context (using HashRouter).
- **Storage**:
  - **SQLite Only**.
  - Database file location: `OS_USER_DATA_DIR/new-api/new-api.db`.
  - **No Redis**. In-memory cache is enforced.

## Key Implementation Details

### 1. Directory Structure
We will adopt a standard Wails structure while keeping the `new-api` core logic intact.

```
/
├── build/               # Wails build artifacts
├── frontend/            # Moved/Symlinked 'web' directory
│   ├── src/
│   └── ...
├── wails.json           # Wails configuration
├── main.go              # Wails entry point (New)
├── app.go               # Wails Application struct
├── backend/             # The original 'new-api' Go code (controller, model, etc.)
│   ├── model/
│   ├── controller/
│   └── ...
└── go.mod
```

*Note: To avoid deep nesting issues, we might keep the original `new-api` folders (`model`, `controller`, etc.) in the root and just wrap them in `main.go`.*

### 2. Backend Refactoring

#### Entry Point (`main.go`)
- The original `main.go` starts the server and blocks.
- The new `main.go` will initialize Wails.
- We will extract the "Start Server" logic into a function `StartApiService()` and run it in a goroutine.

#### Database (`model/db.go`)
- **Challenge**: The original code looks for `SQL_DSN` or uses a local file `./new-api.db`. This is bad for installed apps (read-only program files).
- **Solution**:
  - Import `os` and `path/filepath`.
  - Use `os.UserConfigDir()` to find a writable user directory.
  - Ensure the directory exists before initializing SQLite.
  - Force `common.UsingSQLite = true`.

#### Config & Environment
- Disable `.env` file loading or look for it in the User Data dir.
- Hardcode settings suitable for single-user desktop usage:
  - `PROD_MODE` = "true"
  - `REDIS_ENABLED` = "false"
  - `MEMORY_CACHE_ENABLED` = "true"

### 3. Frontend Refactoring

#### Routing
- **Problem**: `BrowserRouter` requires server-side history support. Wails serves files.
- **Solution**: Replace `BrowserRouter` with `HashRouter` in `web/src/index.js` (or `App.js`).

#### API Client
- **Problem**: The frontend expects `/api/...` to be relative to the domain serving the app. Wails serves from a custom scheme (e.g., `wails://`).
- **Solution**:
  - Update the Axios/Fetch base URL to point to `http://localhost:3000`.
  - Or, ensure the Wails "AssetServer" proxies api requests to the local backend port (Wails can handle this via `OnRequest` handler, but direct localhost call is often simpler for existing codebases).
  - *Decision*: We will configure the frontend API client to target `http://localhost:3000` explicitly.

### 4. Single User Mode
- The original app requires Login.
- For a local desktop app, we want to skip login or have a persistent "Root" session.
- **Approach**:
  - On first run, auto-generate a root user/password if missing (logic already exists).
  - **Option A**: Auto-fill login form.
  - **Option B**: Modify backend to accept localhost requests without auth for management endpoints (Risky if malware runs on PC).
  - **Selected Approach**: Keep the Auth mechanism for security (even local). The user logs in once. We can display the default credentials in the terminal/UI on first run.

## Plan Execution
1.  **Initialize**: Run `wails init` (simulated by creating files manually as I cannot run interactive CLI).
2.  **Migrate**: Move `web` to `frontend`.
3.  **Refactor Go**:
    - Edit `model/setup.go` or `db.go` for paths.
    - Create `app.go` (Wails bridge).
    - Rewrite `main.go`.
4.  **Refactor JS**:
    - `npm install` (if needed for hash router, usually built-in).
    - Search and replace Router components.
    - Set API Base URL.
5.  **Build**: Verify everything compiles.

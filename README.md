# New-API Desktop

This project is a desktop GUI application for [new-api](https://github.com/QuantumNous/new-api), built using [Wails](https://wails.io).

It is designed as a single-user local gateway for LLM services, running completely on your machine.

## Features

- **Desktop GUI**: Manage channels, keys, and logs through a native application window (Windows, macOS, Linux).
- **Local API Server**: Embeds the full `new-api` backend, exposing an OpenAI-compatible API at `http://localhost:3000`.
- **Single User Friendly**:
    - Data stored in SQLite in your user configuration directory (no external database server required).
    - Simplified configuration for local usage.
    - Persistent "root" session (or simplified login) optimized for personal use.

## Architecture

- **Shell**: [Wails](https://wails.io) (Go + Web) handles the window, system tray, and OS interactions.
- **Backend**: The core `new-api` logic runs as an embedded service within the application binary.
- **Frontend**: The existing React dashboard, adapted to run within the desktop shell using `HashRouter` and configured to communicate with the local backend.

## Getting Started

### Prerequisites

- [Go](https://go.dev/) (1.18+)
- [Node.js](https://nodejs.org/) (npm)

### Installation

1. Install the Wails CLI:
   ```bash
   go install github.com/wailsapp/wails/v2/cmd/wails@latest
   ```

2. Build the project:
   ```bash
   wails build
   ```

3. Run the application:
   - On Windows: `build/bin/new-api-desktop.exe`
   - On Mac: `build/bin/new-api-desktop.app`
   - On Linux: `build/bin/new-api-desktop`

## Configuration

The application automatically uses a SQLite database. The database file `new-api.db` is stored in your operating system's standard user configuration directory:
- **Windows**: `%APPDATA%\new-api`
- **Linux**: `~/.config/new-api`
- **macOS**: `~/Library/Application Support/new-api`

## Development

To run the application in development mode (with hot reload):

```bash
wails dev
```

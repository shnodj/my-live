<div align="center">

![new-api](/frontend/public/logo.png)

# New API Desktop

**New API Desktop** is a single-user local LLM gateway application, based on the powerful [New API](https://github.com/QuantumNous/new-api) server.

</div>

## 🚀 Features

- **Local & Private**: Runs on your desktop. Your data (keys, logs) stays on your machine.
- **SQLite Database**: Uses a local SQLite database in your user configuration directory.
- **Cross-Platform**: Built with Wails (Go + React), runs on Windows, macOS, and Linux.
- **LLM Gateway**: Manages channels, keys, and usage logs for various LLM providers (OpenAI, Claude, Gemini, etc.).

## 📦 Installation

### From Source

1. **Prerequisites**:
   - Go 1.21+
   - Node.js 18+
   - Wails CLI (`go install github.com/wailsapp/wails/v2/cmd/wails@latest`)

2. **Build**:
   ```bash
   git clone https://github.com/QuantumNous/new-api-desktop.git
   cd new-api-desktop
   wails build
   ```

3. **Run**:
   The binary will be in `build/bin`.

## 🛠️ Development

1. **Install Dependencies**:
   ```bash
   go mod tidy
   cd frontend && npm install
   ```

2. **Run Dev Mode**:
   ```bash
   wails dev
   ```

## 📂 Project Structure

- `frontend/`: React frontend (adapted from New API web).
- `backend/`: Go backend service (New API core).
- `main.go`: Wails application entry point.

## 🙏 Credits

Based on [New API](https://github.com/Calcium-Ion/new-api) by Calcium-Ion.
Original [One API](https://github.com/songquanpeng/one-api) by songquanpeng.

## 📄 License

Apache License 2.0

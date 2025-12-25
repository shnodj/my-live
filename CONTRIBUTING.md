# Contributing to New API Desktop

Thank you for your interest in contributing!

## Project Structure

- `frontend/`: The React frontend application.
- `backend/`: The Go backend service logic.
- `main.go`: The Wails application entry point.
- `app.go`: Wails application bridge.

## Development

1. **Prerequisites**:
   - Go 1.21+
   - Node.js 18+
   - Wails CLI (`go install github.com/wailsapp/wails/v2/cmd/wails@latest`)

2. **Setup**:
   ```bash
   git clone https://github.com/QuantumNous/new-api
   cd new-api
   go mod tidy
   cd frontend && npm install
   ```

3. **Run**:
   ```bash
   wails dev
   ```

4. **Build**:
   ```bash
   wails build
   ```

## Guidelines

- Follow the existing code style.
- Run `make lint` before submitting PRs.
- Ensure all tests pass.

# Makefile for New-API Desktop

.PHONY: all build dev test lint clean help

BINARY_NAME=new-api-desktop
BUILD_DIR=build/bin

# Default target
all: build

# Install dependencies (Go + Node)
deps:
	go mod download
	cd frontend && npm install

# Run the application in development mode
dev:
	wails dev

# Build the application for the current OS
build:
	wails build

# Clean build artifacts
clean:
	rm -rf build/bin/*

# Run tests
test: test-go test-frontend

test-go:
	go test ./...

test-frontend:
	cd frontend && npm test

# Linting
lint: lint-go lint-frontend

lint-go:
	# Assuming golangci-lint is installed
	golangci-lint run ./...

lint-frontend:
	cd frontend && npm run lint

# Help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  deps        Install dependencies"
	@echo "  dev         Run in development mode"
	@echo "  build       Build binary"
	@echo "  test        Run tests"
	@echo "  lint        Run linters"
	@echo "  clean       Remove build artifacts"

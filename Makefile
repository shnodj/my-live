.PHONY: build run lint clean test

APP_NAME := new-api
FRONTEND_DIR := frontend

build: build-frontend build-backend

build-frontend:
	cd $(FRONTEND_DIR) && npm install && npm run build

build-backend:
	wails build

run:
	wails dev

lint:
	golangci-lint run
	cd $(FRONTEND_DIR) && npm run lint

test:
	go test ./...

clean:
	rm -rf build/bin
	rm -rf $(FRONTEND_DIR)/dist

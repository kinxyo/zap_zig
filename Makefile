ZIG = zig
SRC = main.zig
TARGET = zap
INSTALL_DIR = /usr/local/bin
OPTIMIZE = ReleaseFast

all: build

build:
	$(ZIG) build-exe $(SRC) -O $(OPTIMIZE) --name $(TARGET)

install: build
	@echo "Installing $(TARGET) to $(INSTALL_DIR)..."
	@if [ -f "$(INSTALL_DIR)/$(TARGET)" ]; then \
		sudo rm $(INSTALL_DIR)/$(TARGET); \
		echo "Removed existing $(TARGET) from $(INSTALL_DIR)"; \
	fi
	sudo mv $(TARGET) $(INSTALL_DIR)/
	@echo "$(TARGET) installed successfully!"

uninstall:
	@if [ -f "$(INSTALL_DIR)/$(TARGET)" ]; then \
		sudo rm $(INSTALL_DIR)/$(TARGET); \
		echo "$(TARGET) uninstalled from $(INSTALL_DIR)"; \
	else \
		echo "$(TARGET) not found in $(INSTALL_DIR)"; \
	fi

clean:
	@if [ -f "$(TARGET)" ]; then rm $(TARGET); echo "Cleaned $(TARGET)"; fi
	@if [ -f "$(TARGET).o" ]; then rm $(TARGET).o; echo "Cleaned $(TARGET).o"; fi

dev:
	$(ZIG) build-exe $(SRC) --name $(TARGET)-dev
	@echo "Development build created: $(TARGET)-dev"

run: build
	./$(TARGET)

bench: install
	@echo "Benchmarking zap vs curl..."
	hyperfine '$(TARGET) httpbin.org/json' 'curl -s https://httpbin.org/json'

bench-local: install
	@echo "Benchmarking locally (make sure server is running on :8000)..."
	hyperfine --warmup 10 --runs 200 '$(TARGET) localhost:8000' 'curl -s http://localhost:8000'

help:
	@echo "Available targets:"
	@echo "  build       - Build the project (default)"
	@echo "  install     - Build and install to $(INSTALL_DIR)"
	@echo "  uninstall   - Remove from $(INSTALL_DIR)"
	@echo "  clean       - Clean build artifacts"
	@echo "  dev         - Build debug version"
	@echo "  run         - Build and run locally"
	@echo "  bench       - Benchmark against curl (remote)"
	@echo "  bench-local - Benchmark against curl (local server)"
	@echo "  help        - Show this help"

.PHONY: all build install uninstall clean dev run bench bench-local help

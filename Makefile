.PHONY: setup test clean build-macos build-windows

# Install dependencies
setup:
	flutter pub get

# Run tests with coverage
test:
	flutter test --coverage

# Clean build artifacts
clean:
	flutter clean

# Build for macOS
build-macos:
	flutter build macos

# Build for Windows
build-windows:
	flutter build windows

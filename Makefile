# Main script
SCRIPT = main.sh

# Default target
all: run

# Make executable and run
run: $(SCRIPT)
	chmod +x $(SCRIPT)
	./$(SCRIPT)

# Install dependencies (if any)
deps:
	# Add any dependency installation commands here
	# apt-get install -y some-package
	# pip install -r requirements.txt

# Development mode (with debugging)
dev: $(SCRIPT)
	chmod +x $(SCRIPT)
	bash -x ./$(SCRIPT)

# Clean
clean:
	rm -f *.log output.txt

.PHONY: all run deps dev clean

PYTHON = python3

.PHONY: help setup test run clean

.DEFAULT_GOAL = help

help:
	@echo "---------------------HELP--------------------"
	@echo "To setup the application type: make setup"
	@echo "To test the project type: make test"
	@echo "To run the project type: make run"
	@echo "---------------------------------------------"

setup:
	@echo "Setting up the Python Data Module..."
	@chmod +x setup.sh
	@echo "Verifying python3 is installed..."
	@./setup.sh

test:
	@echo "Running tests..."
	@chmod +x test/run_all_tests.sh
	@./test/run_all_tests.sh
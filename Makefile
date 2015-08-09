
# Color helpers
C_CYAN=\x1b[34;01m
C_RESET=\x1b[0m

# Group targets
all: deps lint jscs test
ci: lint jscs test

# Install dependencies
deps:
	@echo "$(C_CYAN)> installing dependencies$(C_RESET)"
	@npm install

# Lint JavaScript
lint:
	@echo "$(C_CYAN)> linting javascript$(C_RESET)"
	@./node_modules/.bin/jshint . ./bin/pa11y --config .jshintrc

# Run JavaScript Code Style
jscs:
	@echo "$(C_CYAN)> checking javascript code style$(C_RESET)"
	@./node_modules/.bin/jscs . ./bin/pa11y --config .jscsrc

# Run all tests
test: test-unit test-integration

# Run unit tests
test-unit:
	@echo "$(C_CYAN)> running unit tests$(C_RESET)"
	@./node_modules/.bin/mocha ./test/unit --reporter spec --recursive --timeout 200 --slow 50

# Run integration tests
test-integration:
	@echo "$(C_CYAN)> running integration tests$(C_RESET)"
	@./node_modules/.bin/mocha ./test/integration --reporter spec --recursive --timeout 5000 --slow 50

# Rebuild a local HTML CodeSniffer
build-htmlcs:
	@echo "$(C_CYAN)> building HTML CodeSniffer$(C_RESET)"
	@npm install git+ssh://git@github.com:squizlabs/HTML_CodeSniffer.git
	@npm install -g grunt-cli
	@cd ./node_modules/HTML_CodeSniffer && npm install --development
	@cd ./node_modules/HTML_CodeSniffer/Contrib/Grunt && grunt build
	@cat ./lib/vendor/HTMLCS-LICENSE > lib/vendor/HTMLCS.js
	@cat ./node_modules/HTML_CodeSniffer/build/HTMLCS.js >> lib/vendor/HTMLCS.js

.PHONY: test

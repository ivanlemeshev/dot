.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: unit-test
unit-test:
	@./tests/run_tests.sh test_log.bats test_print.bats test_prompt.bats

.PHONY: theme-test
theme-test:
	@bats tests/test_theme_schema.bats
	@bats tests/test_theme_generation.bats

.PHONY: lint
lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh
	@find bin -type f ! -name "*.ps1" -exec shellcheck {} +

.PHONY: build-sandbox
build-sandbox:
	@docker build -t ubuntu-sandbox -f Dockerfile .

.PHONY: run-sandbox
run-sandbox: build-sandbox
	@docker run --rm -it -v $(PWD):/home/sbx/dotfiles ubuntu-sandbox bash

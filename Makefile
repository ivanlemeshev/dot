.PHONY: test
test:
	@./tests/run_tests.sh

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

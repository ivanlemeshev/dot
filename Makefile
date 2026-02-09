.PHONY: test
test:
	@./tests/run_tests.sh

lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh
	@find bin -type f ! -name "*.ps1" -exec shellcheck {} +

.PHONY: build-ubuntu
build-sandbox:
	@docker build -t ubuntu-sandbox -f Dockerfile .

.PHONY: run-ubuntu
run-sandbox: build-sandbox
	@docker run --rm -it -v $(PWD):/home/sbx/dotfiles ubuntu-sandbox bash

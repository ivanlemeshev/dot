.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: lint
lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh setup-*.sh

.PHONY: build-ubuntu
build-sandbox:
	@docker build -t ubuntu-sandbox -f Dockerfile .

.PHONY: run-ubuntu
run-sandbox: build-sandbox
	@docker run --rm -it -v $(PWD):/home/sbx/dotfiles ubuntu-sandbox bash

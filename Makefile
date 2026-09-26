.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: unit-test
unit-test:
	@./tests/run_tests.sh test_log.bats test_print.bats test_prompt.bats

.PHONY: lint
lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh
	@find bin -type f ! -name "*.ps1" -exec shellcheck {} +
	@shellcheck tests/container/*.sh

.PHONY: container-install-test
container-install-test:
	@./tests/container/run.sh

.PHONY: container-install-shell
container-install-shell:
	@./tests/container/run.sh --interactive "$(PLATFORM)"

.PHONY: container-install-shell-ubuntu
container-install-shell-ubuntu:
	@./tests/container/run.sh --interactive "ubuntu"

.PHONY: container-install-shell-fedora-kde
container-install-shell-fedora-kde:
	@./tests/container/run.sh --interactive "fedora-kde"

.PHONY: build-sandbox
build-sandbox:
	@docker build -t ubuntu-sandbox -f Dockerfile .

.PHONY: run-sandbox
run-sandbox: build-sandbox
	@docker run --rm -it -v $(PWD):/home/sbx/dotfiles ubuntu-sandbox bash

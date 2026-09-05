.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: unit-test
unit-test:
	@./tests/run_tests.sh test_log.bats test_print.bats test_prompt.bats

.PHONY: vm-test
vm-test:
	@./tests/run_tests.sh test_v2_fedora_kde_vm_runner.bats

.PHONY: vm-test-plan
vm-test-plan:
	@./v2/vm/run-fedora-kde.sh --dry-run

.PHONY: vm-test-run
vm-test-run:
	@./v2/vm/run-fedora-kde.sh

.PHONY: vm-base-build
vm-base-build:
	@./v2/vm/run-fedora-kde.sh --base-build

.PHONY: vm-base-rebuild
vm-base-rebuild:
	@./v2/vm/run-fedora-kde.sh --base-rebuild

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

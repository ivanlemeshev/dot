.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: lint
lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh setup-*.sh

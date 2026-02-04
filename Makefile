.PHONY: test lint

test:
	@./tests/run_tests.sh

lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh setup-*.sh

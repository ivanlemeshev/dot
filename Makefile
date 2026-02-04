.PHONY: test
test:
	@./tests/run_tests.sh

.PHONY: lint
lint:
	@shellcheck lib/*.sh install/ubuntu/*.sh install/macos/*.sh setup-*.sh

.PHONY: build-ubuntu
build-ubuntu:
	docker build -t dotfiles-ubuntu:latest -f Dockerfile .

.PHONY: run-ubuntu
run-ubuntu: build-ubuntu
	docker run -it --rm \
		-v "$(shell pwd)":/home/test/dotfiles:ro \
		-w /home/test/dotfiles \
		dotfiles-ubuntu:latest bash

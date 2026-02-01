.PHONY: build-test-image
build-test-image:
	@./tests/dotfiles-test.sh

.PHONY: run-test-container
run-test-container: build-test-image
	@docker run -it --rm dotfiles-test

.PHONY: clean-test-artifacts
clean-test-artifacts:
	@docker rm -f dotfiles-test 2>/dev/null || true
	@docker rmi -f dotfiles-test 2>/dev/null || true

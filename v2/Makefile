.PHONY: build test shell clean

build:
	@./tests/dotfiles-test.sh

test: build
	@docker run --rm dotfiles-test ./tests/verify.sh

shell: build
	@docker run -it --rm dotfiles-test

clean:
	@docker rm -f dotfiles-test 2>/dev/null || true
	@docker rmi -f dotfiles-test 2>/dev/null || true

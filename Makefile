CHECK_WDIR=.

build:
	@cd pack && npm install
	@cd pack/phpactor && composer require --no-interaction
	@cd pack/make-lsp-vscode/server && npm install && npx tsc src/server.ts
	@cd pack/vscode/extensions/html-language-features/server && npm install && npm install typescript && npx tsc --downlevelIteration src/node/htmlServerMain.ts
check: docker_image build
	docker run --rm -it -v $(realpath pack)/:/home/ubuntu/.vim/pack/vIDE/ -v $(realpath $(CHECK_WDIR))/:/home/ubuntu/wdir -w /home/ubuntu/wdir vide/ubuntu
docker_image: Dockerfile vimrc
	docker build -t vide/ubuntu .
	@touch $@

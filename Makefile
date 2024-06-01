CHECK_WDIR=.

build:
	@cd pack && npm install
	@cd pack/phpactor && composer require --no-interaction
check: docker_image build
	docker run --rm -it -v $(realpath pack)/:/home/ubuntu/.vim/pack/vIDE/ -v $(realpath $(CHECK_WDIR))/:/home/ubuntu/wdir -w /home/ubuntu/wdir vide/ubuntu
docker_image: Dockerfile vimrc
	docker build -t vide/ubuntu .
	@touch $@

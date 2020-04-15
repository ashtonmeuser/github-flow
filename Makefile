export BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
export DATE?=$(shell date '+%Y%m%d%H%M')
export SHA?=$(shell git rev-parse --short=7 HEAD)

status:
	@echo "Date: $(DATE)\nBranch: $(BRANCH)\nHash:$(SHA)"

deploy:
	@git tag -fa dev -m "Deploying $(BRANCH):$(SHA) to dev env"

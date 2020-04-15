export BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
export DATE?=$(shell date '+%Y%m%d%H%M')
export SHA?=$(shell git rev-parse HEAD)

status:
	@echo "Date: $(DATE)\nBranch: $(BRANCH)\nHash: $(SHA)"

deploy-dev:
	@git tag -fa dev -m "Deploying $(BRANCH):$(SHA) to dev env" $(SHA)
	@git push --force origin refs/tags/dev:refs/tags/dev

promote-test:
	@git tag -fa test -m "Deploying $(BRANCH):$(SHA) to test env" $(SHA)
	@git push --force origin refs/tags/test:refs/tags/test

promote-prod:
	@git tag -fa prod -m "Deploying $(BRANCH):$(SHA) to prod env" $(SHA)
	@git push --force origin refs/tags/prod:refs/tags/prod

show-hashes:
	@git log --pretty=oneline

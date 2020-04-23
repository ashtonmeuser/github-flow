# = Recursive lazy set, := Immediate recursive set, :? Lazy set if absent
.DEFAULT_GOAL:=status
BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
DATE?=$(shell date '+%Y%m%d%H%M')
SHA?=$(shell git rev-parse --short HEAD)
VERSION?=$(shell git tag -l 'v*' --sort=v:refname | tail -n 1)
INCREMENT?='patch'
NEXT=$(shell ./increment-semver.sh $(VERSION) $(INCREMENT))

##########################################
# Deployment targets
##########################################

tag-dev:
	@git tag -fam "Deploying $(BRANCH):$(SHA) to dev env" dev $(SHA)^{}
	@git push --force origin refs/tags/dev:refs/tags/dev

tag-staging:
	@git tag -fam "Deploying $(BRANCH):$(SHA) to staging env" staging $(SHA)^{}
	@git push --force origin refs/tags/staging:refs/tags/staging

tag-prod:
	@git tag -fam "Deploying $(BRANCH):$(SHA) to prod env, increment level: $(INCREMENT)" prod $(SHA)^{}
	@git push --force origin refs/tags/prod:refs/tags/prod

##########################################
# Utility targets
##########################################

status:
	@echo "Date: $(DATE)\nBranch: $(BRANCH)\nHash: $(SHA)"

list-hashes:
	@git log --abbrev --oneline

list-tags:
	@git for-each-ref refs/tags --format='%(if)%(object)%(then)%(*objectname:short)%(else)%(objectname:short)%(end) %(refname:short)'

##########################################
# Build server targets
##########################################

push-image:
	@echo $(DOCKER_PASSWORD) | docker login --username $(DOCKER_USERNAME) --password-stdin
	@docker build -t github-flow:$(SHA) .
	@docker push github-flow:$(SHA)

tag-release:
	@git tag -fa dev -m "Deploying $(BRANCH):$(SHA) to dev env" $(SHA)^{}
	@git push --force origin refs/tags/dev:refs/tags/dev


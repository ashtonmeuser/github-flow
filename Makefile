# = Recursive lazy set, := Immediate recursive set, =? Lazy set if absent
.DEFAULT_GOAL:=status
BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
REF?=$(shell git rev-parse --short HEAD)
VERSION?=$(shell git tag -l 'v*' --sort=v:refname | tail -n 1)
INCREMENT?='patch'
NEXT=$(shell ./increment-semver.sh $(VERSION) $(INCREMENT))

##########################################
# Deployment targets
##########################################

tag-dev:
	@git tag -fam "Deploying $(BRANCH):$(REF) to dev env" dev $(REF)^{}
	@git push --force origin refs/tags/dev:refs/tags/dev

tag-prod:
	@git tag -fam "Deploying $(BRANCH):$(REF) to prod env, increment level: $(INCREMENT)" prod $(REF)^{}
	@git push --force origin refs/tags/prod:refs/tags/prod

##########################################
# Utility targets
##########################################

status:
	@echo "Branch: $(BRANCH)\nHash: $(REF)\nVersion: $(VERSION)\nNext: $(NEXT)"

list-hashes:
	@git log --abbrev --oneline

list-tags:
	@git for-each-ref refs/tags --format='%(if)%(object)%(then)%(*objectname:short)%(else)%(objectname:short)%(end) %(refname:short)'

##########################################
# Build server targets
##########################################

promote-image:
	@docker pull $(DOCKER_USERNAME)/github-flow:$(REF)
	@echo "Image exists, do a promotion!"

push-image:
	@echo $(DOCKER_PASSWORD) | docker login --username $(DOCKER_USERNAME) --password-stdin
	@docker build -t $(DOCKER_USERNAME)/github-flow:$(REF) .
	@docker push $(DOCKER_USERNAME)/github-flow:$(REF)

tag-release:
	@git tag -f $(NEXT) $(REF)^{}
	@git push --force origin refs/tags/$(NEXT):refs/tags/$(NEXT)


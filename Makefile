DOCKER_REVISION ?= puppetboard-testing-$(USER)
DOCKER_TAG = docker-push.ocf.berkeley.edu/puppetboard:$(DOCKER_REVISION)

# This is taken from ocfweb, the + 3 is so that it doesn't collide with other
# running services using this scheme like ocfweb, metabase, etc.
RANDOM_PORT := $(shell expr $$(( 8000 + (`id -u` % 1000) + 3 )))

# Increment this when new releases are made at
# https://github.com/voxpupuli/puppetboard/releases
PB_VERSION := v3.4.1

.PHONY: dev
dev: cook-image
	docker run --rm -p $(RANDOM_PORT):8080 \
		-v ${PWD}/keys:/opt/puppetboard/keys \
		-ti $(DOCKER_TAG)

.PHONY: cook-image
cook-image:
	docker build --build-arg PUPPETBOARD_VERSION=$(PB_VERSION) --pull \
		-t $(DOCKER_TAG) .

.PHONY: push-image
push-image:
	docker push $(DOCKER_TAG)

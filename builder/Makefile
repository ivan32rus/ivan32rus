#Simple Makefile to Build, Push the Docker apps.
.PHONY: build push

DOCKER = docker
NAME_MONITOR := prometheus-prog
NAME_UI := ui
NAME_CRAWLER := crawler
NAME_FLUENTD := fluentd
RELEASE_VERSION := 0.0.1
RELEASE_TAG_MONITOR := $(RELEASE_VERSION)
RELEASE_TAG_UI := $(RELEASE_VERSION)
RELEASE_TAG_CRAWLER := $(RELEASE_VERSION)
RELEASE_TAG_FLUENTD := ${RELEASE_VERSION}
DOCKER_MONITOR := ../monitoring/prometheus/
DOCKER_UI := ../prog/search_engine_ui/
DOCKER_CRAWLER := ../prog/search_engine_crawler/
DOCKER_FLUENTD := ../logging/fluentd/
USER_NAME = podstolniy
PASSWORD = ""

build: #Build docker image for prometheus, ui, crawler
	#${DOCKER} build -t ${USER_NAME}/${NAME_MONITOR}:${RELEASE_TAG_MONITOR} ${DOCKER_MONITOR}
	#${DOCKER} build -t ${USER_NAME}/${NAME_UI}:${RELEASE_TAG_UI} ${DOCKER_UI}
	#${DOCKER} build -t ${USER_NAME}/${NAME_CRAWLER}:${RELEASE_TAG_CRAWLER} ${DOCKER_CRAWLER}
	${DOCKER} build -t ${USER_NAME}/${NAME_FLUENTD}:${RELEASE_TAG_FLUENTD} ${DOCKER_FLUENTD}


push: #Push the Build image to DockeHUB.Make sure to login dockerHUB using 'docker login', before you push.
	#${DOCKER} push ${USER_NAME}/${NAME_MONITOR}:${RELEASE_TAG_MONITOR}
	#${DOCKER} push ${USER_NAME}/${NAME_UI}:${RELEASE_TAG_UI}
	#${DOCKER} push ${USER_NAME}/${NAME_CRAWLER}:${RELEASE_TAG_CRAWLER}
	${DOCKER} push ${USER_NAME}/${NAME_FLUENTD}:${RELEASE_TAG_FLUENTD}

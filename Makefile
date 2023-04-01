build:
	docker build --cache-from  joshhsoj1902/circleci-build-image:latest -t joshhsoj1902/circleci-build-image .

.PHONY: build
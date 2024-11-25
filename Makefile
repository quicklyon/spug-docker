export APP_NAME=spug
export TAG := $(shell cat VERSION)
export BUILD_DATE := $(shell date +'%Y%m%d')


help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 构建镜像
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--build-arg VERSION=$(TAG) \
	--pull --push \
	-t hub.zentao.net/app/spug:$(TAG)-$(BUILD_DATE) \
	-t easysoft/$(APP_NAME):$(TAG)-$(BUILD_DATE) \
	-t easysoft/$(APP_NAME):$(TAG) \
	-t easysoft/$(APP_NAME) \
	-f Dockerfile .

push: ## push 镜像
	docker push hub.zentao.net/app/spug:$(TAG)-$(BUILD_DATE)

push-public: ## push --> hub.docker.com
	docker tag hub.zentao.net/app/$(APP_NAME):$(TAG)-$(BUILD_DATE) easysoft/$(APP_NAME):$(TAG)-$(BUILD_DATE)
	docker tag easysoft/$(APP_NAME):$(TAG)-$(BUILD_DATE) easysoft/$(APP_NAME):latest
	docker push easysoft/$(APP_NAME):$(TAG)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):latest
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(TAG)-$(BUILD_DATE)

run: ## 运行
	export TAG=$(TAG)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

ps: ## 运行状态
	export TAG=$(TAG)-$(BUILD_DATE); docker-compose -f docker-compose.yml ps

stop: ## 停服务
	export TAG=$(TAG)-$(BUILD_DATE); docker compose -f docker-compose.yml down -v

restart: build clean ps ## 重构

clean: stop ## 停服务
	export TAG=$(TAG)-$(BUILD_DATE); docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	export TAG=$(TAG)-$(BUILD_DATE); docker-compose -f docker-compose.yml logs

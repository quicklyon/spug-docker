# Spug 容器镜像

## 一、关于Spug

[Spug](https://spug.cc/) 面向中小型企业设计的轻量级无 Agent 的自动化运维平台，整合了主机管理、主机批量执行、主机在线终端、文件在线上传下载、应用发布部署、在线任务计划、配置中心、监控、报警等一系列功能。

### 1.1 特性

- 批量执行: 主机命令在线批量执行
- 在线终端: 主机支持浏览器在线终端登录
- 文件管理: 主机文件在线上传下载
- 任务计划: 灵活的在线任务计划
- 发布部署: 支持自定义发布部署流程
- 配置中心: 支持 KV、文本、json 等格式的配置
- 监控中心: 支持站点、端口、进程、自定义等监控
- 报警中心: 支持短信、邮件、钉钉、微信等报警方式
- 优雅美观: 基于 Ant Design 的 UI 界面
- 开源免费: 前后端代码完全开源

官网：[spug.cc](https://spug.cc/)

## 二、支持的标签(Tag)

- [`3.2.1`](https://github.com/openspug/spug/releases/tag/v3.2.1) [`3.2.2`]((https://github.com/openspug/spug/releases/tag/v3.2.2)

## 三、获取镜像

推荐从 渠成镜像仓库 拉取我们构建好的Spug 应用镜像

```bash
docker pull hub.qucheng.com/app/spug:[TAG]
```

## 四、持久化数据

如果删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，应该为容器提供一个挂载卷，这样可以将数据进行持久化存储。

- /data
如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
    hub.qucheng.com/app/spug:3.2.2
```

## 五、环境变量

| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| EASYSOFT_DEBUG   | false         | 是否打开调试信息，默认关闭       |
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DB         | spug          | spug 数据库名称                 |
| MYSQL_USER       | root          | MySQL 用户名                      |
| MYSQL_PASSWORD   | pass4Spug     | MySQL 密码                        |
| REDIS_HOST       | 127.0.0.1     | Redis 服务地址 |
| REDIS_PORT       | 6379          | Redis 端口 |
| DEFAULT_ADMIN_USER| admin        | 默认管理员名称             |
| DEFAULT_ADMIN_PASSWORD | spug.dev | 默认管理员密码 |

## 六、运行

### 6.1 通过make命令运行

[Makefile](./Makefile)中详细的定义了可以使用的参数。

```bash
# 运行spug，包括mysql与redis
make run

# 关闭spug
make stop

# 清理容器与持久化数据
make clean

# 构建镜像
# 构建spug镜像
make build

```

说明

- [VERSION](./VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](./docker-compose.yml)

### 6.3 在 Kubernetes 中运行

我们通过 Helm 封装了Spug应用，供[渠成平台](https://www.qucheng.com)使用，包括Spug程序、MySQL服务和Redis服务，您可以直接通过Helm命令添加渠成的Helm仓库。

#### 6.3.1 前提条件

1. Kubernetes 1.19+ 最佳
2. Helm 3.2.0+
3. K8S集群需要提前配置默认的共享存储（分布式存储），通过`kubectl get sc` 查看

#### 6.3.2 安装命令

```bash
# 配置Helm仓库
helm repo add qucheng-market https://hub.qucheng.com/chartrepo/stable
helm repo update

# 为Spug服务创建独立namespace
kubectl create ns spug

# 启动Spug
helm upgrade -i spug qucheng-market/spug -n spug --set ingress.hostname=spug.local --set image.pullPolicy=Always

# 卸载服务
helm delete spug -n spug # 删除服务
kubectl delete pvc --all -n spug # 清理持久化存储
```

> **说明：**
>
> 1. ingress.hostname=< 设置内部可用域名 > 需要设置域名
> 2. 通过helm安装的Spug是当前最新版本，详情可通过 `helm search repo spug` 查看

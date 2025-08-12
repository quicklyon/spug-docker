DEBUG = False

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '{{MYSQL_DB}}',              # 替换为自己的数据库名，请预先创建好编码为utf8mb4的数据库
        'USER': '{{MYSQL_USER}}',            # 数据库用户名
        'PASSWORD': '{{MYSQL_PASSWORD}}',    # 数据库密码
        'HOST': '{{MYSQL_HOST}}',            # 数据库地址
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES',
        }
    }
}

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://:{{REDIS_PASSWORD}}@{{REDIS_HOST}}:{{REDIS_PORT}}/{{REDIS_CACHES_DB}}",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": ["redis://:{{REDIS_PASSWORD}}@{{REDIS_HOST}}:{{REDIS_PORT}}/{{REDIS_CHANNEL_DB}}"],
        },
    },
}

REPOS_DIR = '/data/repos'
BUILD_DIR = '/data/repos/build'

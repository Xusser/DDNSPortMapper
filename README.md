# DDNSPortMapper

根据DDNS定时检查并重启tinyportmapper

## 依赖

- dig

## 使用方法

```shell
./DDNSPortMapper.sh 监听端口 远端域名 远端端口
./DDNSPortMapper.sh 1234 baidu.com 4321
```

默认检查频率为5分钟
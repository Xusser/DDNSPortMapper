# DDNSPortMapper

根据DDNS定时检查并重启tinyportmapper

## 依赖

- dig
- Python3
- colorama(pip3 install colorama)
- [tinyportmapper](https://github.com/wangyu-/tinyPortMapper)

## 使用

```shell
./DDNSPortMapper 0.0.0.0:1234 www.baidu.com:80
```

默认检查频率为5分钟


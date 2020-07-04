---
title: week2|Shell Script
date: 2020/6/9
categories: 
- 学习笔记
- software construction
tags: [Shell, 脚本]
---

这节课主要介绍写shell script的方法, 通常只是一行命令无法满足我们对复杂逻辑操作的需求, 所以需要一些流程控制或者条件判断的语法. shell script第一行一般会写#!/bin/sh, 去让计算机知道这段代码不是machin code, 而是shell script. 在Bash中也可以吧sh替换成bash, python中替换成python. 这样就可以直接通过./来运行脚本了.
<!-- more -->
  
运行时可能发现我们被permission denied, 这个时候可以用ls -l看我们对这个文件的权限是什么, 然后再用chmod来为文件修改权限.

shell在某种程度上来说是typeless的. 输出的时候一般用echo.
![](./image/comp9044_2_1.png)

下面是一些variable的解释.
![](./image/comp9044_2_2.png)

shell的语法其实在[runoob](https://www.runoob.com/linux/linux-shell.html)
上有很好的总结, 我们使用的时候主要是要注意shell和一般的程序语言的区别. 比如不要随便用空格, 在用等号时我们会习惯性地写空格, 这在shell中就会造成错误. 
除了上面的$系列的command输入变量之外(也可以指已经定义的变量), shell也支持数组, 字符串等类和while, if等流程控制的语法, **echo**的作用和print类似, 打印字符串, 变量等内容. **expr**是计数器, 可以计算字符串长度, 或者做简单的加减乘除.

可以在shell script中通过$$查看process id, 命令行中用echo $$也可以.

下面补充一些命令

- shell command也可以直接进行网络请求, 比如curl和wget. curl有很多的features, 相对好用一点, man crul可以看到curl有很多的操作. 比如curl -O可以下载对应url的文件. 
- find可以打印directory tree. 
- xargs一般是和管道一起使用, 可以读取输入并格式化后出输出. 
- rsync是比rcp更加迅速而且灵活的文件复制命令, 在ssh中用的比较多. 
- test可以根据condition进行判断, 注意在写shell script的时候比较integer的符号和比较string的符号不同. 
- diff可以用来比较输入输出, 在学校写测试比较程序输出结果的时候比较有用. 
- date可以查看日期, 结合cut就可以提取具体信息.

# 一些问题
## 脚本互相调用的路径
在lab中我发现了一个有趣的问题, 如果在路径/lab/01的路径下运行
```
/lab/01/subdir/a.sh
```
其中a.sh用"./b.sh"调用了subdir下的b.sh, 脚本是找不到b.sh的, 因为"./"现在是在"/lab/01"的路径下, 那么在脚本中就需要用"$(dirname $0)", 也就是去获取当前文件的路径.

## ./
"./"是指明当前路径, 注意写脚本的时候也要注意用./来指明我们的某一行命令脚本的路径, 比如要运行父路径的脚本, 要用"./../test.sh".
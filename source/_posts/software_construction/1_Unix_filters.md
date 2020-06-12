---
title: week1|Unix filters
date: 2020/6/2
categories: 
- software construction
tags: [git, 脚本]
---

这节课的目的是扩展我们的software toolbox. 主要会讲一些写脚本的方法(shell, perl); 怎样测试软件; 介绍如git这样的software development tools. 简而言之就是讲解作为cs people的必备基础技能. 这节课的半期之后还是会比较忙(和其他课一样). 
<!-- more -->

unix是如下图这样跑的(据说学校是最早用unix的几所高校之一). 对于unix来说, **filter**代表的命令是读text from their standard input or specified files, 对这些text进行转换并把转换后的transformed text写到standard output中. 
![](/image/comp9044_1_1.png)

一些常用的命令和符号如下

- |: 管道符号, 用前者输出作为后者输入.
- wc: 统计lines, words, and bytes的数量(-w 显示单词数, -l 显示行数).
- head: 显示前面几行, 和pandas中的head差不多. 
- cat: 不做改变的将输入进行输出, 如果输入是一串文件名的, 则con**cat**enates他们到stdout. -vet查看隐藏的字符等
- egrep: 通过正则把符合要求的输入复制到输出中.
- tr: 转换或删除input中的字符并输出.
- cut: 对输入的lines进行选择并打印, 一般可以选择分隔符和分隔过后数据的第几块.
- uniq: 去重.
- sed: stream editor, 对文档的内容进行增删改查.

egrep规则参考: http://rexegg.com/regex-quickstart.html. 对于egrep一定要注意match的位置, 可能一句话对于一行正则表达式的前半部分match, egrep就提前返回了结果, 但是正则表达式还没有结束, 后半部分因为没有注意结束条件直接被忽略. 同时也要注意我们是否需要case-sensitive. 


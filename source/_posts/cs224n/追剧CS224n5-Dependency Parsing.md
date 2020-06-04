---
title: 追剧CS224n|5-Dependency Parsing
thumbnail: /image/cs224n5_thumbnail.jpg
date: 2020/3/29
categories: 
- CS224n
tags: [NLP, deep learning]
---

一般**linguistic structure**有两种, 一种是Constituency = phrase structure grammar = context-free grammars(CFGs), 把一句话的不同成分嵌套在一起, 这在语义学应用非常广泛. 而NLP中比较流行的是**Dependency Structure**, 把一句话的一个单词当做root(一般会添加一个fake ROOT), 根据单词的dependency关系来构建一个dependency tree. 为什么要分析sentence structure? 因为句子的结构和依存关系会影响系统对句子的理解, 在#NLP太难了#有很多例子, 比如"马里奥抱不起来耀西, 因为他太胖了", 这个"太胖了"指代的对象就不明确, 产生歧义. 也有分析语义关系的, 不是这节课的重点.
<!-- more -->

**Universal Dependencies treebanks**就是一大堆标注好的依存关系数据, 可以拿来训练. 并且我们可以根据tree bank知道到底什么依存关系是对的. 因为只用**dependency grammer**(直接找出句子依存的某种规则)的话是无法区分有歧义的句子的.

在**Dependency Parsing**的时候, 我们想要的是树结构(没有循环), 并且只有一个单词是ROOT的dependent. 这里注意dependency的箭头是可能相交的, 如下图的"on bootstrapping", 写英语的时候我们经常会后置这样的修饰, 把"on bootstrapping"放在了"tomorrow"的后面.
![](/image/cs224n5_1.png)

**Greedy transition-based parsing**, 通过Shift, Left-Arc, Right-Arc三种操作和栈结构来记录依存关系. 操作过程如下图. 想知道每一步什么进行哪个action是正确的就可以把它当做一个多分类的任务, 用discriminative classifier比如softmax解决, 课堂介绍了MaltParser, 他没有达到SOTA但是时间短而且效果不错. 
![](/image/cs224n5_2.png)
![](/image/cs224n5_3.png)

怎么知道Dependency Parser好不好呢? 一般是下面两种, UAS只看正确的箭头数量, LAS同时要求箭头和类别必须同时相同才能算正确的dependency.
![](/image/cs224n5_4.png)

接下来就想尝试**neural dependency parser**了, 因为找feature是非常麻烦的, 而且feature会比较sparse并且我们很难找到所有features, 那么用神经网络就比较intuitive了. Manning介绍了自己的工作, 它有较好的准确率并且速度很快. 输入是concat(词向量, POS向量和dependency labels向量), 其实本质上依然是一个多分类问题. 
![](/image/cs224n5_5.png)


## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week3. https://mp.weixin.qq.com/s/HoszQGHqwBVayvhjTgAihA

[3] 自然语言理解难在哪儿? https://zhuanlan.zhihu.com/p/96801863

[4] CS224N笔记(五):Dependency Parsing. https://zhuanlan.zhihu.com/p/66268929
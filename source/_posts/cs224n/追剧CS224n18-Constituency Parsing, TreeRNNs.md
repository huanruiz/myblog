---
title: 追剧CS224n|18-Constituency Parsing, TreeRNNs
thumbnail: /image/zhihu/cs224n18_thumbnail.jpg
date: 2020/4/11
categories: 
- CS224n
tags: [NLP, deep learning]
---

只有词向量似乎是不够的, 我们想要的是语义上去表达语言信息. 举个栗子: The snowboarder is leaping over a mogul; A person on a snowboard jumps into the air. 这里的"snowboarder"和"person on a snowboard"其实指的是一个意思. 而短语是由一个个小的elements组成的. 
<!-- more -->

那么语言是recursive的吗? 不一定, 但是这是一种描述语言的方式. 它没有明显的bound来限制递归.
![](/image/zhihu/cs224n18_1.png)

那么能不能在**Word Vector Space Models**基础上来构建呢, 那么就需要把phrase map到vector space上. 进一步的, **怎么把parse trees和compositional vector representations**结合在一起? 自然就想到了能否构建**Recursive neural networks**.
![](/image/zhihu/cs224n18_2.png)

简单来说, 就是不断地merge两个child node计算parent node向量, 去计算新的node是否合理. 根据分数从childnode构建parsing tree. Backpropagation的时候通常有三步: Sum derivatives of W from all nodes(like RNN); Split derivatives at each node(for tree); Add error messages(没个子节点的error等于自己的error加上父节点的error). **single matrix TreeRNN**就可以做到这一点, 但是它不适合复杂或者较长的句子, 并且输入的单词之间没有关联.
![](/image/zhihu/cs224n18_3.png)
![](/image/zhihu/cs224n18_4.png)

**Syntactically-Untied RNN**可以有效地解决这个问题, 可以看出weight W对不同的catagory是不同的(右图中的B, C), 这里的B, C可以是词性, 比如名字和形容词. 
![](/image/zhihu/cs224n18_5.png)

**Recursive Matrix-Vector Recursive Neural Networks**如下, 可以看到输入是由vector meaning和matrix mean组成的. 目的是为了保存更多的信息. 但是这也带来了问题: 参数太多使得计算非常复杂, 并且它也没有很好的表达phrase.
![](/image/zhihu/cs224n18_6.png)

**Recursive Neural Tensor Network**来了. 通过双向的attention来取出中间矩阵的分数, 而虚线部分就是一个cube(tensor), 这样就大大减少了参数量. 最后过一个softmax就可以做phrase的分类任务了. 我感觉这是一个很棒的办法.
![](/image/zhihu/cs224n18_7.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week10. https://mp.weixin.qq.com/s/1tKX6j5JTIYwTujIW1RrtA.
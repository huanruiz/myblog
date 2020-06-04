---
title: 追剧CS224n|14-Transformers and Self-Attention
thumbnail: /image/cs224n14_thumbnail.jpg
date: 2020/4/6
categories: 
- CS224n
tags: [NLP, deep learning]
---

用RNN时, 我们想解决的是序列问题, 但是正因为**sequential computation**, **parallelization**变得困难了. 并且RNN没有明显地去model长距离或者短距离的dependencies, 而我们需要的是hierarchy. 用CNN如果想model长距离的dependencies就需要很多的layer. 所以综上, encoder和decoder之间的attention非常重要.
<!-- more -->

那么考虑attention直接用来representation, 通过每个embedding的比较来得到特征. 对任意两个位置, 他们的path length是一个定值. 
![](/image/cs224n14_1.png)

transformer的整体结构如下(Seq2Seq). transformer的速度比RNN, CNN都快. 但是他依然有个问题, 在卷积的时候对不同位置采取了不同的linear transformation, 但是self-attention中对不同位置采取的是相同的变换, 所以它并不能针对不同的位置提取不同的信息, 那么就需要**multiheads**了. 同时注意, residual可以把**positional information**带到higher layers.
![](/image/cs224n14_2.png)

后面就是介绍了music generation不是重点直接跳过. 课上的介绍非常的笼统, 我觉得想要理解直接读paper[3]就好了.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week8. https://mp.weixin.qq.com/s/FBFL16QMp3Ob9VIp7pbBiA

[5] **Attention Is All You Need**. Aswani, Shazeer, Parmar, Uszkoreit,
Jones, Gomez, Kaiser, Polosukhin(2017). [paper](https://arxiv.org/pdf/1706.03762.pdf)
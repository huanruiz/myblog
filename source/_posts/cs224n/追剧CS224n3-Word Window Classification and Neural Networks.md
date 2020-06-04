---
title: 追剧CS224n|3-Word Window Classification and Neural Networks
thumbnail: /image/cs224n3_thumbnail.jpg
date: 2020/3/28
categories: 
- CS224n
tags: [NLP, deep learning]
---

这节课开头讲了讲逻辑回归, softmax, cross entropy(pytorch中会遇到NLL: Negative Log-Likelihood), *这些基础知识留到以后做一个完整的总结(文笔好一点再写).* (T ^ T) 

讲这些的目的是为了引出neural network. 传统机器学习比如逻辑回归, SVM学出来的通常是线性分类器, 而神经网络却可以学出来一个曲线来分隔不同的class, 更加强大. *也留到以后做总结.*
<!-- more -->

接下来就是回到NLP的**Named Entity Recognition(NER)**任务. 实际上这也还是一个分类问题, NER的困难之处在于一个短语或者单词在不同语境下可能代表不同的意思. 比如很多城市都有中山路, 而这里的"中山"指的就是地点却不是人名. 

怎么做NER问题, 自然还是联想到**Word-Window classification**, 通过一个词的context window来对这个单词的named entity进行分类. 以wondow length为2举例, 可以把这5个5维的向量拼起来得到一个window vector, 再像之前一样用softmax classifier来进行分类. 那么为什么不直接用window中的所有词向量的平均而是直接拼接呢, 因为取平均会丢失每个单词的位置信息. 举个栗子, "Museums in Paris are amazing.", 这句话中的in是推导出Museums是地点的线索, 如果取词向量的平均, 这种线索就丢失了.
![](/image/cs224n3_1.png)

进一步的, Window classification可以被应用在神经网络上. 目标是对window vector打分, 训练使得分数最大. 而中间的隐藏层学到的就是窗口中词向量non-linear interactions, 就像上一段提到的"Museums in"这样的信息. 
![](/image/cs224n3_2.png)

为了知道神经网络是怎么训练的, 接下来就介绍了微积分的一些知识. 本质上训练就是不断地微分加chain rule. 求$\frac{\partial s}{\partial b}$过程如下图. 而求$\frac{\partial s}{\partial W}$和对b求偏导中重复计算的部分就可以省略了.
![](/image/cs224n3_3.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week2. https://mp.weixin.qq.com/s/GsnhifWkd_lh88d3---4RQ
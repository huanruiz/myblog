---
title: 追剧CS224n|7-Vanishing Gradients, Fancy RNNs
thumbnail: /image/cs224n7_thumbnail.jpg
date: 2020/3/31
categories: 
- CS224n
tags: [NLP, deep learning]
---

在训练RNN的时候我们可能会遇到**vanishing gradient**的现象, 如下图, 方框中的微分如果比较小, 那反向传播时梯度就会越来越小. 为什么梯度消失是一个问题呢, 因为它使得更新模型weight的时候, 距离越近的loss影响越大, 距离较远的loss影响越小, 这不符合实际情况(dependency parsing的时候远距离单词可能反而是dependence word). 
<!-- more -->
![](/image/cs224n7_1.png)

梯度消失的出现有一个关键的原因就是训练信息不会被记录, 在训练的时候hidden state一直再被更新, 所以我们要做的就是防止这一点, 那么就要用到**LSTM**和**GRU**. 他们就是在基础的RNN上加了一些门来控制信息的流入流出(就可以选择遗忘哪些信息, 记住哪些信息). 不理解这一块知识的话可以看李宏毅老师的RNN课程再回头看定义, 会感到豁然开朗. 要注意GRU的参数比较少所以计算会比LSTM快. 下面给出LSTM, GRU各个gate的定义:
![](/image/cs224n7_2.png)
![](/image/cs224n7_3.png)

既然有vanishing gradient, 那么同样也会有**exploding gradient**. 如果梯度爆炸, 那么在更新parameters的时候每一步就会过大, 因为learning rate和gradient共同控制每一步的大小. 每一步过大和learning rate过大造成的问题类似. 比如模型很可能overshoot, 无法达到收敛值.
![](/image/cs224n7_4.png)

解决梯度爆炸可以用**Gradient clipping**, 简单的办法就是当梯度达到某个阈值的时候去scaling down这个梯度, 强制缩小梯度, 同时保证梯度的方向不改变.
![](/image/cs224n7_5.png)

当然vanishing/exploding gradient并不只是RNN的问题, 非线性的激活函数就会导致vanishing/exploding gradient的发生. 解决方法是增加更多网络直接连接不同层, 那么中间的层就被跳过了. 比如DenseNet就直接把每一层和后面所有出现的层都连接在一起, ResNet中的Residual connections跳过中间层直接与后面的层进行连接.

除了增加gate, 还可以把几个RNN stacked在一起(**Multi-layer RNNs**), 并且方向也可以是双向的(**Bidirectional RNNs**), 注意双向RNN不适用于上节课的language model, 因为LM只会包含左边的context, 而Bidirectional RNNs需要完整的sequence. 这都为后面的BERT做了铺垫.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week4. https://mp.weixin.qq.com/s/dPd-JEAhHqzVVVinxwUFxg
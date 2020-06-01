---
title: 追剧CS224n|6-Language Models and RNNs
thumbnail: /image/zhihu/cs224n6_thumbnail.jpg
date: 2020/3/30
categories: 
- CS224n
tags: [NLP, deep learning]
---

**Language Model**其实在IR的书中就提到过, 思想就是用前面出现的词推测后面出现的词. 写成概率的形式就是$P(x^{(t+1)}|x^{(t)},..., x^{(1)})$, 其中$x^{(1)}, x^{(2)},... x^{(t)}$就是sequence of words, $x^{(t+1)}$是词表中的任意一个词. 是不是像极了我们打字时的输入法的联想功能. 实际中我们会假设一个词只和前面出现的n个词有关(Markov assumption), 所以就有了**n-gram**语言模型这种说法. 概率的计算就是简单地看出现次数的比值, 如下图.
<!-- more -->
![](/image/zhihu/cs224n6_1.png)

我们也许会遇到**sparsity problems**, 也就是说有些sequence of words从来没在数据集中出现过, 那么这种词序列出现的概率为0, 所以一般我们需要smoothing. 比如Laplace smoothing默认就会给每种情况一个较小的概率, 同做分类问题时方法一样. 除此之外, 还有种办法叫**backoff**, 也就是把单词所condition的词序列长度减小, 那么这个序列就更可能出现了. 如果n-gram的n过大, sparsity problems会更加严重, 并且需要的存储空间也会大大增长, 所以一般n都小于5. 

为了解决这样的问题, 自然得我们也会想到用神经网络. 如果是window-based neural model, 就和第三讲的NER类似. 输入是词向量序列的拼接, 输出是softmax的预测词出现的概率, 不难发现这又成了一个分类问题. 这个方法就解决了sparsity problem, 并且模型就不用存储所有n-grams, 节约空间. 但是因为window的大小会影响模型的大小(Weight matrix变大), window依然没法变得过大. 而且对输入不同的词向量, 他们在计算时会被不同的weight处理, 比如下图的$x^{(1)}$, $x^{(2)}$. 但是实际上, 我们希望这样的词在被计算的时候应该是具有某些共同点的.
![](/image/zhihu/cs224n6_2.png)

既然我们解决的是一个序列的问题, 那么我们为什么不直接把神经网络也变成一个序列. 我们就需要用到**Recurrent Neural Networks (RNN)**了. 理解RNN其实非常简单, 它就是把一个个的神经网络拼在一起, 如果每一块网络叫一个cell, 那么每一个cell的输入是上一个cell的hidden layer输出和当前的词向量输入, 最后一个cell的输出就是这个序列的分类结果了. 这样我们的模型就可以支持任意长度的输入. 当然RNN也存在问题, 第一是它计算缓慢, 第二是序列变长了最早输入的词向量信息可能就会被遗忘. 需要注意一点: 这里的$W_{h}$都是相同的, 这就保证了序列变长但是模型不变大. 
![](/image/zhihu/cs224n6_3.png)

训练过程如下, 这里的loss是每一个cell的输出, 在timestep t的时候再计算预测的概率分布和真正的下一个单词的cross-entropy. 在这里反向传播时会用到**Multivariable Chain Rule**, 和之前前馈神经网络依然类似, 就是微分而已.
![](/image/zhihu/cs224n6_4.png)

那怎么**evaluating language model**呢, 标准的方法是用**perplexity**, 如下图. 其中取根号是为了normalize. 而可以看出perplexity其实就等于exponential of the cross-entropy loss. 下图中的corpus应该理解为测试集, 那么测试集上语言模型的概率乘积大, 这个模型当然就比较好了.
![](/image/zhihu/cs224n6_5.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week4. https://mp.weixin.qq.com/s/dPd-JEAhHqzVVVinxwUFxg
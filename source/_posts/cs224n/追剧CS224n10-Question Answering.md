---
title: 追剧CS224n|10-Question Answering
thumbnail: /image/zhihu/cs224n10_thumbnail.jpg
date: 2020/4/2
categories: 
- CS224n
tags: [NLP, deep learning]
---

**问答系统**, 顾名思义就是回答用户的问题. 主要有两种方式回答, 一种是返回一个可能包含问题答案的document, 一种是直接提取出答案. 我们主要讨论第二种方式. 下面是LCC QA system的结构. 可以看出是这是非常复杂的系统, 很多任务耦合在了一起.
<!-- more -->
![](/image/zhihu/cs224n10_1.png)

**SQuAD**就是**Stanford Question Answering Dataset**, 可以被用来衡量模型的好坏, 数据集的每个问题都有三个答案, 而衡量模型好坏的方式就是计算模型在这个数据集上的(macro)F1 score; 还有一种就是直接计算多少回答是正确的(accuracy), 这种方式不常用. **SQuAD2.0**和SQuAD1.0的区别是其中一些问题的答案可能在段落中找不到. 因为会有这样的现象: 模型总会给段落中的可能出现的答案打分选出最好的那个, 但是如果模型没有真正理解这段话, 那么即使问题没有答案, 模型依然会给出一个答案. 当然SQuAD也有一些限制, 比如他只有span-based answers等. 

**The Stanford Attentive Reader**是针对阅读理解, QA任务的模型. 首先为了理解问题, 模型用了BILSTM来提取问题的特征. 两层LSTM的最后一个state拼起来就是提取出的问题向量.
![](/image/zhihu/cs224n10_2.png)

得到了问题向量, 再求问题在段落上的attention, 来预测start token和end token. 
![](/image/zhihu/cs224n10_3.png)

**The Stanford Attentive Reader++**是升级版, 是一个end-to-end的模型. 在提取问题特征时, 不仅仅选择LSTM的最后的state, 而是计算state的weighted sum, 这里的attention score是额外计算的. 同时表达token时不仅仅使用词向量, 而是结合POS&NER tag, tf等.
![](/image/zhihu/cs224n10_4.png)

**BiDAF: Bi-Directional Attention Flow for Machine Comprehension**是更加复杂的模型, 也是经典的QA模型. 它的创新点在**Attention Flow**. 也就是说attention flow是双向的(context<->question).
![](/image/zhihu/cs224n10_5.png)

下面的similarity的计算的是question和context的单词相似度, 中括号中的向量进行拼接. C2Q的过程就是S通过softmax就可以得到一个概率分布, 这样知道question中的哪些词权重更高, 进而得到attention weighted vector $a_{i}$.
![](/image/zhihu/cs224n10_6.png)

而对于Q2C attention有一点不同, 这里的S取了一个max, 目的是取出最相关的的question word并做一个softmax, 最后相乘就可以得到一个新的经过权重处理的context vector. 最终BiDAF layer的输出就是$b_{i}$. **其实可以看出, 上面提到的模型主要变化就是在attention的处理和表达词汇的方式上.**
![](/image/zhihu/cs224n10_7.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week6. https://mp.weixin.qq.com/s/wsPLQV7FlWzAZ9YM_jKOZg
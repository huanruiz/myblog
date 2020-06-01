---
title: 读一读4|Attention-based Neural Machine Translation
thumbnail: /image/duyidu4_thumbnail.jpg
date: 2020/4/26
categories: 
- 读一读
tags: [NLP, 机器学习, 深度学习]
---

在Seq2Seq中([1]这篇论文主要讲Neural Machine Translation NMT), 如果是普通的RNN, decoder只能获取encoder最后输出的信息, 而我们的希望是decoder能学到encoder整个sequence上的信息. Seq2Seq结构如下.
<!-- more -->
![](/image/duyidu4_1.png)

现在正式的定义Seq2Seq问题, 如果输入是word sequence是$x_{1}, ...,x_{n}$, 输出是$y_{1}, ..., y_{m}$, 那么$\log p(y|x)=\sum^{m}_{j=1}\log p(y_{j}|y_{<j>}, \boldsymbol{s})$, $\boldsymbol{s}$指encoder一端的hidden state. 

通过attention使decoder直接学习encoder一端的输出信息, 通过这些信息完成翻译的任务. 本文分别介绍了global approach和local approach, 前者学习所有的source信息后者学习一部分source信息.

无论是global还是local, 目的都是让target直接学到source的信息, 那么如果target hidden state是$h_t$, source-side context vector是$c_t$, attentional hidden state就是$\tilde{h_t} = tanh(W_c[c_{t}; h_{t}])$. 通过$p(y_t|y_{<t},x)=softmax(W_{s}\tilde{h_t})$就可以得到概率分布. 接下来分别介绍global和local两种方法来计算$c_t$.

### Global Attention
![](/image/duyidu4_2.png)
为了得到$y_{t}$, 就需要context cector, 从图中可以看出context cector是通过$\bar{h_s}$和$a_{t}$得到的, $a_{t}$是由和$\bar{h_s}$和$h_{t}$得到的. 那么对每一个source word(**align function**): 

$a_{t}(s) \\= align(h_{t}, \bar{h_s}) \\= \frac{exp(score(h_{t}, \bar{h_s}))}{\sum_{s^{'}}exp(score(h_{t}, \bar{h_{s^{'}}}))}$

score这个函数在论文中给了三种:
![](/image/duyidu4_3.png)

也就是说模型会自动评估每个source word的权重. 最后的$c_{t}$就是一个对source hidden state的weighted average. 计算顺序就是: $a_{a}\rightarrow a_{t} \rightarrow c_{t}\rightarrow \tilde{h_{t}}$.

### Local Attention
![](/image/duyidu4_4.png)
上面提到的Global Attention问题就是计算量太大, 对长文本翻译不实用, 所以我们希望对每个target word翻译时只选取source word的一部分. 可以看到上图增加了$p_{t}$(aligned position), 而window就是$[p_{t}-D, p_{t}+D]$, 如果window包含了两个句子, 那么只考虑当前句子的部分.

在**Monotonic alignment(local-m)**中, alignment vector和之前一样, 只不过每一次在encoder仅选择窗口内单词, 窗口位置单调得对应decoder端.

而在**Predictive alignment(local-p)**中, 我们会先预测aligned position:

$p_t = S\cdot sigmoid(v_{p}^{T}tanh(W_{p}h_{t}))$

其中$W_p, v_p$是模型的参数, $S$是source的句子长度. 而align weight通过高斯分布来取得. 

$a_t(s) = align(h_t,\tilde{h_s})exp(-\frac{(s-p_t)^2}{2\sigma^2})$


## REFERENCES
[1] **Effective Approaches to Attention-based Neural Machine Translation**. MMinh-Thang Luong, Hieu Pham, Christopher D. Manning. [paper](https://www.aclweb.org/anthology/D15-1166/)
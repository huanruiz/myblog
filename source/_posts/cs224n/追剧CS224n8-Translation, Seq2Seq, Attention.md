---
title: 追剧CS224n|8-Translation, Seq2Seq, Attention
thumbnail: /image/zhihu/cs224n8_thumbnail.jpg
date: 2020/4/1
categories: 
- CS224n
tags: [NLP, deep learning]
---

从这节课开始就是要慢慢的一步一步引出BERT了~ **Machine Translation**可能是人们日常感触最深的NLP任务了. 在1990到2010年这段时间大多解决方案是**statistical machine translation**, 思想是从data中学习一个**probabilistic model**, 通过贝叶斯定理把问题拆分成**翻译模型**和**语言模型**. 如下图, 语言模型的目的是保证翻译过后的语句通顺. 
<!-- more -->
![](/image/zhihu/cs224n8_1.png)

现在分析P(x|y), 我们把它进一步分解成P(x, a|y), 其中这个a是**alignment**, 他代表了word-level的对应关系(从source sentence x 到 target sentence y). 不同的语言word-level的对应关系有很多, 一个词在中文是一个字, 在英文可能就是几个单词构成的词组. 简而言之就是**one-to-many**和**many-to-many**这两种对应关系. 

直接找所有合适的y再来比较概率是极其复杂的, 所以需要用到一些heuristics search algorithm并剪枝, 或者引入independence assumptions再使用DP的算法优化计算(Viterbi algorithm). 这个过程就叫做**decoding**. 其实可以看出这样的方法需要很多独立的subcomponents和繁重的特征工程, 会使得翻译任务极其复杂.

遇事不决, 神经网络. **sequence-to-sequence**这样的神经网络结构就来了. 它基于两个RNNs: Encoder RNN和Decoder RNN. 如下图, 输入放进Encoder RNN, 而Encoder RNN最后一个hidden layer的输出就作为Decoder RNN第一个hidden layer的输入, 在Decoder RNN的每个输出都通过softmax来学到单词的概率分布从而得到翻译过后的单词.
![](/image/zhihu/cs224n8_2.png)

Seq2Seq同时也是**Conditional Language Model**. Language Model是因为decoder在不断预测target sentence y的下一个单词. Conditional是因为预测的过程都基于source sentence x.
![](/image/zhihu/cs224n8_3.png)

课上讲了**greedy decoding**, 也就是在decoder每一步都取argmax, 但是这种方法就无法backtrack了, 它只能一直向前生成词汇. 所以我们需要想办法找一种搜索算法来避免greedy decoding, 去找最有可能出现的sequence而不是每一步最有可能出现的单词.
![](/image/zhihu/cs224n8_4.png)

**exhaustive search decoding**是最头铁的办法, 它需要找出所有可能的sequence y, 也就是说decoder的每一步都要计算所有可能的sequence, 那么复杂度就会跟随timestep的推进指数增长. 为了解决这个问题, 所以我们就需要**Beam search decoding**, 思想就是用log probability对出现的单词打分并记录分数最高的几个, 最后backtrack选出最优的sequence. 在greedy decoding中生成了\<END>就可以停止训练了, 但是在beem search中我们得定义一个阈值使训练停止, 比如达到某个timestep. 对于beam search, 序列越长, 得到的分数就越低, 所以对比不同长度的sequence需要用长度来normalize.
![](/image/zhihu/cs224n8_5.png)

怎么**evaluate Machine Translation**呢, 通常是用**BLEU(Bilingual Evaluation Understudy)**, 它比较了机器翻译和人工翻译的相似度, 这也是它的局限性所在, 因为可能机器翻译的好但是与人工翻译的区别较大. 

回过头看Seq2Seq的结构, 只有encoder最后一个hidden layer的输出作为decoder的输入, 这就是这个模型的瓶颈了. 我们有没有办法使模型的decoder得到encoder每一个cell的信息呢? 当然有! **attention**它来了, attention思想就是使decoder直接连接encoder, 这样decoder的每一个step就可以专注于encoder的某一部分.
![](/image/zhihu/cs224n8_6.png)
![](/image/zhihu/cs224n8_7.png)
![](/image/zhihu/cs224n8_8.png)
![](/image/zhihu/cs224n8_9.png)

当然attention不止针对Seq2Seq, 它的general definition是: "Given a set of vector values, and a vector query, attention is a technique to compute a weighted sum of the values, dependent on the query.". 也就是说计算哪一部分有更高的权重, 选择一个selective summary, query在NMT任务中就是decoder的hidden state, value就是encoder的hidden states. Attention也有很多变种, 在assignment4中都会学到.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week5. https://mp.weixin.qq.com/s/-55MoK2v48arJmHTZwc7tA
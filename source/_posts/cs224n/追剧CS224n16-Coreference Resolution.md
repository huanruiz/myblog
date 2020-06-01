---
title: 追剧CS224n|16-Coreference Resolution
thumbnail: /image/zhihu/cs224n16_thumbnail.jpg
date: 2020/4/8
categories: 
- CS224n
tags: [NLP, deep learning]
---

**Coreference Resolution**简单来说就是分析文字信息中**某个单词或者短语(mention)**是否指代了现实世界中的相同entitiy. Coreference Resolution一般有detect the mentions和cluster the mentions两步.
<!-- more -->

detect the mention对代词可以用POS来检测, 对Named entities可以用类似NER的方法来检测, 对Noun phrases则可以用parser在检测. 当然要注意, 有一些看似有指代关系的词语和短语可能并没有指代任何事物. 举个栗子: 当我们说"The best donut in the world", 这个best donut有指代关系吗? 当我们说"I am searching the best donut in the world."那么就没有, 但是我们说"Donut from Coles is the best donut in the world.", 那它就指代了Donut from Coles.

**Anaphora**这个概念用下图举例, 上半部分, Obama和Barack Obama都是指代现实世界的前美国总统; 而下半部分, he是引用了先行词Barack Obama, Barack Obama再指代现实世界的前美国总统, 这就是anaphora, 他们当然也是Coreference. **Cataphora**和Anaphora类似, 不过是后指关系.
![](/image/zhihu/cs224n16_1.png)

当然anaphora不一定证明两个mentions一定是coreference的, 比如"Every dancer twisted her knee.", 这个"her knee"和"Every dancer"构成了anaphora relationship, 但是"Every dancer"没有指代现实中的entity, 那么他们就无法构成coreference. 

**Hobbs’ naive algorithm**是用来寻找pronominal anaphora relationship的算法, 但是它是基于句子结构来分析的, 这也就是其局限性. 举个栗子,  我们有两句话: "She poured water from the pitcher into the cup until it was full."和"She poured water from the pitcher into the cup until it was empty”.", 两个句子唯一的区别就是最后一个单词, 但是前者的"it"指的是"the cup", 而后者的"it"指的是"the pitcher". 为了解决这种问题, 就基于semantic的方法了.

接下来介绍一个Coreference Models: **Mention Pair**. 对句子每一个mention pair做一个二分类来判断他们是否coreference. 最终我们可以得到pair的分数, 那么只要达到设定的阈值, 我们就认为他们是coreference. 问题也在这里, 因为我们是靠**transitive closure**得到的每一个coreference clusters, 那么只要一个点错误了那两个cluster就全部连在一起了. 解决方案就是对每个mention都只预测一个先行词.
![](/image/zhihu/cs224n16_2.png)

**Mention Ranking**就是采用了这样的思想, 通过softmax来得到分数最高的coreference link.
![](/image/zhihu/cs224n16_3.png)

所以目标是最大化下面的概率, 减少loss:
![](/image/zhihu/cs224n16_4.png)
![](/image/zhihu/cs224n16_5.png)

那么怎么计算probability呢. 一般就是Non-neural statistical classifier(选一些feature来machine learning), Simple neural network(同样用一些feature和各种embedding来train)和More advanced model using LSTMs, attention.

那么接下来就介绍我们最喜欢的End-to-End model来计算. 其中**span**包含了所有sub-sequence. $x_{START(i)}^{*}$和$x_{END(i)}^{*}$用来表示span的开始和结束.
![](/image/zhihu/cs224n16_6.png)

而$\hat{x_{i}}$就是所有span中词嵌入的attention-weighted之和.
![](/image/zhihu/cs224n16_7.png)

然后测量两个span是不是coreference的. 这种方法需要剪枝(决定哪些span更有可能是mention), 否则span会非常多, 使得计算量极大.
![](/image/zhihu/cs224n16_8.png)

最后介绍**Clustering-Based**的方法, 也就是不断地merge clusters, 最后得到的clusters就包含了coreference的mention. 而cluster-pair会比mention-pair简单, 因为判断的mention多, 信息量就多了. 如下图, 输入就是mention pairs而不是单独的mention.
![](/image/zhihu/cs224n16_9.png)

最后怎么evaluatecoreference呢? 方法如下, 计算precision和recall的平均.


## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week9. https://mp.weixin.qq.com/s/1tKX6j5JTIYwTujIW1RrtA
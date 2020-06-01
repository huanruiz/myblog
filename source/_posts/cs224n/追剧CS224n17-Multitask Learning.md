---
title: 追剧CS224n|17-Multitask Learning
thumbnail: /image/zhihu/cs224n17_thumbnail.jpg
date: 2020/4/10
categories: 
- CS224n
tags: [NLP, deep learning]
---

与**Multitask Learning**相对的就是**Single-task Learning**, Single-task Learning就是之前的一个model解决某个任务的模型. 而从CV pre-train model的预训练模型得到启发, NLP当然也可以用预训练模型. 那么我们想要的其实就是一个**unified multi-task model**, 想到了之前看的一篇sentiment analysis论文[3], 把情感分析用一个end-to-end模型训练出来, 最后的结果效果SOTA并且可解释性更好了. 首先我们吧NLP task总结成三种framework: 
<!-- more -->
![](/image/zhihu/cs224n17_1.png)

**The Natural Language Decathlon (decaNLP)**把10种NLP任务全部总结成了QA任务(Question Answering, Machine Translation, Summarization, Natural Language Inference, Sentiment Classification, Semantic Role Labeling, Relation Extraction , Dialogue, Semantic Parsing, Commonsense Reasoning). 模型需要自动的根据不同的NLP任务进行调整, 而且具体是哪个任务在数据集是不会明确指出的.
![](/image/zhihu/cs224n17_2.png)

**Multitask Question Answering Network (MQAN)**结构如下.
![](/image/zhihu/cs224n17_3.png)

训练的时候可能对其中较少的训练集overpower, 所以需要一些策略来进行训练, 比如Fully Joint和Anti-Curriculum Pre-training.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week9. https://mp.weixin.qq.com/s/1tKX6j5JTIYwTujIW1RrtA

[3] **Knowing What, How and Why: A Near Complete Solution for Aspect-based Sentiment Analysis**. Haiyun Peng, Lu Xu, Lidong Bing, Fei Huang, Wei Lu, Luo Si(2019). [https://arxiv.org/abs/1911.01616](paper)
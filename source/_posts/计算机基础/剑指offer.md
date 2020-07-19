---
title: 剑指offer题目总结
date: 2020/7/17
categories: 
- 计算机基础
tags: [数据结构与算法]
---

这是我的剑指offer题目小总结, 我准备的时间很紧张, 所以打算用分类的方法来复习数据结构与算法来提高效率. 这篇文章主要包含的是剑指offer第二版的题目(lc上面的). 
<!-- more -->

## 链表
### 06.从尾到头打印链表
1.栈辅助, 但是动态增加长度可能会消耗多余空间, 直接遍历得到长度并用固定长度数组也不失为一种好办法; 2.官方讲了递归的方法, 本质也是遍历.

> 不要再循环中用用stack.size(); 输出的是int[];

### 18.删除链表的节点
注意删除头指针的情况.

### 22.链表中倒数第k个节点
比较自然想到双指针, end先走k步, front和end在一起走, front和end距离保持为k.

### 24.反转链表
1.双指针, 用两个相邻指针遍历数组. 2.递归, 天然的用上一层来记录各个节点位置

```
public ListNode reverseList(ListNode head) {
    if (head == null || head.next == null) {
        return head;
    }
    ListNode node = reverseList(head.next);
    head.next.next = head; // 翻转两个node
    head.next = null; // 去除正向的指针
    return node;
}
```

> 输入为空, 输入只有head的情况要区分.

### 35.复杂链表的复制. 
做容易想到的就是用HashMap来存<原链表, 新链表>键值对再一一链接. 遍历时可以当做遍历一个图, 用dfs, bfs即可. 否则需要顺序遍历两次.
```
class Solution {

    HashMap<Node, Node> map = new HashMap<>();

    public Node copyRandomList(Node head) {
        return dfs(head);
    }

    private Node dfs(Node head) {
        if (head == null) {
            return head;
        }
        if (map.containsKey(head)) {
            return map.get(head);
        }

        Node node = new Node(head.val);
        map.put(head, node);
        node.next = dfs(head.next);
        node.random = dfs(head.random);
        return node;
    }
}
```

### 52.两个链表的第一个公共节点
1.我首先想到的就是遍历链表A再把node存起来, 再遍历链表B比较. 2.浪漫的做法是双指针, 遍历A+B两个链表的总步数一样, 如果有相同的小尾巴, 那么双指正一定会相遇, 主要节省了空间复杂度O(1).

## 树
### 07.重建二叉树(105)

### 26.
### 27.二叉树的镜像(226)
递归让左边等于右边的翻转, 右边等于左边的翻转, 直到该node为null.

### 28.对称的二叉树(101)
1.递归比较子树是否完全对称, ll==rr, lr==rl. 2.同queue模仿递归比较, 出队一个node, 入队子node并比较.

### 32 - I
32 - II
32 - III
34
54
37
55 - I
55 - II
68 - I
68 - II
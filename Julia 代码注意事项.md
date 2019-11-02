# Julia

## 与 Python 的区别

- 对数组、字符串等索引。Julia 索引的下标是从 1 开始，而不是从 0 开始
- 索引列表和数组的最后一个元素时，Julia 使用 `end` ，Python 使用 -1
- Julia 中的 Comprehensions （还）没有条件 if 语句
- for, if, while, 等块的结尾需要 `end` ；不强制要求缩进排版
- Julia 没有代码分行的语法：如果在一行的结尾，输入已经是个完整的表达式，就直接执行；否则就继续等待输入。强迫 Julia 的表达式分行的方法是用圆括号括起来
- Julia 总是以列为主序的（类似 Fortran ），而 `numpy` 数组默认是以行为主序的（类似 C ）。如果想优化遍历数组的性能，从 `numpy` 到 Julia 时应改变遍历的顺序。

> 更多教程：
>
> https://www.w3cschool.cn/julia/1fq81jfq.html
# 发布日志 #

## 2015.5.19 ##
- 内部实现tokenize选择表达式分析函数，提供更强大的选择器支持；
- 内部实现unique，对选择的重复元素去重；
- 增加选择器：后代选择；
- 增加相应的选择器函数：children、siblings、descendant、parent；
- 选择表达式增加对各种空格的支持；
- 修复ID中包含. _特殊字符的Bug；

## 2015.5.4 ##
- 发布Bolt XML和JQBolt Lua代码自动补全插件

## 2015.5.1 ##
- 基于Lua元表机制，实现对Bolt原生API的直接调用；
- 将init初始化函数隐藏为私有函数；

## 2015.4.29 ##
- 增加选择器："first"、"last"、"even"、"odd"、"gt()"、"lt()"、"eq()"、"hidden"、"visible";
- 增加相应的选择器函数：even、odd、gt、lt；
- 修复eq函数参数为负数时的Bug；
- 修改HelloBolt7，新增1~6数字UI对象，方便测试新选择器；

## 2015.4.20 ##
- 增加在Bolt控件内使用的支持；
- 修改HelloBolt7的Button控件，演示如何在控件内使用JQBolt；

## 2015.4.10 ##
- 位置函数增加支持表达式的对应接口：leftexp、rightexp、topexp、bottomexp、widthexp、heightexp；
- 修改postion函数，使用更为常用的 left、top、width、height 四个参数；
- 修改HelloBolt7示例，增加动态表达式的使用示例；
- 修改README.md，增加动态表达式的位置接口、动画接口说明；

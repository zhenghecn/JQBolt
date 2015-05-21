# 项目背景 #

JQBolt 是一款基于 迅雷Bolt界面引擎 的Lua框架，其设计借鉴了 Javascript 的 JQuery 框架 “Write Less,Do More”（写得更少,做得更多）的核心理念，在框架设计、API设计方面都参考了JQuery的思想。

# 项目介绍 #
- 名称：JQBolt
- 官网：https://github.com/zhenghecn/JQBolt/
- 开源协议：与Lua一样，使用MIT许可协议
- 功能：文档对象选择、链式调用、事件绑定的前后端分离、全局数据存取封装、位置快捷设置、动画效果
- 相关项目：[https://github.com/zhenghecn/JQBolt-EasyUI](https://github.com/zhenghecn/JQBolt-EasyUI)

# 快速入门 #
### 引用简单，不对原有代码产生影响 ###

在onload.lua文件中，引入其他Lua文件前加入一行代码即可引用JQBolt：
	
	XLLoadModule(root.."/JQBolt.lua")

### 文档对象选择 ###

目前支持以#ID开头的文档对象选择方式：
	
| 选择器 |   概述 |   示例  | 
|---------|--------|--------|
| # |   根据对象ID选择 |   jqbolt("#button", self)  | 
| > |   选择子对象 |   jqbolt("#button > *"，self)  | 
| 空格 |   选择后代对象 |   jqbolt("#button *"，self)  | 
| ~ |   选择兄弟对象 |   jqbolt("#button ~ *"，self)  | 
| Bolt对象类名 |   根据类型匹配对象 |   jqbolt("#button > LayoutObject"，self)  | 
| * |   匹配所有类型对象 |   jqbolt("#button > *"，self)  | 
| :even |   匹配所有索引值为偶数的元素 |   jqbolt("#button ~ LayoutObject:even"，self)  | 
| :odd |   匹配所有索引值为奇数的元素 |   jqbolt("#button ~ LayoutObject:odd"，self)  | 
| :gt |   匹配所有大于给定索引值的元素 |   jqbolt("#button ~ LayoutObject:gt(1)"，self)  | 
| :lt |   匹配所有小于给定索引值的元素 |   jqbolt("#button ~ LayoutObject:lt(5)"，self)  | 
| :eq |   匹配一个给定索引值的元素 |   jqbolt("#button ~ LayoutObject:eq(1)"，self)  | 
| :hidden |   匹配所有不可见元素 |   jqbolt("#button ~ LayoutObject:hidden"，self)  | 
| :visible |   匹配所有可见元素 |   jqbolt("#button ~ LayoutObject:visible"，self)  | 

### 链式调用 ###

无返回值API都支持链式调用，使得编写的代码更加简单并且性能更好：

    jqbolt("#button"，self).eq(1).data("key","value").size();

支持对Bolt原生API的直接、混合调用：

	jqbolt("#button > *", self).show().SetText(“hello”);
	local left,top,right,bottom = jqbolt("#button > *", self).GetObjPos();

### 事件绑定的前后端分离 ###

可以将所有Bolt界面XML资源中的事件绑定通过Lua代码方便实现，实现前后端分离，并且编写的代码结构性更强，支持LayoutObject的所有事件：

    jqbolt("#button"，self).ondragquery(function ( ... )
		do more
	end);

| JQBolt API | Bolt API |
|---------|--------|
| onabsposchange | OnAbsPosChange |
| onbind | OnBind |
| onchar | OnChar |
| oncontrolfocuschange | OnControlFocusChange |
| oncontrolmouseenter | OnControlMouseEnter |
| oncontrolmouseleave | OnControlMouseLeave |
| oncontrolmousewheel | OnControlMouseWheel |
| ondestroy | OnDestroy |
| ondragenter | OnDragEnter |
| ondragleave | OnDragLeave |	
| ondragover | OnDragOver |	
| ondragquery | OnDragQuery |
| ondrop | OnDrop |	
| onenablechange | OnEnableChange |
| onfocuschange | OnFocusChange |	
| onhittest | OnHitTest |	
| onhotkey | OnHotKey |	
| oninitcontrol | OnInitControl |	
| onkeydown | OnKeyDown |	
| onkeyup | OnKeyUp |	
| onlbuttondbclick | OnLButtonDbClick |	
| onlbuttondown | OnLButtonDown |	
| onlbuttonup | OnLButtonUp |	
| onmbuttondbclick | OnMButtonDbClick |	
| onmbuttondown | OnMButtonDown |	
| onmbuttonup | OnMButtonUp |
| onmouseenter | OnMouseEnter |
| onmousehover | OnMouseHover |
| onmouseleave | OnMouseLeave |
| onmousemove | OnMouseMove |
| onmousewheel | OnMouseWheel |
| onposchange | OnPosChange |
| onrbuttondbclick | OnRButtonDbClick |
| onrbuttondown | OnRButtonDown |
| onrbuttonup | OnRButtonUp |
| ontabbed | OnTabbed |
| onvisiblechange | OnVisibleChange |

### 全局数据存取封装 ###

再也不怕记不住XLGetGlobal、XLSetGlobal怎么拼写了，并且提供了语义更明确的删除操作：

    jqbolt().data("key","value")	--set
	jqbolt().data("key")			--get
	jqbolt().removedata("key")		--remove

### 位置快捷设置 ###

更快捷的对象位置设置，不必再自己计算对象的坐标，还支持相对位移操作：

    jqbolt("#button"，self).left(100);	--set
	jqbolt("#button"，self).left();		--get
	jqbolt("#button"，self).right();
	jqbolt("#button"，self).top();
	jqbolt("#button"，self).bottom();
	jqbolt("#button"，self).height();
	jqbolt("#button"，self).width();
	jqbolt("#button"，self).offset(10,-10);
	jqbolt("#button"，self).position(10,10,100,100);		--left,top,width,height

全部位置函数拥有对应的支持表达式的API：

	jqbolt("#button"，self).leftexp("father.width/2");	--set
	jqbolt("#button"，self).leftexp();					--get
	jqbolt("#button"，self).rightexp("width");
	jqbolt("#button"，self).topexp();
	jqbolt("#button"，self).bottomexp("father.height");
	jqbolt("#button"，self).heightexp("father.height/2");
	jqbolt("#button"，self).widthexp();
	jqbolt("#button"，self).positionexp();

如保持对象位置的动态性，应连续使用exp的位置函数，否则会破坏对象位置的动态性。

### 动画效果 ###

封装原有的动画API，操作更简单

	一行调用，实现全部动画
	jqbolt("#icon", self).alphachange(700, 255, 0).poschange(700, 45, 100, 45+60, 100+60, 45-30, 100-30, 45+60+30, 100+60+30);

| 动画 |   API函数 | 
|---------|--------|
| 位置移动 |   poschange( speed, startleft, starttop, startright, startbottom, endleft, endtop, endright, endbottom, func ) | 
| 透明度改变 |   alphachange( speed, startalpha, endalpha, func ) | 
| 角度动画 |   anglechange( speed, startrangeX, startrangeY, startrangeZ, endrangeX, endrangeY, endrangeZ, func ) | 
| mask动画 |   maskchange( speed, startX, startY, startWidth, startHeight, endX, endY, endWidth, endHeight, func ) | 
| 序列动画 |   seqframechange( speed, objImage, strResID, func ) | 
| 旋转动画 |   turnobjectchange( speed, objImage, func ) | 

# 项目目标 #

- 支持更强大的文档选择器
- 支持更快捷的对象动态操作
- 基于JQBolt，建立Bolt的基础控件集JQBolt EasyUI

# 交流 #
 
- 邮件交流：yulong@zhenghe.cn
- Bolt群：@于龙 @孙超 @郝林
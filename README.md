# 项目背景 #

JQBolt 是一款基于 迅雷Bolt界面引擎 的Lua框架，其设计借鉴了 Javascript 的 JQuery 框架 “Write Less,Do More”（写得更少,做得更多）的核心理念，在框架设计、API设计方面都参考了JQuery的思想。

# 项目介绍 #
- 名称：JQBolt
- 官网：https://github.com/zhenghecn/JQBolt/
- 开源协议：与Lua一样，使用MIT许可协议
- 功能：文档对象选择、链式调用、事件绑定的前后端分离、全局数据存取封装、位置快捷设置、动画效果

# 快速入门 #
### 引用简单，不对原有代码产生影响 ###

在onload.lua文件中，引入其他Lua文件前加入一行代码即可引用JQBolt：
	
	XLLoadModule(root.."/JQBolt.lua")

### 文档对象选择 ###

目前支持以#ID开头的文档对象选择方式：
	
<table width=”650″ border=”0″ cellspacing=”0″ cellpadding=”0″>
	<tr>
		<td>选择器</td>
		<td>概述</td>
		<td>示例</td>
	</tr＞
	<tr>
		<td>#</td>
		<td>根据对象ID选择</td>
		<td>jqbolt("#button", self)</td>
	</tr＞
	<tr>
		<td>></td>
		<td>选择子对象</td>
		<td>jqbolt("#button > *"，self)</td>
	</tr＞
	<tr>
		<td>空格</td>
		<td>选择后代对象</td>
		<td>jqbolt("#button *"，self)</td>
	</tr＞
	<tr>
		<td>~</td>
		<td>选择兄弟对象</td>
		<td>jqbolt("#button ~ LayoutObject"，self)</td>
	</tr＞
	<tr>
		<td>Bolt对象类名</td>
		<td>根据类型匹配对象</td>
		<td>jqbolt("#button > LayoutObject"，self)</td>
	</tr＞
	<tr>
		<td>*</td>
		<td>匹配所有类型对象</td>
		<td>jqbolt("#button > *"，self)</td>
	</tr＞
	<tr>
		<td>:even</td>
		<td>匹配所有索引值为偶数的元素</td>
		<td>jqbolt("#button ~ LayoutObject:even"，self)</td>
	</tr＞
	<tr>
		<td>:odd</td>
		<td>匹配所有索引值为奇数的元素</td>
		<td>jqbolt("#button ~ LayoutObject:odd"，self)</td>
	</tr＞
	<tr>
		<td>:gt</td>
		<td>匹配所有大于给定索引值的元素</td>
		<td>jqbolt("#button ~ LayoutObject:gt(1)"，self)</td>
	</tr＞
	<tr>
		<td>:lt</td>
		<td>匹配所有小于给定索引值的元素</td>
		<td>jqbolt("#button ~ LayoutObject:lt(5)"，self)</td>
	</tr＞
	<tr>
		<td>:eq</td>
		<td>匹配一个给定索引值的元素</td>
		<td>jqbolt("#button ~ LayoutObject:eq(1)"，self)</td>
	</tr＞
	<tr>
		<td>:hidden</td>
		<td>匹配所有不可见元素</td>
		<td>jqbolt("#button ~ LayoutObject:hidden"，self)</td>
	</tr＞
	<tr>
		<td>:visible</td>
		<td>匹配所有可见元素</td>
		<td>jqbolt("#button ~ LayoutObject:visible"，self)</td>
	</tr＞
</table>

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

<table width=”650″ border=”0″ cellspacing=”0″ cellpadding=”0″>
	<tr>
		<td>JQBolt API</td>
		<td>Bolt API</td>
	</tr＞
	<tr>
		<td>onabsposchange</td>
		<td>OnAbsPosChange</td>
	</tr＞
	<tr>
		<td>onbind</td>
		<td>OnBind</td>
	</tr＞
	<tr>
		<td>oncapturechange</td>
		<td>OnCaptureChange</td>
	</tr＞
	<tr>
		<td>onchar</td>
		<td>OnChar</td>
	</tr＞
	<tr>
		<td>oncontrolfocuschange</td>
		<td>OnControlFocusChange</td>
	</tr＞
	<tr>
		<td>oncontrolmouseenter</td>
		<td>OnControlMouseEnter</td>
	</tr＞
	<tr>
		<td>oncontrolmouseleave</td>
		<td>OnControlMouseLeave</td>
	</tr＞
	<tr>
		<td>oncontrolmousewheel</td>
		<td>OnControlMouseWheel</td>
	</tr＞
	<tr>
		<td>ondestroy</td>
		<td>OnDestroy</td>
	</tr＞
	<tr>
		<td>ondragenter</td>
		<td>OnDragEnter</td>
	</tr＞
	<tr>
		<td>ondragleave</td>
		<td>OnDragLeave</td>
	</tr＞	
	<tr>
		<td>ondragover</td>
		<td>OnDragOver</td>
	</tr＞	
	<tr>
		<td>ondragquery</td>
		<td>OnDragQuery</td>
	</tr＞
	<tr>
		<td>ondrop</td>
		<td>OnDrop</td>
	</tr＞	
	<tr>
		<td>onenablechange</td>
		<td>OnEnableChange</td>
	</tr＞
	<tr>
		<td>onfocuschange</td>
		<td>OnFocusChange</td>
	</tr＞	
	<tr>
		<td>onhittest</td>
		<td>OnHitTest</td>
	</tr＞	
	<tr>
		<td>onhotkey</td>
		<td>OnHotKey</td>
	</tr＞	
	<tr>
		<td>oninitcontrol</td>
		<td>OnInitControl</td>
	</tr＞	
	<tr>
		<td>onkeydown</td>
		<td>OnKeyDown</td>
	</tr＞	
	<tr>
		<td>onkeyup</td>
		<td>OnKeyUp</td>
	</tr＞	
	<tr>
		<td>onlbuttondbclick</td>
		<td>OnLButtonDbClick</td>
	</tr＞	
	<tr>
		<td>onlbuttondown</td>
		<td>OnLButtonDown</td>
	</tr＞	
	<tr>
		<td>onlbuttonup</td>
		<td>OnLButtonUp</td>
	</tr＞	
	<tr>
		<td>onmbuttondbclick</td>
		<td>OnMButtonDbClick</td>
	</tr＞	
	<tr>
		<td>onmbuttondown</td>
		<td>OnMButtonDown</td>
	</tr＞	
	<tr>
		<td>onmbuttonup</td>
		<td>OnMButtonUp</td>
	</tr＞
	<tr>
		<td>onmouseenter</td>
		<td>OnMouseEnter</td>
	</tr＞
	<tr>
		<td>onmousehover</td>
		<td>OnMouseHover</td>
	</tr＞
	<tr>
		<td>onmouseleave</td>
		<td>OnMouseLeave</td>
	</tr＞
	<tr>
		<td>onmousemove</td>
		<td>OnMouseMove</td>
	</tr＞
	<tr>
		<td>onmousewheel</td>
		<td>OnMouseWheel</td>
	</tr＞
	<tr>
		<td>onposchange</td>
		<td>OnPosChange</td>
	</tr＞
	<tr>
		<td>onrbuttondbclick</td>
		<td>OnRButtonDbClick</td>
	</tr＞
	<tr>
		<td>onrbuttondown</td>
		<td>OnRButtonDown</td>
	</tr＞
	<tr>
		<td>onrbuttonup</td>
		<td>OnRButtonUp</td>
	</tr＞
	<tr>
		<td>ontabbed</td>
		<td>OnTabbed</td>
	</tr＞
	<tr>
		<td>onvisiblechange</td>
		<td>OnVisibleChange</td>
	</tr＞
</table>

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

<table width=”650″ border=”0″ cellspacing=”0″ cellpadding=”0″>
	<tr>
		<td>动画</td>
		<td>API函数</td>
	</tr>
	<tr>
		<td>位置移动</td>
		<td>poschange( speed, startleft, starttop, startright, startbottom, endleft, endtop, endright, endbottom, func )</td>
	</tr＞
	<tr>
		<td>透明度改变</td>
		<td>alphachange( speed, startalpha, endalpha, func )</td>
	</tr＞
	<tr>
		<td>角度动画</td>
		<td>anglechange( speed, startrangeX, startrangeY, startrangeZ, endrangeX, endrangeY, endrangeZ, func )</td>
	</tr＞
	<tr>
		<td>mask动画</td>
		<td>maskchange( speed, startX, startY, startWidth, startHeight, endX, endY, endWidth, endHeight, func )</td>
	</tr＞
	<tr>
		<td>序列动画</td>
		<td>seqframechange( speed, objImage, strResID, func )</td>
	</tr＞
	<tr>
		<td>旋转动画</td>
		<td>turnobjectchange( speed, objImage, func )</td>
	</tr＞
</table>

# 项目目标 #

- 支持更强大的文档选择器
- 通过对事件的绑定封装，支持代码性能分析
- 通过使用JQBolt，实现Bolt的基础控件集

# 交流 #
 
- 邮件交流：yulong@zhenghe.cn
- Bolt群：@于龙 @孙超 @郝林
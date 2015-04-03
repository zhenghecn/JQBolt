--lua文件必须是UTF-8编码的(最好无BOM头)

function OnInitControl(self)

	jqbolt("#msg", self).onmousemove(MSG_OnMouseMove).onmouseleave(MSG_OnMouseLeave);
	jqbolt("#close.btn", self).onlbuttondown(close_btn_OnLButtonDown);
	jqbolt("#userdefine.btn", self).attachlistener("OnClick", userdefine_btn_OnClick);

	local objTree = self:GetOwner()
	
	--动态创建一个ImageObject,这个Object在XML里没定义
	local objFactory = XLGetObject("Xunlei.UIEngine.ObjectFactory");
	local newIcon = objFactory:CreateUIObject("icon2","ImageObject");
	self:AddChild(newIcon);
	local xarManager = XLGetObject("Xunlei.UIEngine.XARManager")
	newIcon:SetResProvider(xarManager);
	newIcon:SetResID("app.icon2");
	local function onClickIcon()
		XLMessageBox("Don't touch me!")
	end
	jqbolt("#icon2", self).position(45, 165, 45+70, 165+70).onlbuttondown(onClickIcon);
	-- newIcon:SetObjPos(45,165,45+70,165+70)
	-- newIcon:AttachListener("OnLButtonDown",true,onClickIcon)

	--创建一个自定义动画，作用在刚刚动态创建的ImageObject上
	local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
	myAni = aniFactory:CreateAnimation("HelloBolt.ani")
	--一直运行的动画就是一个TotalTime很长的动画
	myAni:SetTotalTime(9999999) 
	local aniAttr = myAni:GetAttribute()
	aniAttr.obj = newIcon;
	objTree:AddAnimation(myAni)
	myAni:Resume()

end

function MSG_OnMouseMove(self)
	self:SetTextFontResID("msg.font.bold");
	self:SetCursorID("IDC_HAND")
end

function MSG_OnMouseLeave(self)
	self:SetTextFontResID("msg.font");
	self:SetCursorID("IDC_ARROW");
end

function userdefine_btn_OnClick(self)
	local myClassFactory = XLGetObject("HelloBolt.MyClass.Factory")
	local myClass = myClassFactory:CreateInstance()
	myClass:AttachResultListener(function(result) XLMessageBox("result is "..result) end)
	myClass:Add(100, 200)
end

function close_btn_OnLButtonDown(self)

	jqbolt("#icon", self).alphachange(700, 255, 0).poschange(700, 45, 100, 45+60, 100+60, 45-30, 100-30, 45+60+30, 100+60+30);
	-- local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
	-- local owner = self:GetOwner();
	-- local icon = owner:GetUIObject("icon");
	-- local alphaAni = aniFactory:CreateAnimation("AlphaChangeAnimation")
	-- alphaAni:SetTotalTime(700)
	-- alphaAni:SetKeyFrameAlpha(255,0)
	-- alphaAni:BindRenderObj(icon) 
	-- owner:AddAnimation(alphaAni)
	-- alphaAni:Resume()

	-- local posAni = aniFactory:CreateAnimation("PosChangeAnimation")
	-- posAni:SetTotalTime(700)
	-- posAni:SetKeyFrameRect(45,100,45+60,100+60,45-30,100-30,45+60+30,100+60+30)
	-- posAni:BindLayoutObj(icon)
	-- owner:AddAnimation(posAni)
	-- posAni:Resume()

	local function onAniFinish()
		os.exit()
	end
	jqbolt("#msg", self).alphachange(700, 255, 0).poschange(800, 135, 100, 135+200, 100+50, 500, 100, 500+200, 100+50, onAniFinish);
	-- local alphaAni2 = aniFactory:CreateAnimation("AlphaChangeAnimation")
	-- alphaAni2:SetTotalTime(700)
	-- alphaAni2:SetKeyFrameAlpha(255,0)
	-- local msg = owner:GetUIObject("msg")
	-- alphaAni2:BindRenderObj(msg)
	-- owner:AddAnimation(alphaAni2)
	-- alphaAni2:Resume()

	-- local function onAniFinish(self,oldState,newState)
		-- if newState == 4 then
		-- ----os.exit 效果等同于windows的exit函数，不推荐实际应用中直接使用
			-- os.exit()
		-- end
	-- end
	-- local posAni2 = aniFactory:CreateAnimation("PosChangeAnimation")
	-- posAni2:SetTotalTime(800)
	-- posAni2:BindLayoutObj(msg)
	-- posAni2:SetKeyFramePos(135,100,500,100)
	-- --当动画结束后，应用程序才退出
	-- posAni2:AttachListener(true, onAniFinish)
	-- owner:AddAnimation(posAni2)
	-- posAni2:Resume()
end

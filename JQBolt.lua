-------------------------------------------------------------------------------------------
--		JQBolt
--		The Write Less,Do More

--		
-------------------------------------------------------------------------------------------


(function ()
	local _jqbolt = jqbolt;
	listener = {};

	jqbolt = function ( selector , context )

		local fn = { selector = selector, context = context };
		local self = { element = {}, findtable = {}, iscontrol = context:IsControl() };
		
		fn.init = function ( selector, context )		
			if type(selector) == "userdata" and selector["GetClass"] ~= nil then
				self.element[1] = selector;
				return fn;
			end

			if type(selector) == "string" then
				if nil ~= string.find(selector, "^#%w+$") then
					local elem = nil;
					if self.iscontrol then	
						elem = context:GetControlObject(string.sub(selector, 2));
					else
						elem = context:GetObject("tree:" .. string.sub(selector, 2));
					end
					if elem then
						self.element[1] = elem;
						return fn;
					end
				else
					return fn.find( selector, context );
				end
			end

			return fn;
		end

		self.findtable["#%w+"] = 
		function ( m, context)
			if fn.size() == 0 then
				local elem = nil;
				if self.iscontrol then	
					elem = context:GetControlObject(string.sub(m, 2));
				else
					elem = context:GetObject("tree:" .. string.sub(m, 2));
				end
				if elem then
					self.element[1] = elem;
				end
			else
				local elemtable = {};
				fn.each( 
					function ( elem )
						if elem:GetID() == string.sub(m, 2) then
							elemtable[#elemtable+1] = elem;
						end
					end
				);
				self.element = elemtable;
			end
		end 

		self.findtable["%w+"] = 
		function ( m, context)
			local elemtable = {};
			fn.each( 
				function ( elem )
					if elem:GetClass() == m then
						elemtable[#elemtable+1] = elem;
					end
				end
			);
			self.element = elemtable;
		end
		
		self.findtable[">"] = 
		function ( m, context)
			local elemtable = {};
			fn.each( 
				function ( elem )
					local count = elem:GetChildCount();
					for j = 0, count do
						elemtable[#elemtable+1] = elem:GetChildByIndex(j);
					end
				end
			);
			self.element = elemtable;
		end
		
		self.findtable["~"] = 
		function ( m, context)
			local elemtable = {};
			fn.each( 
				function ( elem )
					local parent = elem:GetParent();
					if parent ~= nil then
						local count = parent:GetChildCount();
						for j = 0, count do
							local siblings = parent:GetChildByIndex(j);
							if siblings ~= nil and siblings:GetHandle() ~= elem:GetHandle() then
								elemtable[#elemtable+1] = siblings;
							end
						end
					end
				end
			);
			self.element = elemtable;
		end
		
		self.findtable["%*"] = 
		function ( m, context)	
			
		end
		
		fn.find = function ( selector, context )
			for m in string.gmatch(selector, "[^%s]+") do
				for key, func in pairs(self.findtable) do
					if string.find(m, key) then
						func( m, context);
						break;
					end
				end
				
				if fn.size() == 0 then
					break;
				end
			end 

			return fn;
		end
		
		fn.size = function ()
			return #(self.element);
		end
		
		fn.get = function ( num )
			if num and type(num) == "number" then
				return self.element[num];
			end
		end
		
		fn.index = function ( elem )
			if nil == elem then
				return nil;
			end
			for i = 1, #(self.element) do
				local tempelem = self.element[i];
				if nil == tempelem then
					break;
				end
				if elem:GetHandle() == tempelem:GetHandle() then
					return i;
				end
			end
			
			return nil;
		end
		
		fn.eq = function ( index )
			if index > 0 then
				self.element = { self.element[index]};
			else
				index = fn.size() - index + 1; 
				self.element = { self.element[index]};
			end
			
			return fn;
		end
		
		fn.first = function () 
			self.element = { self.element[1]};
			
			return fn;
		end
		
		fn.last = function () 
			self.element = { self.element[fn.size()]};

			return fn;
		end
		
		fn.data = function ( key, value )
			if nil == key then
				return fn;
			end
			
			if nil ~= value then
				XLSetGlobal(key, value);
				return fn;
			else
				return XLGetGlobal(key);
			end
		end

		fn.removedata = function ( key )
			if nil == key then
				return fn;
			end

			rawset(_G, key, nil);
			return fn;
		end

		fn.each = function ( func )
			for i = 1, #(self.element) do
				if nil ~= self.element[i] then
					func(self.element[i]);
				end
			end
			
			return fn;
		end

		fn.setredirect = function ( eventname, redirectcmd )
			fn.each( 
				function ( elem )
					elem:SetRedirect(eventname, redirectcmd);
				end
			);
			
			return fn;
		end

		fn.attachlistener = function ( eventname, funcname, ispushback )
			if nil == eventname or nil == funcname then
				return fn;
			end
			if nil == ispushback then
				ispushback = true;
			end

			fn.each( 
				function ( elem )
					local cookieid, isexist = elem:AttachListener(eventname, ispushback, funcname);
					if true == isexist or nil ~= cookieid then
						if 	nil == listener[elem:GetHandle()] then
							local listenertab = {};
							listenertab[eventname] = cookieid;
							listener[elem:GetHandle()] = listenertab;
						else
							listenertab = listener[elem:GetHandle()];
							if nil ~= listenertab[eventname] then
								elem:RemoveListener(eventname, listenertab[eventname]);
								listenertab[eventname] = nil;
							end
							listenertab[eventname] = cookieid;
						end
					end
				end
			);

			return fn;
		end

		fn.removelistener = function ( eventname )
			if nil ~= eventname then
				fn.each( 
					function ( elem )
						if nil ~= elem:GetHandle() then
							local listenertab = listener[elem:GetHandle()];
							if nil ~= listenertab then
								local cookieid = listenertab[eventname];
								if nil ~= cookieid then
									elem:RemoveListener(eventname, cookieid);
								end
							end
						end
					end
				);
			end

			return fn;
		end

		fn.onabsposchange = function ( funcname, ispushback )
			return fn.attachlistener("OnAbsPosChange", funcname, ispushback);
		end

		fn.onbind = function ( funcname, ispushback )
			return fn.attachlistener("OnBind", funcname, ispushback);
		end

		fn.oncapturechange = function ( funcname, ispushback )
			return fn.attachlistener("OnCaptureChange", funcname, ispushback);
		end

		fn.onchar = function ( funcname, ispushback )
			return fn.attachlistener("OnChar", funcname, ispushback);
		end

		fn.oncontrolfocuschange = function ( funcname, ispushback )
			return fn.attachlistener("OnControlFocusChange", funcname, ispushback);
		end

		fn.oncontrolmouseenter = function (funcname, ispushback )
			return fn.attachlistener("OnControlMouseEnter", funcname, ispushback);
		end

		fn.oncontrolmouseleave = function (funcname, ispushback )
			return fn.attachlistener("OnControlMouseLeave", funcname, ispushback);
		end

		fn.oncontrolmousewheel = function (funcname, ispushback )
			return fn.attachlistener("OnControlMouseWheel", funcname, ispushback);
		end

		fn.ondestroy = function (funcname, ispushback )
			return fn.attachlistener("OnDestroy", funcname, ispushback);
		end

		fn.ondragenter = function (funcname, ispushback )
			return fn.attachlistener("OnDragEnter", funcname, ispushback);
		end

		fn.ondragleave = function (funcname, ispushback )
			return fn.attachlistener("OnDragLeave", funcname, ispushback);
		end

		fn.ondragover = function (funcname, ispushback )
			return fn.attachlistener("OnDragOver", funcname, ispushback);
		end

		fn.ondragquery = function (funcname, ispushback )
			return fn.attachlistener("OnDragQuery", funcname, ispushback);
		end

		fn.ondrop = function (funcname, ispushback )
			return fn.attachlistener("OnDrop", funcname, ispushback);
		end

		fn.onenablechange = function (funcname, ispushback )
			return fn.attachlistener("OnEnableChange", funcname, ispushback);
		end

		fn.onfocuschange = function (funcname, ispushback )
			return fn.attachlistener("OnFocusChange", funcname, ispushback);
		end

		fn.onhittest = function (funcname, ispushback )
			return fn.attachlistener("OnHitTest", funcname, ispushback);
		end

		fn.onhotkey = function (funcname, ispushback )
			return fn.attachlistener("OnHotKey", funcname, ispushback);
		end

		fn.oninitcontrol = function (funcname, ispushback )
			return fn.attachlistener("OnInitControl", funcname, ispushback);
		end

		fn.onkeydown = function (funcname, ispushback )
			return fn.attachlistener("OnKeyDown", funcname, ispushback);
		end

		fn.onkeyup = function (funcname, ispushback )
			return fn.attachlistener("OnKeyUp", funcname, ispushback);
		end

		fn.onlbuttondbclick = function (funcname, ispushback )
			return fn.attachlistener("OnLButtonDbClick", funcname, ispushback);
		end

		fn.onlbuttondown = function (funcname, ispushback )
			return fn.attachlistener("OnLButtonDown", funcname, ispushback);
		end

		fn.onlbuttonup = function (funcname, ispushback )
			return fn.attachlistener("OnLButtonUp", funcname, ispushback);
		end

		fn.onmbuttondbclick = function (funcname, ispushback )
			return fn.attachlistener("OnMButtonDbClick", funcname, ispushback);
		end

		fn.onmbuttondown = function (funcname, ispushback )
			return fn.attachlistener("OnMButtonDown", funcname, ispushback);
		end

		fn.onmbuttonup = function (funcname, ispushback )
			return fn.attachlistener("OnMButtonUp", funcname, ispushback);
		end

		fn.onmouseenter = function (funcname, ispushback )
			return fn.attachlistener("OnMouseEnter", funcname, ispushback);
		end

		fn.onmousehover = function (funcname, ispushback )
			return fn.attachlistener("OnMouseHover", funcname, ispushback);
		end

		fn.onmouseleave = function (funcname, ispushback )
			return fn.attachlistener("OnMouseLeave", funcname, ispushback);
		end
		
		fn.hover = function (hoverfunc, leavefunc)
			fn.onmousehover(hoverfunc);
			fn.onmouseleave(leavefunc);
			return fn;
		end

		fn.onmousemove = function (funcname, ispushback )
			return fn.attachlistener("OnMouseMove", funcname, ispushback);
		end

		fn.onmousewheel = function (funcname, ispushback )
			return fn.attachlistener("OnMouseWheel", funcname, ispushback);
		end

		fn.onposchange = function (funcname, ispushback )
			return fn.attachlistener("OnPosChange", funcname, ispushback);
		end

		fn.onrbuttondbclick = function (funcname, ispushback )
			return fn.attachlistener("OnRButtonDbClick", funcname, ispushback);
		end

		fn.onrbuttondown = function (funcname, ispushback )
			returnfn.attachlistener("OnRButtonDown", funcname, ispushback);
		end

		fn.onrbuttonup = function (funcname, ispushback )
			return fn.attachlistener("OnRButtonUp", funcname, ispushback);
		end

		fn.ontabbed = function (funcname, ispushback )
			return fn.attachlistener("OnTabbed", funcname, ispushback);
		end

		fn.onvisiblechange = function (funcname, ispushback )
			return fn.attachlistener("OnVisibleChange", funcname, ispushback);
		end

		fn.position = function (newleft, newtop, newwidth, newheight )
			local obj = self.element[1];
			if nil ~= obj then
				if nil == newleft or nil == newtop or nil == newwidth or nil == newheight then
					local oldleft, oldtop, oldright, oldbottom = obj:GetObjPos();
					return oldleft, oldtop, oldright - oldleft, oldbottom - oldtop;
				else
					obj:SetObjPos2(newleft, newtop, newwidth, newheight);
				end
			end

			return fn;
		end
		
		fn.positionexp = function (newleft, newtop, newwidth, newheight )
			local obj = self.element[1];
			if nil ~= obj then
				if nil == newleft or nil == newtop or nil == newwidth or nil == newheight then
					return obj:GetObjPosExp();
				else
					obj:SetObjPos2(newleft, newtop, newwidth, newheight);
				end
			end

			return fn;
		end
		
		fn.left = function ( left )
			if nil == left then
				local oldleft = fn.position();
				return oldleft;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(left, oldtop, oldright-oldleft, oldbottom-oldtop);
					end
				);	
			end

			return fn;
		end
		
		fn.leftexp = function ( left )
			if nil == left then
				local oldleft = fn.positionexp();
				return oldleft;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(left, oldtop, oldwidth, oldheight);
					end
				);	
			end

			return fn;
		end
		
		fn.top = function ( top )
			if nil == top then
				local oldleft, oldtop = fn.position();
				return oldtop;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(oldleft, top, oldright-oldleft, oldbottom-oldtop);
					end
				);	
			end
			
			return fn;
		end
		
		fn.topexp = function ( top )
			if nil == top then
				local oldleft, oldtop = fn.positionexp();
				return oldtop;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(oldleft, top, oldwidth, oldheight);
					end
				);	
			end
			
			return fn;
		end
		
		fn.right = function ( right )
			if nil == right then
				local oldleft, oldtop, oldright = fn.position();
				return oldright;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(right - (oldright-oldleft), oldtop, oldright-oldleft, oldbottom-oldtop);
					end
				);
			end
			
			return fn;
		end
		
		fn.rightexp = function ( right )
			if nil == right then
				local oldleft, oldtop, oldwidth = fn.positionexp();
				return "(" .. oldleft .. ") + (" .. oldwidth .. ")";
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(right .. "-(" .. oldwidth .. ")", oldtop, oldwidth, oldheight);
					end
				);
			end
			
			return fn;
		end
		
		fn.bottom = function ( bottom )
			if nil == bottom then
				local oldleft, oldtop, oldright, oldbottom = fn.position();
				return oldbottom;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(oldleft, bottom-(oldbottom-oldtop) , oldright-oldleft, oldbottom-oldtop);
					end
				);
			end
			
			return fn;
		end
		
		fn.bottomexp = function ( bottom )
			if nil == bottom then
				local oldleft, oldtop, oldwidth, oldheight = fn.positionexp();
				return "(" .. oldtop .. ") + (" .. oldheight .. ")";
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(oldleft, bottom .. "-(" .. oldheight .. ")" , oldwidth, oldheight);
					end
				);
			end
			
			return fn;
		end
		
		fn.width = function ( width )
			if nil == width then
				local oldleft, oldtop, oldright, oldbottom = fn.position();
				return oldright - oldleft;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(oldleft, oldtop, width, oldbottom-oldtop);
					end
				);
			end
			
			return fn;
		end
		
		fn.widthexp = function ( width )
			if nil == width then
				local oldleft, oldtop, oldwidth, oldheight = fn.positionexp();
				return oldwidth;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(oldleft, oldtop, width, oldheight);
					end
				);
			end
			
			return fn;
		end
		
		fn.height = function ( height )
			if nil == height then
				local oldleft, oldtop, oldright, oldbottom = fn.position();
				return oldbottom - oldtop;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldright, oldbottom = elem:GetObjPos();
						elem:SetObjPos2(oldleft, oldtop, oldright-oldleft, height);
					end
				);
			end
			
			return fn;
		end
		
		fn.heightexp = function ( height )
			if nil == height then
				local oldleft, oldtop, oldwidth, oldheight = fn.positionexp();
				return oldheight;
			else
				fn.each( 
					function ( elem )
						local oldleft, oldtop, oldwidth, oldheight = elem:GetObjPosExp();
						elem:SetObjPos2(oldleft, oldtop, oldwidth, height);
					end
				);
			end
			
			return fn;
		end
		
		fn.offset = function( ulx, uly )
			if nil == ulx or nil == uly then
				return fn;
			end

			fn.each(
				function ( elem )
					local uloldleft, uloldtop, uloldright, uloldbottom = elem:GetObjPos();
					elem:SetObjPos(uloldleft+ulx, uloldtop+uly, uloldright+ulx, uloldbottom+uly);
				end
			);
			
			return fn;
		end
		
		fn.hide = function( )
			fn.each(
				function ( elem )
					elem:SetVisible(false);
					elem:SetChildrenVisible(false);
				end
			);
			
			return fn;
		end
		
		fn.show = function( )
			fn.each(
				function ( elem )
					elem:SetVisible(true);
					elem:SetChildrenVisible(true);
				end
			);
			
			return fn;
		end

		fn.toggle = function( )
			fn.each(
				function ( elem )
					local isvisible = elem:GetVisible();
					if true == isvisible then
						fn.hide();
					else
						fn.show();
					end
				end
			);
			
			return fn;
		end

		fn.getspeed = function(speed)
			local ulspeed	= 400;
			if "string" == type(speed) then
				if "slow" == speed then
					ulspeed = 600;
				elseif "normal" == speed then
					ulspeed = 400;
				elseif "fast" == speed then
					ulspeed = 200;
				end
			elseif "number" == type(speed) then
				if speed > 0 then
					ulspeed = speed
				end
			end
			return ulspeed;
		end
		
		fn.poschange = function( speed, startleft, starttop, startright, startbottom, endleft, endtop, endright, endbottom, func)
			fn.each(
				function ( elem )
					local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory");
					if aniFactory then
						local posAni = aniFactory:CreateAnimation("PosChangeAnimation");
						if nil ~= posAni and nil ~= elem then
							posAni:BindObj(elem);
							local ulleft, ultop, ulright, ulbottom = elem:GetObjPos();
							if 	nil == startleft or nil == starttop or nil == startright or nil == startbottom or 
								nil == endleft   or nil == endtop   or nil == endright   or nil == endbottom   then
								startleft, starttop, startright, startbottom = ulleft, ultop, ulright, ultop;
								endleft,   endtop,   endright,   endbottom	 = ulleft, ultop, ulright, ulbottom;
							end
							posAni:SetKeyFrameRect(startleft, starttop, startright, startbottom, endleft, endtop, endright, endbottom);
							local ulspeed = fn.getspeed(speed);
							posAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							posAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(posAni);
							posAni:Resume();
						end
					end
				end
			);
			return fn;
		end

		fn.alphachange = function( speed, startalpha, endalpha, func)
			fn.each(
				function ( elem )
					local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory");
					if aniFactory then
						local alphaAni = aniFactory:CreateAnimation("AlphaChangeAnimation");
						if nil ~= alphaAni and nil ~= elem then
							alphaAni:BindObj(elem);
							if 	nil == startalpha or nil == endalpha then
								startalpha, endalpha = 0, 255;
							end
							alphaAni:SetKeyFrameAlpha(startalpha, endalpha);
							local ulspeed = fn.getspeed(speed);
							alphaAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							alphaAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(alphaAni);
							alphaAni:Resume();
						end
					end
				end
			);
			return fn;
		end
		
		fn.anglechange = function( speed, startrangeX, startrangeY, startrangeZ, endrangeX, endrangeY, endrangeZ, func)
			fn.each(
				function ( elem )
					local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
					if aniFactory then
						local angleAni = aniFactory:CreateAnimation("AngleChangeAnimation");
						if nil ~= angleAni and nil ~= elem then
							angleAni:BindObj(elem);
							local ulleft, ultop, ulright, ulbottom = elem:GetObjPos();
							if 	nil == startrangeX or nil == startrangeY or nil == startrangeZ or 
								nil == endrangeX   or nil == endrangeY   or nil == endrangeZ   then
								startrangeX, startrangeY, startrangeZ =  0,  -1,  0;
								endrangeX,   endrangeY,   endrangeZ	  =  0,  1,  0;
							end
							angleAni:SetKeyFrameRange(startrangeX, endrangeX, startrangeY, endrangeY, startrangeZ, endrangeZ);
							local ulspeed = fn.getspeed(speed);
							angleAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							angleAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(angleAni);
							angleAni:Resume();
						end
					end
				end
			);
			return fn;
		end

		fn.maskchange = function( speed, startX, startY, startWidth, startHeight, endX, endY, endWidth, endHeight, func)
			fn.each(
				function ( elem )
					local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
					if aniFactory then
						local maskAni = aniFactory:CreateAnimation("MaskChangeAnimation");
						if nil ~= maskAni and nil ~= elem then
							maskAni:BindObj(elem);
							local ulleft, ultop, ulright, ulbottom = elem:GetObjPos();
							if 	nil == startX or nil == startY or nil == startWidth or nil == startHeight or 
								nil == endX   or nil == endY   or nil == endWidth   or nil == endHeight   then
								startX, startY, startWidth, startHeight = ulleft, ultop, 0, 0;
								endX,   endY,   endWidth,   endHeight	= ulleft, ultop, ulright-ulleft, ulbottom-ultop;
							end
							maskAni:SetMaskKeyFrame(startX, startY, startWidth, startHeight, endX, endY, endWidth, endHeight);
							local ulspeed = fn.getspeed(speed);
							maskAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							maskAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(maskAni);
							maskAni:Resume();
						end
					end
				end
			);
			return fn;
		end
		
		fn.seqframechange = function( speed, objImage, strResID, func )
			fn.each(
				function ( elem )
					if objImage then
						local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
						if aniFactory then
							local seqAni = aniFactory:CreateAnimation("SeqFrameAnimation")
							seqAni:BindImageObj(objImage);
							if nil ~= strResID and "" ~= strResID then
								seqAni:SetResID(strResID);
							end
							local ulspeed = fn.getspeed(speed);
							seqAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							seqAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(seqAni);
							seqAni:Resume();
						end
					end
				end
			);
			return fn;
		end

		fn.turnobjectchange = function( speed, objImage, func)
			fn.each(
				function ( elem )
					if objImage then
						local aniFactory = XLGetObject("Xunlei.UIEngine.AnimationFactory")
						if aniFactory then
							local turnAni = aniFactory:CreateAnimation("TurnObjectAnimation");
							turnAni:BindObj(image, image);
							local ulspeed = fn.getspeed(speed);
							turnAni:SetTotalTime(ulspeed);
							local function onStateChange(self, oldState, newState)
								if 4 == newState and nil ~= func then
									func();
								end
							end
							turnAni:AttachListener(true, onStateChange);
							local objTree = elem:GetOwner();
							objTree:AddAnimation(turnAni);
							turnAni:Resume();
						end
					end
				end
			);
			return fn;
		end
		
		return fn.init( selector, context );
	end

	rawset(_G, "jqbolt", jqbolt);
end)();
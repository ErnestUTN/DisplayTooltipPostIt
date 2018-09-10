--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "ISUI/ISPanel"

ISToolTipInv = ISPanel:derive("ISToolTipInv");


--************************************************************************--
--** ISToolTipInv:initialise
--**
--************************************************************************--

function ISToolTipInv:initialise()
	ISPanel.initialise(self);
end

function ISToolTipInv:setItem(item)
	self.item = item;
end

function ISToolTipInv:onMouseDown(x, y)
	return false
end

function ISToolTipInv:onMouseUp(x, y)
	return false
end

function ISToolTipInv:onMouseDownOutside(x, y)
    if self.followMouse then
        self:setVisible(false)
    end
end

function ISToolTipInv:onRightMouseDown(x, y)
	return false
end

function ISToolTipInv:onRightMouseUp(x, y)
	return false
end

--************************************************************************--
--** ISToolTipInv:render
--**
--************************************************************************--

function ISToolTipInv:prerender()
	if self.owner and not self.owner:isReallyVisible() then
		self:removeFromUIManager()
		self:setVisible(false)
		return
	end
end

function ISToolTipInv:render()
	-- we render the tool tip for inventory item only if there's no context menu showed
	if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then

     local mx = getMouseX() + 24;
     local my = getMouseY() + 24;
     if not self.followMouse then
        mx = self:getX()
        my = self:getY()
        if self.anchorBottomLeft then
            mx = self.anchorBottomLeft.x
            my = self.anchorBottomLeft.y
        end
     end

        self.tooltip:setX(mx+11);
        self.tooltip:setY(my);

        self.tooltip:setWidth(50)
        self.tooltip:setMeasureOnly(true)
        self.item:DoTooltip(self.tooltip);
        self.tooltip:setMeasureOnly(false)

     -- clampy x, y

     local myCore = getCore();
     local maxX = myCore:getScreenWidth();
     local maxY = myCore:getScreenHeight();
	 
	local lh = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight(); -- height of one line
     local tw = self.tooltip:getWidth();
     local th = self.tooltip:getHeight();
     
	 --Mi codigo aqui-- ERNESTO TOOLTIP
	 --debugging sheet of paper (to be removed later) 
	 
	if self.item:getType() == "HCPostit" or self.item:getType() == "SheetPaper2" then
		
		local items_count = math.floor((self.tooltip:getHeight() / lh) - 1); -- calculate number of actual items in tooltip.
		local label_pos = lh * 1.5 + (lh * (items_count));
		
		
		if  self.item:seePage(1) ~= nil then
		
			local label=self.item:seePage(1);
			self.tooltip:DrawText(label, 5, label_pos, 1, 1, 0.8, 1);
			tw = tw + 60;
			th= th+30;
		end
	end
	 
	 
     self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
    if not self.followMouse and self.anchorBottomLeft then
        self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
    else
        self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
    end

     self:setX(self.tooltip:getX() - 11);
     self:setY(self.tooltip:getY());
     self:setWidth(tw + 11);
     self:setHeight(th);

     self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
     self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
     self.item:DoTooltip(self.tooltip);
	end
end

function ISToolTipInv:setOwner(ui)
	self.owner = ui
end

function ISToolTipInv:setCharacter(chr)
	self.tooltip:setCharacter(chr)
end

--************************************************************************--
--** ISToolTipInv:new
--**
--************************************************************************--
function ISToolTipInv:new(item)
   local o = {}
   o = ISPanel:new(0, 0, 0, 0);
   setmetatable(o, self)
   self.__index = self
   o.tooltip = ObjectTooltip.new();
   o.item = item;

   o.tooltip:setX(0);
   o.tooltip:setY(0);

   o.x = 0;
   o.y = 0;

   o.toolTipDone = false;

   o.backgroundColor = {r=0, g=0, b=0, a=0.5};
   o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
   o.width = 0;
   o.height = 0;
   o.anchorLeft = false;
   o.anchorRight = false;
   o.anchorTop = false;
   o.anchorBottom = false;

   o.owner = nil
   o.followMouse = true
   o.anchorBottomLeft = nil
   return o;
end

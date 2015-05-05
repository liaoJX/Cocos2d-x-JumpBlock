local StickManager = class("StickManager")

local stickList = {}
local root = nil
local size = nil
local isMoveOver = nil  --用于屏蔽快速点击

local GameConfig = require("app.GameConfig")

local INIT_STICK_COUNT = GameConfig.INIT_STICK_COUNT
local SPACE = GameConfig.STICK_SPACE

local IMG_STICK_PATH = "t1.png"

function StickManager:initStickView(rootView)
    root = rootView
    size = root:getContentSize()
    isMoveOver = nil
    stickList = {}
    
    for i=1,INIT_STICK_COUNT do
       local stick = cc.Sprite:create(IMG_STICK_PATH)
       stick:setPosition(size.width/2,size.height-(SPACE*(i+1)))
       stick:setAnchorPoint(0.5,0)
	   stick:addTo(root)
	   self:pushStickList(stick)
	end
end

function StickManager:move()    
    if not isMoveOver then
        isMoveOver = table.maxn(stickList)
    end
    
    if isMoveOver ~= table.maxn(stickList) then
        return false
    end
    
    isMoveOver = 0
    
    for i,v in pairs(stickList) do
        if v:getPositionY() > size.height then
            self:popStickList(i)
            self:addStick()
        end
    end
    
    for i,v in pairs(stickList) do
        local move =  cc.MoveTo:create(0.2,cc.p(v:getPositionX(),v:getPositionY()+SPACE))
        local seq = cc.Sequence:create(move,cc.CallFunc:create(function()
            isMoveOver = isMoveOver + 1
        end))
        v:runAction(seq)
    end
    return true
end

function StickManager:addStick()
    local n = table.maxn(stickList)
    local stick = cc.Sprite:create(IMG_STICK_PATH)
    stick:setPosition(size.width/2,stickList[n]:getPositionY()-SPACE)
    stick:setAnchorPoint(0.5,0)
    stick:addTo(root)
    self:pushStickList(stick)
    
    require("app.logic.EnemyManager"):init(stick)
end

function StickManager:pushStickList(st)
	table.insert(stickList,st)
end

function StickManager:popStickList(n)
	local stick = table.remove(stickList,n)
    root:removeChild(stick)
end

function StickManager:getStickList()
	return stickList
end

return StickManager
local Block = class("Block")

local root = nil
local sp = nil
local isJumpOver = nil

local GameConfig = require("app.GameConfig")
local GameManager = require("app.logic.GameManager")

function Block:getSprite()
	return sp
end

function Block:create(rootView)
    root = rootView
    isJumpOver = true
    
    sp = cc.Sprite:create("block.png")
    sp:setPosition(GameConfig.BLOCK_INIT_POSITION_X,GameConfig.BLOCK_INIT_POSITION_Y)
    sp:addTo(root,10)
    
    local body = cc.PhysicsBody:createBox(sp:getContentSize())
    body:setGravityEnable(false)
    body:setContactTestBitmask(0x01)
    sp:setPhysicsBody(body)
    
    local moveToRight  = cc.MoveBy:create(2.0,cc.p(618,0))
    local moveToLeft  = cc.MoveBy:create(2.0,cc.p(-618,0))
    local seq = cc.Sequence:create(moveToRight,moveToLeft)
    local rep = cc.RepeatForever:create(seq)
    sp:runAction(rep)
    
    local function onContactBegin()
    	GameManager:setGameState(GameManager.GAME_STATE_LOSE)
    end
    
    local contactListener = cc.EventListenerPhysicsContact:create();
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN);
    local eventDispatcher = root:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, root)
    
    return self
end

function Block:jump()
	if isJumpOver and sp then
        print("jump2")
	    isJumpOver = false
        local jump = cc.JumpBy:create(GameConfig.BLOCL_JUMP_TIME,cc.p(0,0),GameConfig.BLOCK_JUMP_HEIGHT,1)
        local seq = cc.Sequence:create(jump,cc.CallFunc:create(function()
            isJumpOver = true
        end))
        sp:runAction(seq)
    else
        print("not jump")
	end 
end

return Block
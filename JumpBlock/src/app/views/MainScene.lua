local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

local size = cc.Director:getInstance():getWinSize()

local bgSprite = nil
local Block = nil

local score = 0
local scoreLabel = nil

local firstPosition = nil
local root = nil

local GameManager = require("app.logic.GameManager")
local stickManager = require("app.logic.StickManager")

local function GameOverEvent()
    transition.stopTarget(Block:getSprite())
    local rote = cc.RotateBy:create(1.0, 360)
    local req_1 = cc.RepeatForever:create(rote)
    Block:getSprite():runAction(req_1)
    
    local loseLayer= cc.CSLoader:createNode("GameOverLayer.csb")
    loseLayer:setAnchorPoint(0.5,0.5)
    loseLayer:setPosition(size.width/2,size.height/2+80)
    loseLayer:addTo(root)
    
    local restartBtn = loseLayer:getChildByName("Button_Restart")
     
    local fin = cc.FadeIn:create(0.5)
    local delay = cc.DelayTime:create(2.0)
    local fout = cc.FadeOut:create(0.5)
    local seq = cc.Sequence:create(fin,delay,fout)
    local req = cc.RepeatForever:create(seq)
    
    restartBtn:runAction(req)
    
    local function onStart()
        require("app.MyApp"):create():run()
    end
    
    restartBtn:addClickEventListener(onStart)
end

function MainScene:initGameView()
    bgSprite = cc.Sprite:create("bg.png")
    bgSprite:setPosition(size.width/2,size.height/2)
    bgSprite:addTo(self)
    
    Block = require("app.Block"):create(self)
    
    stickManager:initStickView(bgSprite)
    
    local scoreBg = cc.Sprite:create("score.png")
    scoreBg:setPosition(120,size.height-50)
    self:addChild(scoreBg)
    
    scoreLabel = cc.Label:createWithSystemFont(score,"",48)
    scoreLabel:setPosition(scoreBg:getContentSize().width/2,scoreBg:getContentSize().height/2)
    scoreBg:addChild(scoreLabel)
    
    GameManager:setOnGameOverCallBack(GameOverEvent)
    GameManager:setGameState(GameManager.GAME_STATE_PLAY)
end


local function onTouchBegan(touch, event)
    if GameManager:getGameState() == GameManager.GAME_STATE_PLAY then
	   firstPosition = touch:getLocation()
	end
	return true
end

local function onTouchEnd(touch,event)
    if GameManager:getGameState() == GameManager.GAME_STATE_PLAY then
        local endPosition = touch:getLocation()
        if  endPosition.y - firstPosition.y > 50 then
            print("jump1")
            Block:jump()
        else
            local result = stickManager:move()
            if result then
                score = score + 1
                scoreLabel:setString(score)
            end
        end
    end
end

function MainScene:onCreate()
    root = self
    
    score = 0
    GameManager:init()
    GameManager:setGameState(GameManager.GAME_STATE_PLAY)
    
    local edgeBody = cc.PhysicsBody:createEdgeBox( size, cc.PhysicsMaterial(1,0,0),3)
    local edgeNode = cc.Node:create()
    edgeNode:setPosition( size.width /2 , size.height /2 )
    edgeNode:setPhysicsBody( edgeBody)
    self:addChild( edgeNode)
    
    self:initGameView()
    
    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )
    listenner:registerScriptHandler(onTouchEnd, cc.Handler.EVENT_TOUCH_ENDED )
    
    local eventDispatcher = self:getEventDispatcher()  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)
    
    local exitButton = cc.CSLoader:createNode("ButtonExit.csb")
    exitButton:setPosition(size.width-80,size.height-60)
    self:addChild(exitButton,10)
    
    local function onExit()
        cc.Director:getInstance():endToLua()
    end

    exitButton:getChildByName("Button_Exit"):addClickEventListener(onExit)
end

return MainScene

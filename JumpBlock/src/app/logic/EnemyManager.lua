local EnemyManager = class("EnemyManager")

local root = nil

function EnemyManager:init(rootView)
    root = rootView
    
    math.randomseed(os.time())
    local ran = math.random(1,100)
    
    local enemy = cc.Sprite:create("enemy1.png")
    local speed = (os.time()%2)+2
    local moveToRight  = cc.MoveTo:create(speed,cc.p(618,64))
    local moveToLeft  = cc.MoveTo:create(speed,cc.p(32,64))

    local body = cc.PhysicsBody:createBox(enemy:getContentSize())
    body:setGravityEnable(false)
--    body:setDynamic(false)
    body:setContactTestBitmask(0x01)
    enemy:setPhysicsBody(body)
    enemy:addTo(root)
    
    if ran < 50 then
        enemy:setPosition(32,64)
        
        local seq = cc.Sequence:create(moveToRight,moveToLeft)
        local rep = cc.RepeatForever:create(seq)
        enemy:runAction(rep)
    else
        enemy:setPosition(618,64)

        local seq = cc.Sequence:create(moveToLeft,moveToRight)
        local rep = cc.RepeatForever:create(seq)
        enemy:runAction(rep)
    end
end



return EnemyManager 
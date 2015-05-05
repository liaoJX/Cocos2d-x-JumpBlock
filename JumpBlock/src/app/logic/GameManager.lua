local GameManager = class("GameManager")

GameManager.GAME_STATE_INIT = 0
GameManager.GAME_STATE_PLAY = 1
GameManager.GAME_STATE_LOSE = 10
GameManager.GAME_STATE_WIN  = 11

local gameState = -1
local overEventCallBack = nil

function GameManager:init()
    gameState = -1
    overEventCallBack = nil
end

function GameManager:setGameState(state)
    if gameState ~= state then
        gameState = state 
        if gameState == GameManager.GAME_STATE_LOSE then
            GameManager:onGameOver()
        end
    end
end

function GameManager:getGameState()
	return gameState
end


function GameManager:setOnGameOverCallBack(callBack)
    overEventCallBack = callBack
end

function GameManager:onGameOver()
	if overEventCallBack then
	   overEventCallBack()
	end
end

return GameManager
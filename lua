
local player = game.Players.LocalPlayer
local radius = 20  
local damageInterval = 1  
local damageCooldown = false  

-- ReplicatedStorage에 RemoteEvent를 생성
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local damageEvent = Instance.new("RemoteEvent")
damageEvent.Name = "DamageEvent"
damageEvent.Parent = ReplicatedStorage  -- ReplicatedStorage에 RemoteEvent를 추가


local function detectNearbyPlayers()
    while true do
       
        local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        if position then
            for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                -- 자기 자신은 제외하고
                if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                    local distance = (position - targetPos).Magnitude  
                    if distance <= radius and not damageCooldown then
                        
                        damageEvent:FireServer(targetPlayer)
                        damageCooldown = true  
                        wait(damageInterval)
                        damageCooldown = false  
                    end
                end
            end
        end
        wait(0.1)  
    end
end

-- 데미지를 입히는 함수 호출
detectNearbyPlayers()

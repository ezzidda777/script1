local damage = 20  -- 플레이어에게 입힐 데
local radius = 20  -- 데미지를 입히는 범위 (너비: 20 studs)
local damageInterval = 0.5  -- 데미지 주는 간격 (초 단위)
local damageCooldown = false  -- 데미지 간격을 위한 변수

-- 플레이어가 가까이 왔을 때 데미지를 입히는 함수
local function applyDamageToPlayer(player)
    -- 플레이어가 자기 자신이 아닌지 확인
    if player == game.Players.LocalPlayer then
        return  -- 자기 자신이면 데미지 입히지 않음
    end
    
    -- 플레이어의 Humanoid가 존재할 경우에만 데미지를 입힙니다.
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and not damageCooldown then
            humanoid:TakeDamage(damage)  -- 데미지 입히기
            damageCooldown = true  -- 데미지 쿨다운 시작
            -- 쿨다운 시간 후 데미지 가능하도록 설정
            wait(damageInterval)
            damageCooldown = false
        end
    end
end

-- 특정 위치에 근처에 있는 플레이어들 탐지 (데미지 범위 내)
local function detectNearbyPlayers()
    while true do
        -- 현재 위치
        local position = workspace.CurrentCamera.CFrame.Position  -- 현재 카메라 위치, 필요에 따라 조정
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local playerPos = player.Character.HumanoidRootPart.Position
                local distance = (position - playerPos).Magnitude  -- 두 지점 간 거리 계산
                if distance <= radius then
                    applyDamageToPlayer(player)  -- 가까이 오면 데미지 입힘
                end
            end
        end
        wait(0.1)  -- 짧은 시간 간격으로 확인
    end
end

-- 데미지를 입히는 함수 호출
detectNearbyPlayers()

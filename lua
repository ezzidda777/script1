-- 로컬 스크립트 (클라이언트)
local player = game.Players.LocalPlayer
local radius = 20  -- 데미지를 입히는 범위 (20 studs)
local damageInterval = 2  -- 데미지 주는 간격 (초 단위)
local damageCooldown = false  -- 데미지 간격을 위한 변수

-- ReplicatedStorage에 RemoteEvent를 생성
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local damageEvent = Instance.new("RemoteEvent")
damageEvent.Name = "DamageEvent"
damageEvent.Parent = ReplicatedStorage  -- ReplicatedStorage에 RemoteEvent를 추가

-- 플레이어가 근처에 있으면 데미지 입히는 함수
local function detectNearbyPlayers()
    while true do
        -- 현재 플레이어의 위치
        local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        if position then
            for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                -- 자기 자신은 제외하고
                if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                    local distance = (position - targetPos).Magnitude  -- 두 지점 간 거리 계산
                    if distance <= radius and not damageCooldown then
                        -- 서버에 데미지 요청 (자기 자신에게는 데미지를 주지 않음)
                        damageEvent:FireServer(targetPlayer)
                        damageCooldown = true  -- 쿨타임 시작
                        wait(damageInterval)
                        damageCooldown = false  -- 쿨타임 종료
                    end
                end
            end
        end
        wait(0.1)  -- 짧은 시간 간격으로 확인
    end
end

-- 데미지를 입히는 함수 호출
detectNearbyPlayers()

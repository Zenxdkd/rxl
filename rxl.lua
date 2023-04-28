local function getnamecall()
    if game.PlaceId == 2788229376 then
        return "UpdateMousePos"
    elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then
        return "MousePos"
    elseif game.PlaceId == 9825515356 then
        return "GetMousePos"
    end
end

local namecalltype = getnamecall()

function MainEventLocate()
    for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v.Name == "MainEvent" then
            return v
        end
    end
end

local mainevent = MainEventLocate()

-- // Shorthand
local uwuZ4 = getgenv().Z4
local uwuMain = uwuZ4.General
local uwuCamMain = uwuZ4.Camlock.Main
local uwuCamFOV = uwuZ4.Camlock.FOV
local uwuSilentMain = uwuZ4.Silent.Main
local uwuSilentFOV = uwuZ4.Silent.FOV
local uwuTrace = uwuZ4.Tracer
local uwuFpsUnlock = uwuZ4.Misc.FpsUnlocker
local uwuHeadless = uwuZ4.Misc.Headless

-- // Optimization
local vect3 = Vector3.new
local vect2 = Vector2.new
local cnew = CFrame.new

-- // Libraries
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

-- // Services
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local plrs = game:GetService("Players")
local ws = game:GetService("Workspace")

-- // Script Variables
local CToggle = false
local lplr = plrs.LocalPlayer
local CTarget = nil
local CPart = nil
local SToggle = false
local STarget = nil
local SPart = nil

-- // Client Variables
local m = lplr:GetMouse()
local c = ws.CurrentCamera

-- // Notification Function
local function SendNotification(text)
    Notification:Notify(
        {Title = "Z4 Rewrite", Description = "exit#7360 - "..text},
        {OutlineColor = Color3.fromRGB(50,76,110),Time = 2, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(50,76,110)}
    )
end 

-- // Call notification function
if uwuMain.Notifications then
    SendNotification("exit#7360 - injecting Z4 Rewrite")
    wait(3.5)
    SendNotification("exit#7360 - finished injecting Z4 Rewrite")
end

-- // Camlock FOV
local CamlockFOV = Drawing.new("Circle")
CamlockFOV.Visible = uwuCamFOV.ShowFOV
CamlockFOV.Thickness = 1
CamlockFOV.NumSides = 30
CamlockFOV.Radius = uwuCamFOV.Radius * 3
CamlockFOV.Color = Color3.fromRGB(0, 71, 171)
CamlockFOV.Filled = uwuCamFOV.Filled
CamlockFOV.Transparency = uwuCamFOV.Transparency

--Silent FOV
local SilentFOV = Drawing.new("Circle")
SilentFOV.Visible = uwuSilentFOV.ShowFOV
SilentFOV.Thickness = 1
SilentFOV.NumSides = 30
SilentFOV.Radius = uwuSilentFOV.Radius * 3
SilentFOV.Color = Color3.fromRGB(0, 71, 171)
SilentFOV.Filled = uwuSilentFOV.Filled
SilentFOV.Transparency = uwuSilentFOV.Transparency

--Tracer
local Line = Drawing.new("Line")
Line.Color = Color3.fromRGB(137, 207, 240)
Line.Transparency = uwuTrace.Transparency
Line.Thickness = 1
Line.Visible = uwuTrace.Visible

-- // Script Functions
local function uwuFindTawget() -- // Find target
    local d, t = math.huge, nil
    for _,v in pairs (plrs:GetPlayers()) do
        local _,os = c:WorldToViewportPoint(v.Character.PrimaryPart.Position)
        if v ~= lplr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and os then
            local pos = c:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (vect2(pos.X, pos.Y) - vect2(m.X, m.Y + 36)).magnitude
            if magnitude < d then
                t = v
                d = magnitude
            end
        end
    end
    return t
end

local function uwuFindPart() -- // Find aimpart
    local d, p = math.huge, nil
    if CTarget then
        for _,v in pairs(CTarget.Character:GetChildren()) do
            if table.find(uwuCamMain.Parts, v.Name) then
                local pos = c:WorldToViewportPoint(v.Position)
                local Magn = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
                if Magn < d then
                    d = Magn
                    p = v
                end
            end
        end
        return p.Name
    end
end

local function uwuFindSilentPart() -- // Find aimpart
    local d, p = math.huge, nil
    if CTarget then
        for _,v in pairs(CTarget.Character:GetChildren()) do
            if table.find(uwuSilentMain.Parts, v.Name) then
                local pos = c:WorldToViewportPoint(v.Position)
                local Magn = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
                if Magn < d then
                    d = Magn
                    p = v
                end
            end
        end
        return p.Name
    end
end

local function uwuCheckAnti(targ) -- // Anti-aim detection
    if (targ.Character.HumanoidRootPart.Velocity.Y < -5 and targ.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall) or targ.Character.HumanoidRootPart.Velocity.Y < -50 then
        return true
    elseif targ and (targ.Character.HumanoidRootPart.Velocity.X > 35 or targ.Character.HumanoidRootPart.Velocity.X < -35) then
        return true
    elseif targ and targ.Character.HumanoidRootPart.Velocity.Y > 60 then
        return true
    elseif targ and (targ.Character.HumanoidRootPart.Velocity.Z > 35 or targ.Character.HumanoidRootPart.Velocity.Z < -35) then
        return true
    else
        return false
    end
end

local function InSilentRadiuwus(target, section, fov) -- // Check if player is in the fov
    if target then
        local pos = nil
        if not uwuCheckAnti(target) then
            pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + target.Character.PrimaryPart.Velocity * section.Prediction)
        else
            pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + ((target.Character.Humanoid.MoveDirection * target.Character.Humanoid.WalkSpeed) * section.Prediction))
        end
        local mag = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
        if mag < fov * 3 then
            return true
        else
            return false
        end
    end
end

local function Silent()
    if STarget then
        if SPart and InSilentRadiuwus(STarget, uwuSilentMain, SilentFOV.Radius) then
            if not uwuCheckAnti(STarget) then
                mainevent:FireServer(namecalltype, STarget.Character[SPart].Position + (STarget.Character[SPart].Velocity * uwuSilentMain.Prediction))
            else
                mainevent:FireServer(namecalltype, STarget.Character[SPart].Position + ((STarget.Character.Humanoid.MoveDirection * STarget.Character.Humanoid.WalkSpeed) * uwuSilentMain.Prediction))
            end
        end
    end
end


local function InRadiuwus(target, section, fov) -- // Check if player is in the fov
    if target then
        if uwuCamFOV.UseFOV then
            local pos = nil
            if not uwuCheckAnti(target) then
                pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + target.Character.PrimaryPart.Velocity * section.Prediction)
            else
                pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + ((target.Character.Humanoid.MoveDirection * target.Character.Humanoid.WalkSpeed) * section.Prediction))
            end
            local mag = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
            if mag < fov * 3 then
                return true
            else
                return false
            end
        else
            return true
        end
    end
end

uis.InputBegan:Connect(function(k,t)
    if not t then
        if k.KeyCode == Enum.KeyCode[uwuCamMain.Key:upper()] then
            CToggle = true
            CTarget = uwuFindTawget()
            if uwuMain.Notifications then
                SendNotification("locked onto "..CTarget.Name)
            end
        elseif k.KeyCode == Enum.KeyCode[uwuCamMain.UnlockKey:upper()] then
            if CToggle then
                CToggle = false
                CTarget = nil
                if uwuMain.Notifications then
                    SendNotification("unlocked")
                end
            end
        elseif k.KeyCode == Enum.KeyCode[uwuSilentMain.Toggle:upper()] and uwuSilentMain == "Regular" then
            if SToggle then
                SToggle = false
                if uwuMain.Notifications then
                    SendNotification("silent disabled")
                end
            else
                SToggle = true
                if uwuMain.Notifications then
                    SendNotification("silent enabled")
                end
            end
        end
    end
end)

rs.RenderStepped:Connect(function()
    if CTarget then
        CPart = uwuFindPart()
        local pos = nil
        local cum = nil
        if CTarget.Character.BodyEffects["K.O"].Value == true or lplr.Character.BodyEffects["K.O"].Value == true then
            CToggle = false
            CTarget = nil
        else
            if uwuCamMain.Shake then
                if uwuCamMain.PredictMovement then
                    if not uwuCheckAnti(CTarget) then
                        cum = CTarget.Character[CPart].Position + CTarget.Character[CPart].Velocity * uwuCamMain.Prediction + (vect3(
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                        ) * 0.1)
                    else
                        cum = CTarget.Character[CPart].Position + ((CTarget.Character.Humanoid.MoveDirection * CTarget.Character.Humanoid.WalkSpeed) * uwuCamMain.Prediction + (vect3(
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                        ) * 0.1))
                    end
                    pos = c:WorldToViewportPoint(cum)
                else
                    cum = CTarget.Character[CPart].Position + (vect3(
                        math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                        math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                        math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                    ) * 0.1)
                    pos = c:WorldToViewportPoint(cum)
                end
            else
                if uwuCamMain.PredictMovement then
                    if not uwuCheckAnti(CTarget) then
                        cum = CTarget.Character[CPart].Position + CTarget.Character[CPart].Velocity * uwuCamMain.Prediction
                    else
                        cum = CTarget.Character[CPart].Position + ((CTarget.Character.Humanoid.MoveDirection * CTarget.Character.Humanoid.WalkSpeed) * uwuCamMain.Prediction)
                    end
                    pos = c:WorldToViewportPoint(cum)
                else
                    cum = CTarget.Character[CPart].Position
                    pos = c:WorldToViewportPoint(cum)
                end
            end
            if InRadiuwus(CTarget, uwuCamMain, CamlockFOV.Radius) then
                local main = nil
                if uwuCamMain.SmoothLock then
                    main = cnew(c.CFrame.p, cum)
                    c.CFrame = c.CFrame:Lerp(main, uwuCamMain.Smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                else
                    c.CFrame = cnew(c.CFrame.p, cum)
                end
            end
            if uwuMain.FOVMode == "Mouse" then
                if uwuCamFOV.ShowFOV then
                    CamlockFOV.Position = vect2(m.X, m.Y + 36)
                end
                if uwuSilentFOV.ShowFOV then
                    SilentFOV.Position = vect2(m.X, m.Y + 36)
                end
            elseif uwuMain.FOVMode == "PredictionPoint" then
                if uwuCamFOV.ShowFOV then
                    CamlockFOV.Position = vect2(pos.X, pos.Y)
                end
                if uwuSilentFOV.ShowFOV then
                    SilentFOV.Position = vect2(pos.X, pos.Y)
                end
            end
            if uwuTrace.Enabled then
                Line.Visible = true
                Line.From = vect2(m.X, m.Y + 36)
                Line.To = vect2(pos.X, pos.Y)
            end
        end
    else
        CamlockFOV.Position = vect2(m.X, m.Y + 36)
        SilentFOV.Position = vect2(m.X, m.Y + 36)
        Line.Visible = false
    end
end)

lplr.Character.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        tool.Activated:connect(function()
            if uwuSilentMain.Mode == "Regular" then
                if SToggle then
                    STarget = uwuFindTawget()
                    if STarget then
                        SPart = uwuFindSilentPart()
                        if SPart then
                            Silent()
                        end
                    end
                end
            elseif uwuSilentMain.Mode == "Target" then
                if CToggle then
                    STarget = CTarget
                    if STarget then
                        SPart = uwuFindSilentPart()
                        if SPart then
                            Silent()
                        end
                    end
                end
            end
        end)
    end
end)

lplr.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(tool)
        tool.Activated:connect(function()
            if uwuSilentMain.Mode == "Regular" then
                if SToggle then
                    STarget = uwuFindTawget()
                    if STarget then
                        SPart = uwuFindSilentPart()
                        if SPart then
                            Silent()
                        end
                    end
                end
            elseif uwuSilentMain.Mode == "Target" then
                if CToggle then
                    STarget = CTarget
                    if STarget then
                        SPart = uwuFindSilentPart()
                        if SPart then
                            Silent()
                        end
                    end
                end
            end
        end)
    end)
end)


--fps unlocker
if uwuFpsUnlock then
 local fps = 5000
 
     if setfpscap then
         setfpscap(fps)
 end
end 

--headless

if uwuHeadless then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxHackerProLuaStuff/avatar-editor-thing/main/headless.lua"))()
end

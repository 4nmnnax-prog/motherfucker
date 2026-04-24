local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local IDInput = Instance.new("TextBox")
local ApplyBtn = Instance.new("TextButton")

ScreenGui.Name = "FakeLimsLarpUI"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.Text = "Fake Lims Larp"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextSize = 20

IDInput.Name = "IDInput"
IDInput.Parent = MainFrame
IDInput.PlaceholderText = "Enter Accessory ID..."
IDInput.Position = UDim2.new(0.1, 0, 0.35, 0)
IDInput.Size = UDim2.new(0.8, 0, 0, 30)
IDInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)

ApplyBtn.Name = "ApplyBtn"
ApplyBtn.Parent = MainFrame
ApplyBtn.Text = "Apply Fake"
ApplyBtn.Position = UDim2.new(0.25, 0, 0.7, 0)
ApplyBtn.Size = UDim2.new(0.5, 0, 0, 35)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local currentId = ""
local runService = game:GetService("RunService")

local function applyFake(id)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or id == "" then return end

    local success, model = pcall(function()
        return game:GetService("InsertService"):LoadAsset(tonumber(id))
    end)

    if success and model then
        local targetAcc = model:FindFirstChildOfClass("Accessory")
        if targetAcc then
            local targetHandle = targetAcc:WaitForChild("Handle")
            local targetMesh = targetHandle:FindFirstChildOfClass("SpecialMesh")
            
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    local mesh = handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", handle)
                    
                    mesh.MeshId = targetMesh.MeshId
                    mesh.TextureId = targetMesh.TextureId
                    
                    spawn(function()
                        while char and char:WaitForChild("Humanoid").Health > 0 do
                            handle.Velocity = Vector3.new(0, 30, 0)
                            runService.Heartbeat:Wait()
                        end
                    end)
                    print("Mesh applied successfully!")
                end
            end
        end
        model:Destroy()
    end
end

ApplyBtn.MouseButton1Click:Connect(function()
    currentId = IDInput.Text
    applyFake(currentId)
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    if currentId ~= "" then
        wait(2)
        applyFake(currentId)
    end
end)

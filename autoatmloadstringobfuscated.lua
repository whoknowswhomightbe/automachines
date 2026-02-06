--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

loadstring(game:HttpGet("https://raw.githubusercontent.com/whoknowswhomightbe/automachines/refs/heads/main/autoatmobfuscated.lua"))();local v0=game:GetService("ProximityPromptService");for v4,v5 in ipairs(workspace:GetDescendants()) do if v5:IsA("ProximityPrompt") then v5.HoldDuration=0;end end workspace.DescendantAdded:Connect(function(v6) if v6:IsA("ProximityPrompt") then v6.HoldDuration=0;end end);local v1=game:GetService("Players");local v2=game:GetService("VirtualUser");local v3=v1.LocalPlayer;v3.Idled:Connect(function() v2:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(1);v2:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame);end);print("✅ Anti-AFK enabled");
getgenv().Configurations = {
    SilentAim = {
        Enabled = false,
        Aimpart = "LowerTorso",
        Prediction = 0.13913,
        AutomaticPrediction = false,
        ClosestPart = false,

        Airshot = {
            Enabled = false,
            Aimpart = "UpperTorso",
            UseAirprediction = true,
            AirPrediction = 0.1291,
            UseJumpOffset = true,
            JumpOffset = 0.012
        },

        Visuals = {
            TargetInfo = false,
            Tracer = false,
            TracerColor = Color3.fromRGB(255,255,255),
            TracerThickness = 1,
        },

        FieldOfView = {
            Visible = false,
            Radius = 120,
            Color = Color3.fromRGB(255,255,255),
          Filled = false,
            Transparency = 1
        },

        Checks = {
            Wall = false,
            Friend = false,
            Knocked = false,
            Grabbed = false,
        }
    },

    TargetAim = {
        Enabled = false,
        Toggled = false,
        Prediction = 0.1391,
        HitPart = "HumanoidRootPart",
        AutomaticPrediction = false,
        ClosestPart = false,

        Notifications = false,

        
        Airshot = {
            Enabled = false,
            Aimpart = "UpperTorso",
            UseAirprediction = true,
            AirPrediction = 0.1291,
            UseJumpOffset = true,
            JumpOffset = 0.012
        },

        Visuals = {
            TargetInfo = false,
            Tracer = false,
            TracerColor = Color3.fromRGB(255,255,255),
            TracerThickness = 1,
            Chams = false,
            ChamsOutline = Color3.fromRGB(0,0,0),
            ChamsColor = Color3.fromRGB(255,255,255),
            Dot = false,
            DotColor = Color3.fromRGB(255,255,255),
            DotSize = 10
        },

        Checks = {
            Wall = false,
            Friend = false,
            Knocked = false,
            Dead = false,
        }
    },
}

-- define the variables and services
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local TweenService      = game:GetService("TweenService")
local Configurations    = getgenv().Configurations -- you can just do Configurations but i defined it since i dont want that yellow indicator on my roblox lsp

local LocalPlayer       = Players.LocalPlayer
local character = LocalPlayer.Character
local humanoid = character.Humanoid
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local tweenInfo = TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)

-- esp ayarları
local settings = {
    opacity = 0.8,  -- Set opacity for drawings
    teamcheck = false, -- DOES NOT WORK ❌❌❌
    teamcolor = false, -- DOES NOT WORK ❌❌❌
    tracerOrigin = "Mouse",
    tracerColor = Color3.fromRGB(255,255,255),
    boxVisible = false,  
    boxColor = Color3.fromRGB(255,255,255),
    tracerVisible = false,
    namesVisible = false,
    namesColor = Color3.fromRGB(255,255,255),
    distanceVisible = false,
    flags = {health = false},
    skeleton = false,
    skeletonColor = Color3.fromRGB(255, 251, 139)
};
local realcframe = false
local isSpeedEnabled = false
local speedMultiplier = 2

local function modifySpeed()
    if character and humanoid and isSpeedEnabled then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local moveDirection = humanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + moveDirection * speedMultiplier
            end
        end
    end
end

local cframe =false
local cframespeed = 5
local cframeenabled = false


local SilentPos 
local SilentPredictionPos
local SilentTarget
local silentoldpart

local targetpos 
local targetpredpos
local target
local targetoldpart

local Games = {
    [2788229376]                     = {Name = "Da Hood", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [16033173781]                    = {Name = "Da Hood Macro", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [7213786345]                     = {Name = "Da Hood VC", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [9825515356]                     = {Name = "Hood Customs", Arg = "MousePosUpdate", Remote = "MainEvent"},
    [5602055394]                     = {Name = "Hood Modded", Arg = "MousePos", Remote = "Bullets"},
    [7951883376]                     = {Name = "Hood Modded VC", Arg = "MousePos", Remote = "Bullets"},
    [9183932460]                     = {Name = "Untitled Hood", Arg = "UpdateMousePos", Remote = ".gg/untitledhood"},
    [14412355918]                    = {Name = "Da Downhill", Arg = "MOUSE", Remote = "MAINEVENT"},
    [14412601883]                    = {Name = "Hood Bank", Arg = "MOUSE", Remote = "MAINEVENT"},
    [14412436145]                    = {Name = "Da Uphill", Arg = "MOUSE", Remote = "MAINEVENT"},
    [14487637618]                    = {Name = "Da Hood Bot Aim Trainer", Arg = "MOUSE", Remote = "MAINEVENT"},
    [11143225577]                    = {Name = "1v1 Hood Aim Trainer", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [14413712255]                    = {Name = "Hood Aim", Arg = "MOUSE", Remote = "MAINEVENT"},
    [12927359803]                    = {Name = "Dah Aim Trainer", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [12867571492]                    = {Name = "Katana Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [11867820563]                    = {Name = "Dae Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17109142105]                    = {Name = "Da Battles", Arg = "MoonUpdateMousePos", Remote = "MainEvent"},
    [15186202290]                    = {Name = "Da Strike", Arg = "MOUSE", Remote = "MAINEVENT"},
    [16469595315]                    = {Name = "Del Hood Aim", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17319408836]                    = {Name = "OG Da Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [14975320521]                    = {Name = "Ar Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17200018150]                    = {Name = "Hood Of AR", Arg = "UpdateMousePos", Remote = "MainEvent"},
}

local Library = {};
do
	Library = {
		Open = true;
		Accent = Color3.fromRGB(188, 107, 255);
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {};
		Holder = nil;
		Keys = {
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.CapsLock] = "Caps",
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.KeypadOne] = "Num1",
			[Enum.KeyCode.KeypadTwo] = "Num2",
			[Enum.KeyCode.KeypadThree] = "Num3",
			[Enum.KeyCode.KeypadFour] = "Num4",
			[Enum.KeyCode.KeypadFive] = "Num5",
			[Enum.KeyCode.KeypadSix] = "Num6",
			[Enum.KeyCode.KeypadSeven] = "Num7",
			[Enum.KeyCode.KeypadEight] = "Num8",
			[Enum.KeyCode.KeypadNine] = "Num9",
			[Enum.KeyCode.KeypadZero] = "Num0",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Asterisk] = "*",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		UIKey = Enum.KeyCode.End;
		ScreenGUI = nil;
		FSize = 13;
		UIFont = Font.new("rbxasset://fonts/families/Ubuntu.json");
		SettingsPage = nil;
		VisValues = {};
		Cooldown = false;
	}

	-- // Ignores
	local Flags = {}; -- Ignore
	local Dropdowns = {}; -- Ignore
	local Pickers = {}; -- Ignore
	local VisValues = {}; -- Ignore

	-- // Extension
	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
	local LocalPlayer = game:GetService('Players').LocalPlayer;
	local Mouse = LocalPlayer:GetMouse();
	local TweenService = game:GetService("TweenService");

	-- // Misc Functions
	do
		function Library:Connection(Signal, Callback)
			local Con = Signal:Connect(Callback)
			return Con
		end
		--
		function Library:Disconnect(Connection)
			Connection:Disconnect()
		end
		--
		function Library:Round(Number, Float)
			return Float * math.floor(Number / Float)
		end
		--
		function Library.NextFlag()
			Library.UnNamedFlags = Library.UnNamedFlags + 1
			return string.format("%.14g", Library.UnNamedFlags)
		end
		--
		function Library:RGBA(r, g, b, alpha)
			local rgb = Color3.fromRGB(r, g, b)
			local mt = table.clone(getrawmetatable(rgb))

			setreadonly(mt, false)
			local old = mt.__index

			mt.__index = newcclosure(function(self, key)
				if key:lower() == "transparency" then
					return alpha
				end

				return old(self, key)
			end)

			setrawmetatable(rgb, mt)

			return rgb
		end
		--
		function Library:GetConfig()
			local Config = ""
			for Index, Value in pairs(self.Flags) do
				if
					Index ~= "ConfigConfig_List"
					and Index ~= "ConfigConfig_Load"
					and Index ~= "ConfigConfig_Save"
				then
					local Value2 = Value
					local Final = ""
					--
					if typeof(Value2) == "Color3" then
						local hue, sat, val = Value2:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
					elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
						local hue, sat, val = Value2.Color:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
					elseif typeof(Value2) == "table" and Value.Mode then
						local Values = Value.current
						--
						Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
					elseif Value2 ~= nil then
						if typeof(Value2) == "boolean" then
							Value2 = ("bool(%s)"):format(tostring(Value2))
						elseif typeof(Value2) == "table" then
							local New = "table("
							--
							for Index2, Value3 in pairs(Value2) do
								New = New .. Value3 .. ","
							end
							--
							if New:sub(#New) == "," then
								New = New:sub(0, #New - 1)
							end
							--
							Value2 = New .. ")"
						elseif typeof(Value2) == "string" then
							Value2 = ("string(%s)"):format(Value2)
						elseif typeof(Value2) == "number" then
							Value2 = ("number(%s)"):format(Value2)
						end
						--
						Final = Value2
					end
					--
					Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
				end
			end
			--
			return Config
		end
		--
		function Library:LoadConfig(Config)
			local Table = string.split(Config, "\n")
			local Table2 = {}
			for Index, Value in pairs(Table) do
				local Table3 = string.split(Value, ":")
				--
				if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
					local Value = Table3[2]:sub(2, #Table3[2])
					--
					if Value:sub(1, 3) == "rgb" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 3) == "key" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						if Table4[1] == "nil" and Table4[2] == "nil" then
							Table4[1] = nil
							Table4[2] = nil
						end
						--
						Value = Table4
					elseif Value:sub(1, 4) == "bool" then
						local Bool = Value:sub(6, #Value - 1)
						--
						Value = Bool == "true"
					elseif Value:sub(1, 5) == "table" then
						local Table4 = string.split(Value:sub(7, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 6) == "string" then
						local String = Value:sub(8, #Value - 1)
						--
						Value = String
					elseif Value:sub(1, 6) == "number" then
						local Number = tonumber(Value:sub(8, #Value - 1))
						--
						Value = Number
					end
					--
					Table2[Table3[1]] = Value
				end
			end
			--
			for i, v in pairs(Table2) do
				if Flags[i] then
					if typeof(Flags[i]) == "table" then
						Flags[i]:Set(v)
					else
						Flags[i](v)
					end
				end
			end
		end
		--
		function Library:SetOpen(bool)
			if typeof(bool) == 'boolean' then
				Library.Open = bool;
				Library.ScreenGUI.Enabled = bool;
				Library.Holder.Visible = bool;
			end
		end;
		--
		function Library:IsMouseOverFrame(Frame)
			local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

			if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
				and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

				return true;
			end;
		end;
		--
		function Library:ChangeAccent(Color)
			Library.Accent = Color

			for obj, theme in next, Library.ThemeObjects do
				if theme:IsA("Frame") or theme:IsA("TextButton") or theme:IsA("ScrollingFrame") then
					theme.BackgroundColor3 = Color
				elseif theme:IsA("TextLabel") or theme:IsA("TextBox") then
					theme.TextColor3 = Color
				elseif theme:IsA("ImageLabel") or theme:IsA("ImageButton") then
					theme.ImageColor3 = Color
				end
			end
		end
	end;

	-- // Colorpicker Element
	do
		function Library:NewPicker(name, default, defaultalpha, parent, count, flag, callback)
			-- // Instances
			local ColorpickerFrame = Instance.new("TextButton")
			ColorpickerFrame.Name = "Colorpicker_frame"
			ColorpickerFrame.BackgroundColor3 = default
			ColorpickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ColorpickerFrame.BorderSizePixel = 0
			ColorpickerFrame.Position = UDim2.new(1, - (count * 30) - (count * 4), 0.5, 0)
			ColorpickerFrame.Size = UDim2.new(0, 20, 0, 20)
			ColorpickerFrame.AnchorPoint = Vector2.new(0,0.5)
			ColorpickerFrame.Text = ""
			ColorpickerFrame.AutoButtonColor = false

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = ColorpickerFrame

			ColorpickerFrame.Parent = parent

			local Colorpicker = Instance.new("TextButton")
			Colorpicker.Name = "Colorpicker"
			Colorpicker.BackgroundColor3 = Color3.fromRGB(14, 17, 19)
			Colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Colorpicker.BorderSizePixel = 0
			Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y - 50)
			Colorpicker.Size = UDim2.new(0, 180, 0, 180)
			Colorpicker.Parent = Library.ScreenGUI
			Colorpicker.ZIndex = 100
			Colorpicker.Visible = false
			Colorpicker.Text = ""
			Colorpicker.AutoButtonColor = false
			local H,S,V = default:ToHSV()
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Image = "rbxassetid://11970108040"
			ImageLabel.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageLabel.BorderSizePixel = 0
			ImageLabel.Position = UDim2.new(0.0556, 0, 0.026, 0)
			ImageLabel.Size = UDim2.new(0, 160, 0, 154)
			ImageLabel.Parent = Colorpicker

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Colorpicker

			local ImageButton = Instance.new("ImageButton")
			ImageButton.Name = "ImageButton"
			ImageButton.Image = "rbxassetid://14684562507"
			ImageButton.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageButton.BorderSizePixel = 0
			ImageButton.Position = UDim2.new(0.056, 0, 0.026, 0)
			ImageButton.Size = UDim2.new(0, 160, 0, 154)
			ImageButton.AutoButtonColor = false

			local SVSlider = Instance.new("Frame")
			SVSlider.Name = "SV_slider"
			SVSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SVSlider.BackgroundTransparency = 1
			SVSlider.ClipsDescendants = true
			SVSlider.Position = UDim2.new(0.855, 0, 0.0966, 0)
			SVSlider.Size = UDim2.new(0,7,0,7)
			SVSlider.ZIndex = 3

			local Val = Instance.new("ImageLabel")
			Val.Name = "Val"
			Val.Image = "http://www.roblox.com/asset/?id=14684563800"
			Val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Val.BackgroundTransparency = 1
			Val.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Val.BorderSizePixel = 0
			Val.Size = UDim2.new(1, 0, 1, 0)
			Val.Parent = ImageButton

			local UICorner1 = Instance.new("UICorner")
			UICorner1.Name = "UICorner"
			UICorner1.CornerRadius = UDim.new(0, 100)
			UICorner1.Parent = SVSlider

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Name = "UIStroke"
			UIStroke.Color = Color3.fromRGB(255, 255, 255)
			UIStroke.Parent = SVSlider

			SVSlider.Parent = ImageButton

			ImageButton.Parent = Colorpicker

			local ImageButton1 = Instance.new("ImageButton")
			ImageButton1.Name = "ImageButton"
			ImageButton1.Image = "http://www.roblox.com/asset/?id=16789872274"
			ImageButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageButton1.BorderSizePixel = 0
			ImageButton1.Position = UDim2.new(0.5, 0,0, 165)
			ImageButton1.Size = UDim2.new(0, 160,0, 8)
			ImageButton1.AutoButtonColor = false
			ImageButton1.AnchorPoint = Vector2.new(0.5,0)
			ImageButton1.BackgroundTransparency = 1

			local Frame = Instance.new("Frame")
			Frame.Name = "Frame"
			Frame.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.926, 0,0.5, 0)
			Frame.Size = UDim2.new(0, 12,0, 12)
			Frame.AnchorPoint = Vector2.new(0,0.5)
			Frame.ZIndex = 45

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner"
			UICorner2.Parent = Frame
			UICorner2.CornerRadius = UDim.new(1,0)
			
			local UICorner3 = Instance.new("UICorner")
			UICorner3.Name = "UICorner"
			UICorner3.Parent = ImageButton1

			Frame.Parent = ImageButton1

			ImageButton1.Parent = Colorpicker

			-- // Connections
			local mouseover = false
			local hue, sat, val = default:ToHSV()
			local hsv = default:ToHSV()
			local alpha = defaultalpha
			local oldcolor = hsv
			local slidingsaturation = false
			local slidinghue = false
			local slidingalpha = false

			local function update()
				local real_pos = game:GetService("UserInputService"):GetMouseLocation()
				local mouse_position = Vector2.new(real_pos.X, real_pos.Y - 30)
				local relative_palette = (mouse_position - ImageButton.AbsolutePosition)
				local relative_hue     = (mouse_position - ImageButton1.AbsolutePosition)
				--
				if slidingsaturation then
					sat = math.clamp(1 - relative_palette.X / ImageButton.AbsoluteSize.X, 0, 1)
					val = math.clamp(1 - relative_palette.Y / ImageButton.AbsoluteSize.Y, 0, 1)
				elseif slidinghue then
					hue = math.clamp(relative_hue.X / ImageButton.AbsoluteSize.X, 0, 1)
				end

				hsv = Color3.fromHSV(hue, sat, val)
				TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
				ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				ColorpickerFrame.BackgroundColor3 = hsv

				TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()

				if flag then
					Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
				end

				callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
			end

			local function set(color, a)
				if type(color) == "table" then
					a = color[4]
					color = Color3.fromHSV(color[1], color[2], color[3])
				end
				if type(color) == "string" then
					color = Color3.fromHex(color)
				end

				local oldcolor = hsv
				local oldalpha = alpha

				hue, sat, val = color:ToHSV()
				alpha = a or 1
				hsv = Color3.fromHSV(hue, sat, val)

				if hsv ~= oldcolor then
					ColorpickerFrame.BackgroundColor3 = hsv
					TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
					ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()

					if flag then
						Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
					end

					callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
				end
			end

			Flags[flag] = set

			set(default, defaultalpha)

			ImageButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = true
					update()
				end
			end)

			ImageButton.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = false
					update()
				end
			end)

			ImageButton1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = true
					update()
				end
			end)

			ImageButton1.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = false
					update()
				end
			end)

			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if slidinghue then
						update()
					end

					if slidingsaturation then
						update()
					end
				end
			end)

			local colorpickertypes = {}

			function colorpickertypes:Set(color, newalpha)
				set(color, newalpha)
			end

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Colorpicker.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(Colorpicker) and not Library:IsMouseOverFrame(ColorpickerFrame) then
						Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)
						TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)}):Play()
						task.spawn(function()
							task.wait(0.1)
							Colorpicker.Visible = false
							parent.ZIndex = 1
							Library.Cooldown = false
						end)
						for _,V in next, Colorpicker:GetDescendants() do
							if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
								Library.VisValues[V] = V.BackgroundTransparency
							elseif V:IsA("TextLabel") or V:IsA("TextBox") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
								Library.VisValues[V] = V.TextTransparency
							elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
								Library.VisValues[V] = V.ImageTransparency
							elseif V:IsA("UIStroke") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
								Library.VisValues[V] = V.Transparency
							end
						end
					end
				end
			end)

			ColorpickerFrame.MouseButton1Down:Connect(function()
				if Colorpicker.Visible == false then
					Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)
					TweenService:Create(Colorpicker, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)}):Play()
				end
				Colorpicker.Visible = true
				parent.ZIndex = 100
				Library.Cooldown = true
				TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				for _,V in next, Colorpicker:GetDescendants() do
					if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("TextLabel") or V:IsA("TextBox") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = Library.VisValues[V]}):Play();
					elseif V:IsA("UIStroke") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()
					end
				end

				if slidinghue then
					slidinghue = false
				end

				if slidingsaturation then
					slidingsaturation = false
				end
			end)

			return colorpickertypes, Colorpicker
		end
	end

	function Library:NewInstance(Inst, Theme)
		local Obj = Instance.new(Inst)
		if Theme then
			table.insert(Library.ThemeObjects, Obj)
			if Obj:IsA("Frame") or Obj:IsA("TextButton") or Obj:IsA("ScrollingFrame") then
				Obj.BackgroundColor3 = Library.Accent;
				if Obj:IsA("ScrollingFrame") then
					Obj.ScrollBarImageColor3 = Library.Accent
				end
			elseif Obj:IsA("TextLabel") or Obj:IsA("TextBox") then
				Obj.TextColor3 = Library.Accent;
			elseif Obj:IsA("ImageLabel") or Obj:IsA("ImageButton") then
				Obj.ImageColor3 = Library.Accent;
			elseif Obj:IsA("UIStroke") then
				Obj.Color = Library.Accent;
			end;
		end;
		return Obj;
	end;
	
	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;
		--
		function Library:Window(Options)
			local Window = {
				Pages = {};
				Sections = {};
				Elements = {};
				Dragging = { false, UDim2.new(0, 0, 0, 0) };
				Name = Options.Name or "dmt";
			};
			--
			local Lexyawin = Instance.new("ScreenGui", game.CoreGui)
			Lexyawin.Name = "lexyawin"
			Lexyawin.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Library.ScreenGUI = Lexyawin

			local MainFrame = Instance.new("TextButton")
			MainFrame.Name = "Main_frame"
			MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			MainFrame.BackgroundColor3 = Color3.fromRGB(8, 9, 10)
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.BorderSizePixel = 0
			MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainFrame.Size = UDim2.new(0, 710, 0, 535)
			MainFrame.Text = ''
			MainFrame.AutoButtonColor = false
			MainFrame.Parent = Lexyawin
			Library.Holder = MainFrame

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.Parent = MainFrame

			local Sidebar = Instance.new("Frame")
			Sidebar.Name = "Sidebar"
			Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sidebar.BackgroundTransparency = 1
			Sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Sidebar.BorderSizePixel = 0
			Sidebar.Size = UDim2.new(0, 200, 0, 535)

			local TextThingAttop = Library:NewInstance("TextLabel", true)
			TextThingAttop.Name = "text_thing_attop"
			TextThingAttop.FontFace = Library.UIFont
			TextThingAttop.RichText = true
			TextThingAttop.Text = Window.Name
			TextThingAttop.TextColor3 = Library.Accent
			TextThingAttop.TextSize = 25
			TextThingAttop.TextWrapped = true
			TextThingAttop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextThingAttop.BackgroundTransparency = 1
			TextThingAttop.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextThingAttop.BorderSizePixel = 0
			TextThingAttop.Size = UDim2.new(0, 188, 0, 75)
			TextThingAttop.Parent = Sidebar

			local TabHolders = Instance.new("ScrollingFrame")
			TabHolders.Name = "Tab_holders"
			TabHolders.AutomaticCanvasSize = Enum.AutomaticSize.Y
			TabHolders.CanvasSize = UDim2.new()
			TabHolders.ScrollBarThickness = 0
			TabHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabHolders.BackgroundTransparency = 1
			TabHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabHolders.BorderSizePixel = 0
			TabHolders.Position = UDim2.new(0.0449, 0, 0.14, 0)
			TabHolders.Selectable = false
			TabHolders.Size = UDim2.new(0, 181, 0, 460)
			TabHolders.SelectionGroup = false

			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Name = "UIListLayout"
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = TabHolders
			
			local TabSectionHolder = Instance.new("Frame")
			TabSectionHolder.Name = "Tab_section_holder"
			TabSectionHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabSectionHolder.BackgroundTransparency = 1
			TabSectionHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabSectionHolder.BorderSizePixel = 0
			TabSectionHolder.Position = UDim2.new(0.282, 0, 0.164, 0)
			TabSectionHolder.Size = UDim2.new(0, 500, 0, 430)
			
			local FadeThing = Instance.new("Frame")
			FadeThing.Name = "FadeThing"
			FadeThing.BackgroundColor3 = Color3.fromRGB(8, 9, 10)
			FadeThing.BackgroundTransparency = 1
			FadeThing.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FadeThing.BorderSizePixel = 0
			FadeThing.Position = UDim2.new(0, 0, -0.166, 0)
			FadeThing.Selectable = false
			FadeThing.Size = UDim2.new(0, 503, 0, 501)
			FadeThing.SelectionGroup = false
			FadeThing.Visible = false
			FadeThing.ZIndex = 100
			FadeThing.Parent = TabSectionHolder
			
			TabHolders.Parent = Sidebar

			Sidebar.Parent = MainFrame
			
			TabSectionHolder.Parent = MainFrame
			
			-- // Elements
			Window.Elements = {
				TabHolder = TabHolders,
				Holder = TabSectionHolder,
				FadeThing = FadeThing,
			}

			-- // Dragging
			Library:Connection(MainFrame.MouseButton1Down, function()
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				Window.Dragging[1] = true
				Window.Dragging[2] = UDim2.new(0, Location.X - MainFrame.AbsolutePosition.X, 0, Location.Y - MainFrame.AbsolutePosition.Y)
			end)
			Library:Connection(game:GetService("UserInputService").InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 and Window.Dragging[1] then
					local Location = game:GetService("UserInputService"):GetMouseLocation()
					Window.Dragging[1] = false
					Window.Dragging[2] = UDim2.new(0, 0, 0, 0)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(Input)
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				local ActualLocation = nil

				-- Dragging
				if Window.Dragging[1] then
					MainFrame.Position = UDim2.new(
						0,
						Location.X - Window.Dragging[2].X.Offset + (MainFrame.Size.X.Offset * MainFrame.AnchorPoint.X),
						0,
						Location.Y - Window.Dragging[2].Y.Offset + (MainFrame.Size.Y.Offset * MainFrame.AnchorPoint.Y)
					)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Input.KeyCode == Library.UIKey then
					Library:SetOpen(not Library.Open)
				end
			end)
			
			-- // Functions
			function Window:UpdateTabs()
				for Index, Page in pairs(Window.Pages) do
					Page:Turn(Page.Open)
				end
			end

			-- // Returns
			Library.Holder = MainFrame
			return setmetatable(Window, Library)
		end;
		--
		function Library:Catagory(Properties)
			local Page = {
				Name = Properties.Name or "Page",
				Window = self,
				Elements = {},
			}
			--
			local TabSeparationName = Instance.new("TextLabel")
			TabSeparationName.Name = "Tab_separation_name"
			TabSeparationName.FontFace = Font.new(
				"rbxasset://fonts/families/Ubuntu.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			)
			TabSeparationName.Text = Page.Name
			TabSeparationName.TextColor3 = Color3.fromRGB(36, 37, 40)
			TabSeparationName.TextSize = 11
			TabSeparationName.TextXAlignment = Enum.TextXAlignment.Left
			TabSeparationName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabSeparationName.BackgroundTransparency = 1
			TabSeparationName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabSeparationName.BorderSizePixel = 0
			TabSeparationName.Size = UDim2.new(0, 178, 0, 25)

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 10)
			UIPadding.Parent = TabSeparationName

			TabSeparationName.Parent = Page.Window.Elements.TabHolder
		end;
		--
		function Library:Page(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Page = {
				Name = Properties.Name or Properties.name or "Page",
				Icon = Properties.Icon or "rbxassetid://16687036847",
				Window = self,
				Open = false,
				Sections = {},
				Pages = {},
				Elements = {},
			}
			--
			local ATabActive = Instance.new("TextButton")
			ATabActive.Name = "a_tab_active"
			ATabActive.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
			ATabActive.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ATabActive.BorderSizePixel = 0
			ATabActive.BackgroundTransparency = 1
			ATabActive.Position = UDim2.new(-0.011, 0, 0.0587, 0)
			ATabActive.Size = UDim2.new(0, 185, 0, 40)
			ATabActive.Text = ""
			ATabActive.AutoButtonColor = false

			local UICorner1 = Instance.new("UICorner")
			UICorner1.Name = "UICorner"
			UICorner1.Parent = ATabActive

			local TabImage = Instance.new("ImageLabel")
			TabImage.Name = "Tab_image"
			TabImage.Image = Page.Icon
			TabImage.ImageColor3 = Color3.fromRGB(41, 42, 45)
			TabImage.AnchorPoint = Vector2.new(0,0.5)
			TabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabImage.BackgroundTransparency = 1
			TabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabImage.BorderSizePixel = 0
			TabImage.Position = UDim2.new(0.0732, 0, 0.5, 0)
			TabImage.Size = UDim2.new(0, 20, 0, 20)
			TabImage.Parent = ATabActive
			
			local AccentImage = Library:NewInstance("ImageLabel", true)
			AccentImage.Name = "Tab_image"
			AccentImage.Image = Page.Icon
			AccentImage.AnchorPoint = Vector2.new(0,0.5)
			AccentImage.ImageColor3 = Library.Accent
			AccentImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			AccentImage.BackgroundTransparency = 1
			AccentImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			AccentImage.BorderSizePixel = 0
			AccentImage.Position = UDim2.new(0.0732, 0, 0.5, 0)
			AccentImage.Size = UDim2.new(0, 20, 0, 20)
			AccentImage.Parent = ATabActive

			local TabText = Instance.new("TextLabel")
			TabText.Name = "Tab_text"
			TabText.FontFace = Library.UIFont
			TabText.Text = Page.Name
			TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabText.TextSize = 11
			TabText.TextXAlignment = Enum.TextXAlignment.Left
			TabText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabText.BackgroundTransparency = 1
			TabText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabText.BorderSizePixel = 0
			TabText.Position = UDim2.new(0.179, 0, 0.5, 0)
			TabText.Size = UDim2.new(0, 134, 0, 22)
			TabText.AnchorPoint = Vector2.new(0,0.5)

			local UIPadding1 = Instance.new("UIPadding")
			UIPadding1.Name = "UIPadding"
			UIPadding1.PaddingLeft = UDim.new(0, 5)
			UIPadding1.Parent = TabText

			TabText.Parent = ATabActive

			local TabIndicator = Library:NewInstance("Frame", true)
			TabIndicator.Name = "Tab_indicator"
			TabIndicator.BackgroundColor3 = Library.Accent
			TabIndicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabIndicator.BorderSizePixel = 0
			TabIndicator.Position = UDim2.new(0.899, 0, 0.5, 0)
			TabIndicator.Size = UDim2.new(0, 4, 0, 23)
			TabIndicator.AnchorPoint = Vector2.new(0,0.5)

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner"
			UICorner2.CornerRadius = UDim.new(0, 99)
			UICorner2.Parent = TabIndicator

			TabIndicator.Parent = ATabActive

			ATabActive.Parent = Page.Window.Elements.TabHolder
			
			local SectionHolders = Instance.new("ScrollingFrame")
			SectionHolders.Name = "SectionHolders"
			SectionHolders.AutomaticCanvasSize = Enum.AutomaticSize.Y
			SectionHolders.CanvasSize = UDim2.new()
			SectionHolders.ScrollBarThickness = 0
			SectionHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionHolders.BackgroundTransparency = 1
			SectionHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHolders.BorderSizePixel = 0
			SectionHolders.Position = UDim2.new(0, 0, -0.166, 0)
			SectionHolders.Selectable = false
			SectionHolders.Size = UDim2.new(0, 503, 0, 501)
			SectionHolders.SelectionGroup = false
			SectionHolders.Visible = false

			local LeftSide = Instance.new("Frame")
			LeftSide.Name = "Left side"
			LeftSide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LeftSide.BackgroundTransparency = 1
			LeftSide.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LeftSide.BorderSizePixel = 0
			LeftSide.Position = UDim2.new(-0.000109, 0, 0, 0)
			LeftSide.Size = UDim2.new(0, 245, 0, 433)

			local UIListLayout1 = Instance.new("UIListLayout")
			UIListLayout1.Name = "UIListLayout"
			UIListLayout1.Padding = UDim.new(0, 6)
			UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout1.Parent = LeftSide
			
			LeftSide.Parent = SectionHolders

			local RightSide = Instance.new("Frame")
			RightSide.Name = "Right side"
			RightSide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RightSide.BackgroundTransparency = 1
			RightSide.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RightSide.BorderSizePixel = 0
			RightSide.Position = UDim2.new(0.511, 0, 0, 0)
			RightSide.Size = UDim2.new(0, 245, 0, 433)

			local UIListLayout4 = Instance.new("UIListLayout")
			UIListLayout4.Name = "UIListLayout"
			UIListLayout4.Padding = UDim.new(0, 6)
			UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout4.Parent = RightSide

			RightSide.Parent = SectionHolders

			SectionHolders.Parent = Page.Window.Elements.Holder

			function Page:Turn(bool)
				Page.Open = bool
				TweenService:Create(TabText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(71, 73, 80)}):Play()
				TweenService:Create(AccentImage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = Page.Open and 0 or 1}):Play()
				TweenService:Create(TabIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = Page.Open and 0 or 1}):Play()
				TweenService:Create(ATabActive, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = Page.Open and 0 or 1}):Play()
				--
				task.spawn(function()
					Page.Window.Elements.FadeThing.Visible = true
					TweenService:Create(Page.Window.Elements.FadeThing, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
					task.wait(0.1)
					SectionHolders.Visible = Page.Open
					TweenService:Create(Page.Window.Elements.FadeThing, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					task.wait(0.1)
					Page.Window.Elements.FadeThing.Visible = false
				end)
			end
			--
			Library:Connection(ATabActive.MouseButton1Down, function()
				if not Page.Open then
					for _, Pages in pairs(Page.Window.Pages) do
						if Pages.Open and Pages ~= Page then
							Pages:Turn(false)
						end
					end
					Page:Turn(true)
				end
			end)

			-- // Elements
			Page.Elements = {
				Left = LeftSide,
				Right = RightSide,
			}

			-- // Drawings
			if #Page.Window.Pages == 0 then
				Page:Turn(true)
			end
			Page.Window.Pages[#Page.Window.Pages + 1] = Page
			Page.Window:UpdateTabs()
			return setmetatable(Page, Library.Pages)
		end
		--
		function Pages:Section(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Section = {
				Name = Properties.Name or "Section",
				Page = self,
				Side = (Properties.side or Properties.Side or "left"):lower(),
				Zindex = (Properties.Zindex or Properties.zindex or 1),
				Elements = {},
				Content = {},
			}
			--
			local RealSection = Instance.new("TextButton")
			RealSection.Name = "Section"
			RealSection.AutomaticSize = Enum.AutomaticSize.Y
			RealSection.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
			RealSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealSection.BorderSizePixel = 0
			RealSection.Position = UDim2.new(0.00816, 0, 0.00231, 0)
			RealSection.Size = UDim2.new(0, 245, 0, 0)
			RealSection.ZIndex = -69
			RealSection.Parent = Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right
			RealSection.Text = ""
			RealSection.AutoButtonColor = false


			local UICorner3 = Instance.new("UICorner")
			UICorner3.Name = "UICorner"
			UICorner3.Parent = RealSection

			local UIListLayout2 = Instance.new("UIListLayout")
			UIListLayout2.Name = "UIListLayout"
			UIListLayout2.Padding = UDim.new(0, 6)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.Parent = RealSection

			local UIPadding2 = Instance.new("UIPadding")
			UIPadding2.Name = "UIPadding"
			UIPadding2.PaddingBottom = UDim.new(0, 5)
			UIPadding2.Parent = RealSection
			
			local SectionStartNameIcon = Instance.new("Frame")
			SectionStartNameIcon.Name = "Section_start(name+icon)"
			SectionStartNameIcon.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
			SectionStartNameIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionStartNameIcon.BorderSizePixel = 0
			SectionStartNameIcon.LayoutOrder = -100
			SectionStartNameIcon.Position = UDim2.new(0.0286, 0, 0.0694, 0)
			SectionStartNameIcon.Size = UDim2.new(0, 245, 0, 38)

			local UICorner10 = Instance.new("UICorner")
			UICorner10.Name = "UICorner"
			UICorner10.Parent = SectionStartNameIcon

			local Nouicorner = Instance.new("Frame")
			Nouicorner.Name = "nouicorner"
			Nouicorner.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
			Nouicorner.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Nouicorner.BorderSizePixel = 0
			Nouicorner.Position = UDim2.new(-0, 0, 0.532, 2)
			Nouicorner.Size = UDim2.new(1, 0, 0, 17)
			Nouicorner.ZIndex = 0
			Nouicorner.Parent = SectionStartNameIcon

			local SectionText = Instance.new("TextLabel")
			SectionText.Name = "Section_text"
			SectionText.FontFace = Library.UIFont
			SectionText.Text = Section.Name
			SectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionText.TextSize = 11
			SectionText.TextXAlignment = Enum.TextXAlignment.Left
			SectionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionText.BackgroundTransparency = 1
			SectionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionText.BorderSizePixel = 0
			SectionText.Position = UDim2.new(0.13, 0, 0.263, 0)
			SectionText.Size = UDim2.new(0, 134, 0, 18)

			local UIPadding7 = Instance.new("UIPadding")
			UIPadding7.Name = "UIPadding"
			UIPadding7.PaddingLeft = UDim.new(0, 5)
			UIPadding7.Parent = SectionText

			SectionText.Parent = SectionStartNameIcon

			local SectionImage = Library:NewInstance("ImageLabel", true)
			SectionImage.Name = "Section_image"
			SectionImage.Image = Section.Page.Icon
			SectionImage.ImageColor3 = Library.Accent
			SectionImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionImage.BackgroundTransparency = 1
			SectionImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionImage.BorderSizePixel = 0
			SectionImage.Position = UDim2.new(0.0406, 0, 0.182, 0)
			SectionImage.Size = UDim2.new(0, 22, 0, 22)
			SectionImage.Parent = SectionStartNameIcon

			local TheGrid = Instance.new("ImageLabel")
			TheGrid.Name = "the_grid"
			TheGrid.Image = "rbxassetid://16994393834"
			TheGrid.ImageColor3 = Color3.fromRGB(36, 36, 45)
			TheGrid.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TheGrid.BackgroundTransparency = 1
			TheGrid.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TheGrid.BorderSizePixel = 0
			TheGrid.Position = UDim2.new(0.873, 0, 0.184, 0)
			TheGrid.Size = UDim2.new(0, 22, 0, 22)
			TheGrid.Parent = SectionStartNameIcon

			SectionStartNameIcon.Parent = RealSection

			-- // Elements
			Section.Elements = {
				SectionContent = RealSection;
			}

			-- // Returning
			Section.Page.Sections[#Section.Page.Sections + 1] = Section
			return setmetatable(Section, Library.Sections)
		end
		--
		function Sections:Toggle(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Toggle",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or false
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Toggled = false,
			}
			--
			local RealToggle = Instance.new("TextButton")
			RealToggle.Name = "Toggle"
			RealToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealToggle.BackgroundTransparency = 1
			RealToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealToggle.BorderSizePixel = 0
			RealToggle.Position = UDim2.new(0, 0, 0.346, 0)
			RealToggle.Size = UDim2.new(1,0,0,26)
			RealToggle.Text = ""
			RealToggle.AutoButtonColor = false

			local ToggleText = Instance.new("TextLabel")
			ToggleText.Name = "Toggle_text"
			ToggleText.FontFace = Library.UIFont
			ToggleText.Text = Toggle.Name
			ToggleText.TextColor3 = Color3.fromRGB(46, 47, 52)
			ToggleText.TextSize = 11
			ToggleText.AnchorPoint = Vector2.new(0,0.5)
			ToggleText.TextXAlignment = Enum.TextXAlignment.Left
			ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleText.BackgroundTransparency = 1
			ToggleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleText.BorderSizePixel = 0
			ToggleText.Position = UDim2.new(0.0389, 0, 0.5, 0)
			ToggleText.Size = UDim2.new(0, 197, 0, 20)

			local UIPadding11 = Instance.new("UIPadding")
			UIPadding11.Name = "UIPadding"
			UIPadding11.PaddingLeft = UDim.new(0, 5)
			UIPadding11.Parent = ToggleText

			ToggleText.Parent = RealToggle

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "toggle_frame"
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(27, 28, 31)
			ToggleFrame.AnchorPoint = Vector2.new(0,0.5)
			ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Position = UDim2.new(1, -31,0.5, 0)
			ToggleFrame.Size = UDim2.new(0,20,0,20)

			local UICorner15 = Instance.new("UICorner")
			UICorner15.Name = "UICorner"
			UICorner15.CornerRadius = UDim.new(0, 2)
			UICorner15.Parent = ToggleFrame

            local AccentFrame = Library:NewInstance("Frame", true)
			AccentFrame.Name = "toggle_frame"
			AccentFrame.BackgroundColor3 = Library.Accent
            AccentFrame.BackgroundTransparency = 1
			AccentFrame.AnchorPoint = Vector2.new(0,0.5)
			AccentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			AccentFrame.BorderSizePixel = 0
			AccentFrame.Position = UDim2.new(1, -31,0.5, 0)
			AccentFrame.Size = UDim2.new(0,20,0,20)

			local UICorner15 = Instance.new("UICorner")
			UICorner15.Name = "UICorner"
			UICorner15.CornerRadius = UDim.new(0, 2)
			UICorner15.Parent = AccentFrame

			local ToggleCheckImage = Instance.new("ImageLabel")
			ToggleCheckImage.Name = "Toggle_check_image"
			ToggleCheckImage.Image = "rbxassetid://16994544635"
			ToggleCheckImage.ImageTransparency = 1
			ToggleCheckImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleCheckImage.BackgroundTransparency = 1
			ToggleCheckImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleCheckImage.BorderSizePixel = 0
			ToggleCheckImage.Position = UDim2.new(0.5, 0, 0.5, 0)
			ToggleCheckImage.Size = UDim2.new(0, 16, 0, 14)
			ToggleCheckImage.AnchorPoint = Vector2.new(0.5,0.5)
			ToggleCheckImage.Parent = AccentFrame

			ToggleFrame.Parent = RealToggle
            AccentFrame.Parent = RealToggle

			RealToggle.Parent = Toggle.Section.Elements.SectionContent

			function Toggle:Options(Properties)
				local Options = {
					Elements = {},
					Content = {},
				}
				--
				local ImageLabel = Instance.new("ImageButton")
				ImageLabel.Name = "ImageLabel"
				ImageLabel.Image = "rbxassetid://15847528907"
				ImageLabel.ImageColor3 = Color3.fromRGB(45, 46, 50)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ImageLabel.BorderSizePixel = 0
				ImageLabel.Position = UDim2.new(0.782, 0, 0.214, 0)
				ImageLabel.Size = UDim2.new(0, 17, 0, 17)
				ImageLabel.AutoButtonColor = false
				ImageLabel.Parent = RealToggle
				
				local SettingsOpened = Instance.new("Frame")
				SettingsOpened.Name = "settings opened"
				SettingsOpened.BackgroundColor3 = Color3.fromRGB(17, 19, 22)
				SettingsOpened.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SettingsOpened.BorderSizePixel = 0
				SettingsOpened.Position = UDim2.new(1, -179,0, 0)
				SettingsOpened.Size = UDim2.new(0, 169, 0, 0)
				SettingsOpened.ZIndex = 45
				SettingsOpened.AutomaticSize = Enum.AutomaticSize.Y
				SettingsOpened.Visible = false
				SettingsOpened.Parent = RealToggle
				SettingsOpened.BackgroundTransparency = 1

				local UIListLayout = Instance.new("UIListLayout")
				UIListLayout.Name = "UIListLayout"
				UIListLayout.Padding = UDim.new(0, 6)
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Parent = SettingsOpened

				local UICorner = Instance.new("UICorner")
				UICorner.Name = "UICorner"
				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = SettingsOpened

				local UIPadding = Instance.new("UIPadding")
				UIPadding.Name = "UIPadding"
				UIPadding.PaddingTop = UDim.new(0, 5)
				UIPadding.PaddingBottom = UDim.new(0, 5)
				UIPadding.Parent = SettingsOpened
				
				ImageLabel.MouseButton1Down:Connect(function()
					if SettingsOpened.Visible == false then
						TweenService:Create(SettingsOpened, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -179,1, 0)}):Play()
					end
					SettingsOpened.Visible = true
					RealToggle.ZIndex = 100
					TweenService:Create(SettingsOpened, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
					for _,V in next, SettingsOpened:GetDescendants() do
						if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
							TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Library.VisValues[V]}):Play()
						elseif V:IsA("TextLabel") or V:IsA("TextBox") then
							TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = Library.VisValues[V]}):Play()
						elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
							TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = Library.VisValues[V]}):Play();
						elseif V:IsA("UIStroke") and V.Transparency ~= 1 then
							TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = Library.VisValues[V]}):Play()
						end
					end
				end)
				
				Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
					if SettingsOpened.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library.Cooldown then
						if not Library:IsMouseOverFrame(SettingsOpened) and not Library:IsMouseOverFrame(RealToggle) then
							TweenService:Create(SettingsOpened, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							TweenService:Create(SettingsOpened, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1, -179,0, 0)}):Play()
							task.spawn(function()
								task.wait(0.1)
								SettingsOpened.Visible = false
								RealToggle.ZIndex = 1
							end)
							for _,V in next, SettingsOpened:GetDescendants() do
								if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
									TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
									Library.VisValues[V] = V.BackgroundTransparency
								elseif V:IsA("TextLabel") or V:IsA("TextBox") then
									TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
									Library.VisValues[V] = V.TextTransparency
								elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
									TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
									Library.VisValues[V] = V.ImageTransparency
								elseif V:IsA("UIStroke") and V.Transparency ~= 1 then
									TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
									Library.VisValues[V] = V.Transparency
								end
							end
						end
					end
				end)
				
				-- // Elements
				Options.Elements = {
					SectionContent = SettingsOpened;
				}

				-- // Returning
				Toggle.Page.Sections[#Toggle.Page.Sections + 1] = Options
				return setmetatable(Options, Library.Sections)
			end

			-- // Functions
			local function SetState()
				Toggle.Toggled = not Toggle.Toggled
				TweenService:Create(ToggleText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Toggle.Toggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(46, 47, 52)}):Play()
				TweenService:Create(AccentFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = Toggle.Toggled and 0 or 1}):Play()
				TweenService:Create(ToggleCheckImage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = Toggle.Toggled and 0 or 1}):Play()
				Library.Flags[Toggle.Flag] = Toggle.Toggled
				Toggle.Callback(Toggle.Toggled)
			end
			--
			Library:Connection(RealToggle.MouseButton1Down, SetState)

			-- // Misc Functions
			function Toggle.Set(bool)
				bool = type(bool) == "boolean" and bool or false
				if Toggle.Toggled ~= bool then
					SetState()
				end
			end
			Toggle.Set(Toggle.State)
			Library.Flags[Toggle.Flag] = Toggle.State
			Flags[Toggle.Flag] = Toggle.Set

			-- // Returning
			return Toggle
		end
		--
		function Sections:Slider(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or nil,
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or 1
				),
				Max = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100),
				Sub = (
					Properties.suffix
						or Properties.Suffix
						or Properties.ending
						or Properties.Ending
						or Properties.prefix
						or Properties.Prefix
						or Properties.measurement
						or Properties.Measurement
						or ""
				),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				)
			}
			local TextValue = ("[value]" .. Slider.Sub)
			--
			local RealSlider = Instance.new("Frame")
			RealSlider.Name = "Slider"
			RealSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealSlider.BackgroundTransparency = 1
			RealSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealSlider.BorderSizePixel = 0
			RealSlider.Position = UDim2.new(0, 0, 0.346, 0)
			RealSlider.Size = UDim2.new(1, 0, 0, 28)

			local SliderText = Instance.new("TextLabel")
			SliderText.Name = "Slider_text"
			SliderText.FontFace = Library.UIFont
			SliderText.Text = Slider.Name
			SliderText.TextColor3 = Color3.fromRGB(46, 47, 52)
			SliderText.TextSize = 12
			SliderText.TextWrapped = true
			SliderText.TextXAlignment = Enum.TextXAlignment.Left
			SliderText.AnchorPoint = Vector2.new(0, 0.5)
			SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderText.BackgroundTransparency = 1
			SliderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderText.BorderSizePixel = 0
			SliderText.Position = UDim2.new(0.039, 0, 0.5, 0)
			SliderText.Size = UDim2.new(0, 110, 0, 22)

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 5)
			UIPadding.Parent = SliderText

			SliderText.Parent = RealSlider

			local SliderBar = Instance.new("TextButton")
			SliderBar.Name = "Slider_bar"
			SliderBar.AnchorPoint = Vector2.new(0, 0.5)
			SliderBar.BackgroundColor3 = Color3.fromRGB(29, 29, 34)
			SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderBar.BorderSizePixel = 0
			SliderBar.Position = UDim2.new(1, -92, 0.5, 0)
			SliderBar.Size = UDim2.new(0, 82, 0, 4)
			SliderBar.Text = ""
			SliderBar.AutoButtonColor = false

			local SliderIndicator = Library:NewInstance("TextButton", true)
			SliderIndicator.Name = "slider_indicator"
			SliderIndicator.BackgroundColor3 = Library.Accent
			SliderIndicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderIndicator.BorderSizePixel = 0
			SliderIndicator.Size = UDim2.new(-0.668, 100, 1, 0)
			SliderIndicator.Text = ""
			SliderIndicator.AutoButtonColor = false

			local Indicator = Library:NewInstance("TextButton", true)
			Indicator.Name = "Indicator"
			Indicator.AnchorPoint = Vector2.new(0, 0.5)
			Indicator.BackgroundColor3 = Library.Accent
			Indicator.BorderSizePixel = 0
			Indicator.Position = UDim2.new(1, -6, 0.5, 0)
			Indicator.Size = UDim2.new(0, 12, 0, 12)
			Indicator.Text = ""
			Indicator.AutoButtonColor = false

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(1, 0)
			UICorner.Parent = Indicator

			Indicator.Parent = SliderIndicator

			local UICorner1 = Instance.new("UICorner")
			UICorner1.Name = "UICorner"
			UICorner1.Parent = SliderIndicator

			SliderIndicator.Parent = SliderBar

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner"
			UICorner2.Parent = SliderBar

			SliderBar.Parent = RealSlider

			local SliderValue = Instance.new("TextBox")
			SliderValue.Name = "Slider_value"
			SliderValue.FontFace = Library.UIFont
			SliderValue.Text = "100.00"
			SliderValue.TextColor3 = Color3.fromRGB(226, 231, 255)
			SliderValue.TextSize = 10
			SliderValue.TextWrapped = true
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.AnchorPoint = Vector2.new(0, 0.5)
			SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.BackgroundTransparency = 1
			SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderValue.BorderSizePixel = 0
			SliderValue.Position = UDim2.new(0.45, -6, 0.5, 0)
			SliderValue.Size = UDim2.new(0, 42, 0, 22)
			SliderValue.PlaceholderText = ""
			SliderValue.ClearTextOnFocus = false

			local UIPadding1 = Instance.new("UIPadding")
			UIPadding1.Name = "UIPadding"
			UIPadding1.PaddingLeft = UDim.new(0, 5)
			UIPadding1.Parent = SliderValue

			SliderValue.Parent = RealSlider
			
			RealSlider.Parent = Slider.Section.Elements.SectionContent

			-- // Functions
			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				TweenService:Create(SliderIndicator, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
				SliderValue.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
				Val = value

				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end				
			--
			local function SlideInp(input)
				local sizeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end
			--
			Library:Connection(SliderIndicator.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					SlideInp(input)
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				end
			end)
			Library:Connection(SliderIndicator.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
				end
			end)
			Library:Connection(SliderBar.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					SlideInp(input)
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				end
			end)
			Library:Connection(SliderBar.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
				end
			end)
			Library:Connection(Indicator.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					SlideInp(input)
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				end
			end)
			Library:Connection(Indicator.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
					TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if Sliding then
						SlideInp(input)
						TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
					end
				end
			end)
			--
			SliderValue.Focused:Connect(function()
				TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			end)
			SliderValue.FocusLost:Connect(function(txt)
				local NewV = tonumber(SliderValue.Text)
				if NewV then
					Set(NewV)
				end
				TweenService:Create(SliderText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
			end)
			--
			function Slider:Set(Value)
				Set(Value)
			end
			--
			Flags[Slider.Flag] = Set
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			-- // Returning
			return Slider
		end
		--
		function Sections:List(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
					"1",
					"2",
					"3",
				}),
				Max = (Properties.Max or Properties.max or nil),
				ScrollMax = (Properties.ScrollingMax or Properties.scrollingmax or nil),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or nil
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				OptionInsts = {},
			}
			--
			local RealDropdown = Instance.new("Frame")
			RealDropdown.Name = "Dropdown"
			RealDropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealDropdown.BackgroundTransparency = 1
			RealDropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealDropdown.BorderSizePixel = 0
			RealDropdown.Position = UDim2.new(0, 0, 0.346, 0)
			RealDropdown.Size = UDim2.new(1, 0, 0, 28)
            RealDropdown.ZIndex = 6812

			local DropdownText = Instance.new("TextLabel")
			DropdownText.Name = "Dropdown_text"
			DropdownText.FontFace = Library.UIFont
			DropdownText.Text = Dropdown.Name
			DropdownText.TextColor3 = Color3.fromRGB(46, 47, 52)
			DropdownText.TextSize = 12
			DropdownText.TextWrapped = true
			DropdownText.TextXAlignment = Enum.TextXAlignment.Left
			DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownText.BackgroundTransparency = 1
			DropdownText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownText.BorderSizePixel = 0
			DropdownText.Position = UDim2.new(0.0389, 0, 0.0606, 0)
			DropdownText.Size = UDim2.new(0, 120, 0, 22)

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 5)
			UIPadding.Parent = DropdownText

			DropdownText.Parent = RealDropdown

			local DropdownFrame = Instance.new("TextButton")
			DropdownFrame.Name = "Dropdown_frame"
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 110, 7)
			DropdownFrame.BackgroundTransparency = 1
			DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.Position = UDim2.new(1, -94, 0.118, 0)
			DropdownFrame.Size = UDim2.new(0, 84, 0, 20)
			DropdownFrame.Text = ""
			DropdownFrame.AutoButtonColor = false

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = DropdownFrame

			local Currentoption = Instance.new("TextLabel")
			Currentoption.Name = "Currentoption"
			Currentoption.FontFace = Library.UIFont
			Currentoption.Text = "Select"
			Currentoption.TextColor3 = Color3.fromRGB(255, 255, 255)
			Currentoption.TextXAlignment = Enum.TextXAlignment.Right
			Currentoption.TextSize = 11
			Currentoption.TextWrapped = true
			Currentoption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Currentoption.BackgroundTransparency = 1
			Currentoption.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Currentoption.BorderSizePixel = 0
			Currentoption.Position = UDim2.new(0.00956, 0, 0, 0)
			Currentoption.Size = UDim2.new(0, 61, 0, 20)
			Currentoption.Parent = DropdownFrame

			local DropdownArrowIcom = Library:NewInstance("ImageLabel", true)
			DropdownArrowIcom.Name = "Dropdown_arrow_icom"
			DropdownArrowIcom.Image = "rbxassetid://16995924859"
			DropdownArrowIcom.ImageColor3 = Library.Accent
			DropdownArrowIcom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownArrowIcom.BackgroundTransparency = 1
			DropdownArrowIcom.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownArrowIcom.BorderSizePixel = 0
			DropdownArrowIcom.Position = UDim2.new(0.8, 0, 0.15, 0)
			DropdownArrowIcom.Size = UDim2.new(0, 11, 0, 11)
			DropdownArrowIcom.Parent = DropdownFrame

			local DropdownOpenedFrame = Instance.new("ScrollingFrame")
			DropdownOpenedFrame.Name = "DropdownOpenedFrame"
			DropdownOpenedFrame.AutomaticSize = Enum.AutomaticSize.Y
			DropdownOpenedFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			DropdownOpenedFrame.CanvasSize = UDim2.new()
			DropdownOpenedFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
			DropdownOpenedFrame.ScrollBarImageTransparency = 1
			DropdownOpenedFrame.ScrollBarThickness = 0
			DropdownOpenedFrame.Active = true
			DropdownOpenedFrame.BackgroundColor3 = Color3.fromRGB(13, 15, 16)
			DropdownOpenedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownOpenedFrame.BorderSizePixel = 0
			DropdownOpenedFrame.Position = UDim2.new(-0.008, 0, -0.5, 0)
			DropdownOpenedFrame.Size = UDim2.new(0, 94, 0, 0)
			DropdownOpenedFrame.AnchorPoint = Vector2.new(0,0.5)
			DropdownOpenedFrame.Visible = false
			DropdownOpenedFrame.BackgroundTransparency = 1
            DropdownOpenedFrame.ZIndex = 51395139

			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Name = "UIListLayout"
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = DropdownOpenedFrame

			local UIPadding3 = Instance.new("UIPadding")
			UIPadding3.Name = "UIPadding"
			UIPadding3.PaddingBottom = UDim.new(0, 5)
			UIPadding3.PaddingTop = UDim.new(0, 5)
			UIPadding3.Parent = DropdownOpenedFrame

			DropdownOpenedFrame.Parent = DropdownFrame

			DropdownFrame.Parent = RealDropdown
			
			RealDropdown.Parent = Dropdown.Section.Elements.SectionContent

			-- // Connections
			Library:Connection(DropdownFrame.MouseButton1Down, function()
				if DropdownOpenedFrame.Visible == false then
					TweenService:Create(DropdownOpenedFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-0.008, 0, 0.5, 0)}):Play()
				end
				DropdownOpenedFrame.Visible = true
				Library.Cooldown = true
				TweenService:Create(DropdownText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				RealDropdown.ZIndex = 5943
				TweenService:Create(DropdownOpenedFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				for _,V in next, DropdownOpenedFrame:GetDescendants() do
					if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("TextLabel") or V:IsA("TextBox") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = Library.VisValues[V]}):Play();
					elseif V:IsA("UIStroke") and V.Transparency ~= 1 then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = Library.VisValues[V]}):Play()
					end
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if DropdownOpenedFrame.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(DropdownOpenedFrame) and not Library:IsMouseOverFrame(RealDropdown) then
						RealDropdown.ZIndex = 56
						TweenService:Create(DropdownText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
						TweenService:Create(DropdownOpenedFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						TweenService:Create(DropdownOpenedFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(-0.008, 0, -0.5, 0)}):Play()
						task.spawn(function()
							task.wait(0.1)
							DropdownOpenedFrame.Visible = false
							DropdownOpenedFrame.ZIndex = 531985
						end)
						for _,V in next, DropdownOpenedFrame:GetDescendants() do
							if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
								Library.VisValues[V] = V.BackgroundTransparency
							elseif V:IsA("TextLabel") or V:IsA("TextBox") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
								Library.VisValues[V] = V.TextTransparency
							elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
								Library.VisValues[V] = V.ImageTransparency
							elseif V:IsA("UIStroke") and V.Transparency ~= 1 then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
								Library.VisValues[V] = V.Transparency
							end
						end
						Library.Cooldown = false
					end
				end
			end)
			--
			local chosen = Dropdown.Max and {} or nil
			local Count = 0
			--
			local function handleoptionclick(option, button, text, accent, darktext)
				button.MouseButton1Down:Connect(function()
					if Dropdown.Max then
						if table.find(chosen, option) then
							table.remove(chosen, table.find(chosen, option))

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end
							
							Currentoption.Text = #chosen == 0 and "Select" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							TweenService:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							TweenService:Create(darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							TweenService:Create(accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						else
							if #chosen == Dropdown.Max then
								TweenService:Create(Dropdown.OptionInsts[chosen[1]].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
								TweenService:Create(Dropdown.OptionInsts[chosen[1]].darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
								TweenService:Create(Dropdown.OptionInsts[chosen[1]].accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
								table.remove(chosen, 1)
							end

							table.insert(chosen, option)

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end
							
							Currentoption.Text = #chosen == 0 and "Select" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							TweenService:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							TweenService:Create(darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							TweenService:Create(accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						end
					else
						for opt, tbl in next, Dropdown.OptionInsts do
							if opt ~= option then
								TweenService:Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
								TweenService:Create(tbl.darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
								TweenService:Create(tbl.accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							end
						end
						chosen = option
						Currentoption.Text = chosen
						TweenService:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
						TweenService:Create(darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
						TweenService:Create(accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
						Library.Flags[Dropdown.Flag] = option
						Dropdown.Callback(option)
					end
				end)
			end
			--
			local function createoptions(tbl)
				for _, option in next, tbl do
					Dropdown.OptionInsts[option] = {}
					local Option1Choosed = Instance.new("TextButton")
					Option1Choosed.Name = "option1_choosed"
					Option1Choosed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Option1Choosed.BackgroundTransparency = 1
					Option1Choosed.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Option1Choosed.BorderSizePixel = 0
					Option1Choosed.Size = UDim2.new(1,0, 0, 22)
					Option1Choosed.Text = ""
					Option1Choosed.AutoButtonColor = false

					local OptionName = Instance.new("TextLabel")
					OptionName.Name = "Option_name"
					OptionName.FontFace = Library.UIFont
					OptionName.Text = option
					OptionName.TextColor3 = Color3.fromRGB(255,255,255)
					OptionName.AnchorPoint = Vector2.new(0.5,0.5)
					OptionName.Position = UDim2.new(0.5, -8,0.5, -1)
					OptionName.TextSize = 11
					OptionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionName.BackgroundTransparency = 1
					OptionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionName.BorderSizePixel = 0
					OptionName.Size = UDim2.new(0, 70, 0, 22)
					OptionName.TextWrapped = true
					
					local OptionNameAccent = Library:NewInstance("TextLabel", true)
					OptionNameAccent.Name = "Option_name"
					OptionNameAccent.FontFace = Library.UIFont
					OptionNameAccent.Text = option
					OptionNameAccent.TextColor3 = Library.Accent
					OptionNameAccent.AnchorPoint = Vector2.new(0.5,0.5)
					OptionNameAccent.Position = UDim2.new(0.5, -8,0.5, -1)
					OptionNameAccent.TextSize = 11
					OptionNameAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionNameAccent.BackgroundTransparency = 1
					OptionNameAccent.TextTransparency = 1
					OptionNameAccent.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionNameAccent.BorderSizePixel = 0
					OptionNameAccent.Size = UDim2.new(0, 70, 0, 22)
					OptionNameAccent.TextWrapped = true

					local UIPadding1 = Instance.new("UIPadding")
					UIPadding1.Name = "UIPadding"
					UIPadding1.PaddingTop = UDim.new(0, 2)
					UIPadding1.Parent = OptionName

					OptionName.Parent = Option1Choosed
					OptionNameAccent.Parent = Option1Choosed

					local OptionIndicator = Instance.new("Frame")
					OptionIndicator.Name = "option_indicator"
					OptionIndicator.BackgroundColor3 = Color3.fromRGB(41, 42, 47)
					OptionIndicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionIndicator.BorderSizePixel = 0
					OptionIndicator.Position = UDim2.new(0.911, 0, 0.5, 0)
					OptionIndicator.Size = UDim2.new(0, 4, 0, 14)
					OptionIndicator.AnchorPoint = Vector2.new(0,0.5)
					
					local AccentIndicator = Library:NewInstance("Frame", true)
					AccentIndicator.Name = "option_indicator"
					AccentIndicator.BackgroundColor3 = Library.Accent
					AccentIndicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
					AccentIndicator.BorderSizePixel = 0
					AccentIndicator.Position = UDim2.new(0.911, 0, 0.5, 0)
					AccentIndicator.Size = UDim2.new(0, 4, 0, 14)
					AccentIndicator.AnchorPoint = Vector2.new(0,0.5)
					AccentIndicator.BackgroundTransparency = 1

					local UICorner1 = Instance.new("UICorner")
					UICorner1.Name = "UICorner"
					UICorner1.CornerRadius = UDim.new(0, 99)
					UICorner1.Parent = OptionIndicator
					
					local UICorner2 = Instance.new("UICorner")
					UICorner2.Name = "UICorner"
					UICorner2.CornerRadius = UDim.new(0, 99)
					UICorner2.Parent = AccentIndicator

					OptionIndicator.Parent = Option1Choosed
					AccentIndicator.Parent = Option1Choosed

					Option1Choosed.Parent = DropdownOpenedFrame
					Dropdown.OptionInsts[option].button = Option1Choosed
					Dropdown.OptionInsts[option].darktext = OptionName
					Dropdown.OptionInsts[option].text = OptionNameAccent
					Dropdown.OptionInsts[option].accent = AccentIndicator

					Count = Count + 1

					if Dropdown.ScrollMax then
						DropdownOpenedFrame.AutomaticSize = Enum.AutomaticSize.None
						if Count < Dropdown.ScrollMax then
						else
							DropdownOpenedFrame.Size = UDim2.new(0, 84, 0, 22*Dropdown.ScrollMax)
						end
					else
						DropdownOpenedFrame.AutomaticSize = Enum.AutomaticSize.Y
					end
					handleoptionclick(option, Option1Choosed, OptionNameAccent, AccentIndicator, OptionName)
				end
			end
			createoptions(Dropdown.Options)
			--
			local set = function(option)
				if Dropdown.Max then
					table.clear(chosen)
					option = type(option) == "table" and option or {}

					for opt, tbl in next, Dropdown.OptionInsts do
						if not table.find(option, opt) then
							TweenService:Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							TweenService:Create(tbl.darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							TweenService:Create(tbl.accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						end
					end

					for i, opt in next, option do
						if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
                            table.insert(chosen, opt)
							TweenService:Create(Dropdown.OptionInsts[opt].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							TweenService:Create(Dropdown.OptionInsts[opt].darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							TweenService:Create(Dropdown.OptionInsts[opt].accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						end
					end

					local textchosen = {}
					local cutobject = false

					for _, opt in next, chosen do
						table.insert(textchosen, opt)
					end
					
					Currentoption.Text = #chosen == 0 and "Select" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")
					
					Library.Flags[Dropdown.Flag] = chosen
					Dropdown.Callback(chosen)
				end
			end
			--
			function Dropdown:Set(option)
				if Dropdown.Max then
					set(option)
				else
					for opt, tbl in next, Dropdown.OptionInsts do
						if opt ~= option then
							TweenService:Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							TweenService:Create(tbl.darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
							TweenService:Create(tbl.accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						end
					end
					if table.find(Dropdown.Options, option) then
						chosen = option
						Currentoption.Text = chosen
						TweenService:Create(Dropdown.OptionInsts[option].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
						TweenService:Create(Dropdown.OptionInsts[option].darktext, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
						TweenService:Create(Dropdown.OptionInsts[option].accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					else
						Currentoption.Text = "Select"
						chosen = nil
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					end
				end
			end
			--
			function Dropdown:Refresh(tbl)
				for _, opt in next, Dropdown.OptionInsts do
					coroutine.wrap(function()
						opt.text:Destroy()
                        opt.button:Destroy()
					end)()
				end
				table.clear(Dropdown.OptionInsts)

				createoptions(tbl)

				if Dropdown.Max then
					table.clear(chosen)
				else
					chosen = nil
				end

				Library.Flags[Dropdown.Flag] = chosen
				Dropdown.Callback(chosen)
			end

			-- // Returning
			if Dropdown.Max then
				Flags[Dropdown.Flag] = set
			else
				Flags[Dropdown.Flag] = Dropdown
			end
			Dropdown:Set(Dropdown.State)
			return Dropdown
		end
		--
		function Sections:Keybind(Properties)
			local Properties = Properties or {}
			local Keybind = {
				Section = self,
				Name = Properties.name or Properties.Name or "Keybind",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Enum.KeyCode.E
				),
				Mode = (Properties.mode or Properties.Mode or "Toggle"),
				UseKey = (Properties.UseKey or false),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Binding = nil,
			}
			local Key
			local State = false
            local c = nil
			--
			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Name = "Keybind_frame"
			KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindFrame.BackgroundTransparency = 1
			KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Position = UDim2.new(0, 0, 0.846, 0)
			KeybindFrame.Size = UDim2.new(1, 0, 0, 26)

			local KeybindName = Instance.new("TextLabel")
			KeybindName.Name = "Keybind_name"
			KeybindName.FontFace = Library.UIFont
			KeybindName.Text = Keybind.Name
			KeybindName.TextColor3 = Color3.fromRGB(46, 47, 52)
			KeybindName.TextSize = 13
			KeybindName.TextXAlignment = Enum.TextXAlignment.Left
			KeybindName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindName.BackgroundTransparency = 1
			KeybindName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindName.BorderSizePixel = 0
			KeybindName.Position = UDim2.new(0, 11, 0, 0)
			KeybindName.Size = UDim2.new(0, 120, 0, 26)
			KeybindName.Parent = KeybindFrame

			local KeybindHolder = Instance.new("Frame")
			KeybindHolder.Name = "Keybind_holder"
			KeybindHolder.AnchorPoint = Vector2.new(0, 0.5)
			KeybindHolder.BackgroundColor3 = Color3.fromRGB(13, 15, 16)
			KeybindHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindHolder.BorderSizePixel = 0
			KeybindHolder.Position = UDim2.new(1, -53, 0.5, 0)
			KeybindHolder.Size = UDim2.new(0, 43, 0, 20)

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = KeybindHolder

			local KeybindDetector = Instance.new("TextButton")
			KeybindDetector.Name = "Keybind_detector"
			KeybindDetector.FontFace = Library.UIFont
			KeybindDetector.Text = "None"
			KeybindDetector.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindDetector.TextSize = 11
			KeybindDetector.TextWrapped = true
			KeybindDetector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindDetector.BackgroundTransparency = 1
			KeybindDetector.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindDetector.BorderSizePixel = 0
			KeybindDetector.Size = UDim2.new(0, 43, 0, 20)
			KeybindDetector.Parent = KeybindHolder

			KeybindHolder.Parent = KeybindFrame
			
			KeybindFrame.Parent = Keybind.Section.Elements.SectionContent

			-- // Functions
			local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = false
						end
						Keybind.Callback(false)
					end
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = "None"

						KeybindDetector.Text = text
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))

						KeybindDetector.Text = text
					end

					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
					if not Keybind.UseKey then
						Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
						Keybind.Mode = newkey
						if Keybind.Mode == "Always" then
							State = true
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(true)
						end
					end
				else
					State = newkey
					if Keybind.Flag then
						Library.Flags[Keybind.Flag] = newkey
					end
					Keybind.Callback(newkey)
				end
			end
			--
			set(Keybind.State)
			set(Keybind.Mode)
			KeybindDetector.MouseButton1Click:Connect(function()
				if not Keybind.Binding then

					KeybindDetector.Text = "..."
					TweenService:Create(KeybindName, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()


					Keybind.Binding = Library:Connection(
						game:GetService("UserInputService").InputBegan,
						function(input, gpe)
							set(
								input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
									or input.UserInputType
							)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
							TweenService:Create(KeybindName, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(46, 47, 52)}):Play()
						end
					)
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(inp)
				if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
					if Keybind.Mode == "Hold" then
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = true
						end
						c = Library:Connection(game:GetService("RunService").RenderStepped, function()
							if Keybind.Callback then
								Keybind.Callback(true)
							end
						end)
					elseif Keybind.Mode == "Toggle" then
						State = not State
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = State
						end
						Keybind.Callback(State)
					end
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputEnded, function(inp)
				if Keybind.Mode == "Hold" and not Keybind.UseKey then
					if Key ~= "" or Key ~= nil then
						if inp.KeyCode == Key or inp.UserInputType == Key then
							if c then
								c:Disconnect()
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = false
								end
								if Keybind.Callback then
									Keybind.Callback(false)
								end
							end
						end
					end
				end
			end)
			--
			Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
			Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
			Flags[Keybind.Flag] = set
			Flags[Keybind.Flag .. "_KEY"] = set
			Flags[Keybind.Flag .. "_KEY STATE"] = set
			--
			function Keybind:Set(key)
				set(key)
			end

			-- // Returning
			return Keybind
		end
		--
		function Sections:Colorpicker(Properties)
			local Properties = Properties or {}
			local Colorpicker = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or "Colorpicker"),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Color3.fromRGB(255, 0, 0)
				),
				Alpha = (
					Properties.alpha
						or Properties.Alpha
						or Properties.transparency
						or Properties.Transparency
						or 1
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Colorpickers = 0,
			}
			--
			local RealColorpicker = Instance.new("Frame")
			RealColorpicker.Name = "Colorpicker"
			RealColorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealColorpicker.BackgroundTransparency = 1
			RealColorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealColorpicker.BorderSizePixel = 0
			RealColorpicker.Position = UDim2.new(0, 0, 0.346, 0)
			RealColorpicker.Size = UDim2.new(1, 0, 0, 28)

			local ColorpickerText = Instance.new("TextLabel")
			ColorpickerText.Name = "Colorpicker_text"
			ColorpickerText.FontFace = Library.UIFont
			ColorpickerText.Text = Colorpicker.Name
			ColorpickerText.TextColor3 = Color3.fromRGB(46, 47, 52)
			ColorpickerText.TextSize = 12
			ColorpickerText.TextWrapped = true
			ColorpickerText.TextXAlignment = Enum.TextXAlignment.Left
			ColorpickerText.AnchorPoint = Vector2.new(0, 0.5)
			ColorpickerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ColorpickerText.BackgroundTransparency = 1
			ColorpickerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ColorpickerText.BorderSizePixel = 0
			ColorpickerText.Position = UDim2.new(0.039, 0, 0.5, 0)
			ColorpickerText.Size = UDim2.new(0, 197, 0, 22)

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 5)
			UIPadding.Parent = ColorpickerText

			ColorpickerText.Parent = RealColorpicker
			
			RealColorpicker.Parent = Colorpicker.Section.Elements.SectionContent

			-- // Functions
			Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
			local colorpickertypes = Library:NewPicker(
				Colorpicker.Name,
				Colorpicker.State,
				Colorpicker.Alpha,
				RealColorpicker,
				Colorpicker.Colorpickers,
				Colorpicker.Flag,
				Colorpicker.Callback
			)

			function Colorpicker:Set(color)
				colorpickertypes:Set(color, false, true)
			end

			function Colorpicker:Colorpicker(Properties)
				local Properties = Properties or {}
				local NewColorpicker = {
					State = (
						Properties.state
							or Properties.State
							or Properties.def
							or Properties.Def
							or Properties.default
							or Properties.Default
							or Color3.fromRGB(255, 0, 0)
					),
					Alpha = (
						Properties.alpha
							or Properties.Alpha
							or Properties.transparency
							or Properties.Transparency
							or 1
					),
					Callback = (
						Properties.callback
							or Properties.Callback
							or Properties.callBack
							or Properties.CallBack
							or function() end
					),
					Flag = (
						Properties.flag
							or Properties.Flag
							or Properties.pointer
							or Properties.Pointer
							or Library.NextFlag()
					),
				}
				-- // Functions
				Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
				local Newcolorpickertypes = Library:NewPicker(
					"",
					NewColorpicker.State,
					NewColorpicker.Alpha,
					RealColorpicker,
					Colorpicker.Colorpickers,
					NewColorpicker.Flag,
					NewColorpicker.Callback
				)

				function NewColorpicker:Set(color)
					Newcolorpickertypes:Set(color)
				end

				-- // Returning
				return NewColorpicker
			end

			-- // Returning
			return Colorpicker
		end
		--
		function Sections:Textbox(Properties)
			local Properties = Properties or {}
			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or Properties.name or "textbox"),
				Placeholder = (
					Properties.placeholder
						or Properties.Placeholder
						or Properties.holder
						or Properties.Holder
						or "Enter your text here"
				),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or ""
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
			}
			--
			local RealTextbox = Instance.new("Frame")
			RealTextbox.Name = "Textbox"
			RealTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealTextbox.BackgroundTransparency = 1
			RealTextbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealTextbox.BorderSizePixel = 0
			RealTextbox.Position = UDim2.new(0, 0, 0.881, 0)
			RealTextbox.Size = UDim2.new(0, 210, 0, 28)

			local TextBox = Instance.new("TextBox")
			TextBox.Name = "TextBox"
			TextBox.FontFace = Library.UIFont
			TextBox.PlaceholderColor3 = Color3.fromRGB(99, 101, 112)
			TextBox.PlaceholderText = Textbox.Placeholder
			TextBox.Text = Textbox.State
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 11
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0.081, 0, -0.0714, 0)
			TextBox.Size = UDim2.new(0, 210, 0, 28)
			TextBox.ClearTextOnFocus = false

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 12)
			UIPadding.Parent = TextBox

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = TextBox

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Name = "UIStroke"
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Color = Color3.fromRGB(118, 111, 170)
			UIStroke.Enabled = false
			UIStroke.Parent = TextBox

			TextBox.Parent = RealTextbox
			RealTextbox.Parent = Textbox.Section.Elements.SectionContent
			--
			TextBox.FocusLost:Connect(function()
				Textbox.Callback(TextBox.Text)
				Library.Flags[Textbox.Flag] = TextBox.Text
			end)
			--
			local function set(str)
				TextBox.Text = str
				Library.Flags[Textbox.Flag] = str
				Textbox.Callback(str)
			end

			-- // Return
			Flags[Textbox.Flag] = set
			return Textbox
		end
		--
		function Sections:Button(Properties)
			local Properties = Properties or {}
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "button",
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
			}
			--
			local RealButton = Instance.new("Frame")
			RealButton.Name = "Button"
			RealButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			RealButton.BackgroundTransparency = 1
			RealButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			RealButton.BorderSizePixel = 0
			RealButton.Position = UDim2.new(0, 0, 0.881, 0)
			RealButton.Size = UDim2.new(1, 0, 0, 32)

			local ButtonBasically = Instance.new("TextButton")
			ButtonBasically.Name = "Button_basically"
			ButtonBasically.FontFace = Library.UIFont
			ButtonBasically.Text = Button.Name
			ButtonBasically.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonBasically.TextSize = 11
			ButtonBasically.AutoButtonColor = false
			ButtonBasically.AnchorPoint = Vector2.new(0.5, 0.5)
			ButtonBasically.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
			ButtonBasically.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonBasically.BorderSizePixel = 0
			ButtonBasically.Position = UDim2.new(0.5, 0, 0.5, 0)
			ButtonBasically.Size = UDim2.new(0, 224, 0, 28)

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = ButtonBasically

			ButtonBasically.Parent = RealButton
			
			RealButton.Parent = Button.Section.Elements.SectionContent
			--
			Library:Connection(ButtonBasically.MouseButton1Down, function()
				Button.Callback()
				TweenService:Create(ButtonBasically, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Accent}):Play()
				task.spawn(function()
					task.wait(0.1)
					TweenService:Create(ButtonBasically, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				end)
			end)
		end
		--
	end;
end;

local function getRemote()
    local gameinfo = Games[game.PlaceId]
    return ReplicatedStorage:FindFirstChild(gameinfo.Remote)
end

local function getArg()
    local gameinfo = Games[game.PlaceId]
    return gameinfo.Arg
end

local function GetClosestPlayer(distance)
    local Distance, Player = distance

    for _, v in pairs(Players:GetPlayers()) do
        if (v == LocalPlayer) then continue end

        local Character = v.Character
        local RootPart  = Character and Character:FindFirstChild('HumanoidRootPart')

        if (not RootPart) then continue end

        local Position, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        local Magnitude = (Vector2.new(Position.X, Position.Y) - UserInputService:GetMouseLocation()).Magnitude

        if Magnitude > Distance then continue end

        if OnScreen then
            Distance = Magnitude
            Player = v
        end
    end

    return Player
end

local function GetClosestPlayer2()
    local Distance, Player = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if (v == LocalPlayer) then continue end

        local Character = v.Character
        local RootPart  = Character and Character:FindFirstChild('HumanoidRootPart')

        if (not RootPart) then continue end

        local Position, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        local Magnitude = (Vector2.new(Position.X, Position.Y) - UserInputService:GetMouseLocation()).Magnitude

        if Magnitude > Distance then continue end

        if OnScreen then
            Distance = Magnitude
            Player = v
        end
    end

    return Player
end

local WTS = function(Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end
    
local IsOnScreen = function(Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end
    
local FilterObjs = function(Object)
    if string.find(Object.Name, "Gun") then
      return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
      return true
    end
end

local function isValidTarget(player)
    if Configurations.SilentAim.Checks.Wall then
        local screenPos, isVisible = Camera:WorldToViewportPoint(player.Character[Configurations.SilentAim.Aimpart].Position)
        if not isVisible then
            return false
        end
    end
    
    if Configurations.SilentAim.Checks.Friend and player:IsFriendsWith(LocalPlayer.UserId) then
        return false
    end
    
    
    if Configurations.SilentAim.Checks.Knocked then
        local hasBodyEffects = player.Character:FindFirstChild("BodyEffects")
        local isDead = hasBodyEffects and hasBodyEffects:FindFirstChild("K.O")
        if isDead then
            return false
        end
    end
    
    if Configurations.SilentAim.Checks.Grabbed then
        local hasGrabbingConstraint = player.Character:FindFirstChild("GRABBING_CONSTRAINT")
        if hasGrabbingConstraint then
            return false
        end
    end
    
    return true
end

local function isValidTarget2(player)
    if Configurations.TargetAim.Checks.Wall then
        local screenPos, isVisible = Camera:WorldToViewportPoint(player.Character[Configurations.SilentAim.Aimpart].Position)
        if not isVisible then
            return false
        end
    end
    
    if Configurations.TargetAim.Checks.Friend and player:IsFriendsWith(LocalPlayer.UserId) then
        return false
    end
    
    
    if Configurations.TargetAim.Checks.Knocked then
        local hasBodyEffects = player.Character:FindFirstChild("BodyEffects")
        local isDead = hasBodyEffects and hasBodyEffects:FindFirstChild("K.O")
        if isDead then
            return false
        end
    end
    
    if Configurations.TargetAim.Checks.Grabbed then
        local hasGrabbingConstraint = player.Character:FindFirstChild("GRABBING_CONSTRAINT")
        if hasGrabbingConstraint then
            return false
        end
    end
    
    return true
end

local function getPlayerInformation(Player)
    local Object = Player.Character
    local Humanoid = (Object and Object:FindFirstChildOfClass("Humanoid"))
    local RootPart = (Humanoid and Humanoid.RootPart)
    --
    return Object, Humanoid, RootPart
end

local GetClosestBodyPart = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

local Window = Library:Window({
    Name = "lumina.cc"
})

local Pages = {
    ["Aiming"] = Window:Page({Name = "Aiming", Icon = "rbxassetid://6034509987"});
    ["Renders"] = Window:Page({Name = "Visuals", Icon = "rbxassetid://6031079158"});
    ["Misc"] = Window:Page({Name = "Misc", Icon = "rbxassetid://6031280883"});
    ["Settings"] = Window:Page({Name = "Settings"})
} 

local Sections = {
    ["Silent Aim"] = Pages["Aiming"]:Section({Name = "Bullet Redirection"}),
    ["Field Of View"] = Pages["Aiming"]:Section({Name = "Field Of View"}),
    ["Silent Visuals"] = Pages["Aiming"]:Section({Name = "Visuals"}),
    ["Silent Checks"] = Pages["Aiming"]:Section({Name = "Checks"}),

    ["Target Aim"] = Pages["Aiming"]:Section({Name = "Target Aim", Side = "Right"}),
    ["Target Visuals"] = Pages["Aiming"]:Section({Name = "Visuals", Side = "Right"}),
    ["Target Checks"] = Pages["Aiming"]:Section({Name = "Cheks", Side = "Right"}),

    ["ESP"] = Pages["Renders"]:Section({Name = "Extra Sensory Perception", Side = "Left"}),

    ["Misc"] = Pages["Misc"]:Section({Name = "Humanoid"})
}

Sections["Silent Aim"]:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Enabled = v 
    end
})

Sections["Silent Aim"]:Textbox({
    Name = "Prediction",
    Default = "0.13913",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.SilentAim.Prediction = v
    end
})

Sections["Silent Aim"]:Toggle({
    Name = "Automatic Prediction",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.AutomaticPrediction = v 
    end
})

Sections["Silent Aim"]:List({
    Name = "Hit Part",
    Default = "Head",
    Options = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},
    Callback = function(v)
        Configurations.SilentAim.Aimpart = v 
        silentoldpart = v
    end
})


Sections["Silent Aim"]:Toggle({
    Name = "Closest Part",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.ClosestPart = v 
    end
})

Sections["Silent Aim"]:Toggle({
    Name = "Airshot Function",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Airshot.Enabled = v 
    end
})

Sections["Silent Aim"]:List({
    Name = "Airshot Hit Part",
    Default = "HumanoidRootPart",
    Options = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},
    Callback = function(v)
        Configurations.SilentAim.Airshot.Aimpart = v 
    end
})

Sections["Silent Aim"]:Toggle({
    Name = "Use Air Prediction",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Airshot.UseAirprediction = v 
    end
})

Sections["Silent Aim"]:Textbox({
    Name = "Air Prediction",
    Default = "0.13913",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.SilentAim.Airshot.AirPrediction = v
    end
})

Sections["Silent Aim"]:Toggle({
    Name = "Use Jump Offset",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Airshot.UseJumpOffset = v 
    end
})


Sections["Silent Aim"]:Textbox({
    Name = "Jump Offset",
    Default = "0.02",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.SilentAim.Airshot.JumpOffset = v
    end
})
--
Sections["Field Of View"]:Toggle({
    Name = "Visible",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.FieldOfView.Visible = v 
    end
})

Sections["Field Of View"]:Colorpicker({
    Name = "Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.SilentAim.FieldOfView.Color = v 
    end
})

Sections["Field Of View"]:Slider({
    Name = "Size",
    Default = 200,
    Min = 1,
    Max = 1200,
    Callback = function(v)
        Configurations.SilentAim.FieldOfView.Radius = v 
    end
})

Sections["Field Of View"]:Slider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Decimals = 0.1,
    Callback = function(v)
        Configurations.SilentAim.FieldOfView.Transparency = v 
    end
})

Sections["Field Of View"]:Toggle({
    Name = "Filled",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.FieldOfView.Filled = v 
    end
})
--
Sections["Silent Visuals"]:Toggle({
    Name = "Target Info",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Visuals.TargetInfo = v 
    end
})

Sections["Silent Visuals"]:Toggle({
    Name = "Tracer",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Visuals.Tracer = v 
    end
})

Sections["Silent Visuals"]:Slider({
    Name = "Tracer Thickness",
    Min = 1,
    Max = 20,
    Callback = function(v)
        Configurations.SilentAim.Visuals.TracerThickness = v 
    end
})

Sections["Silent Visuals"]:Colorpicker({
    Name = "Tracer Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.SilentAim.Visuals.TracerColor = v 
    end
})
--
Sections["Silent Checks"]:Toggle({
    Name = "Wall",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Checks.Wall = v 
    end
})

Sections["Silent Checks"]:Toggle({
    Name = "Friend",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Checks.Friend = v 
    end
})

Sections["Silent Checks"]:Toggle({
    Name = "Knocked",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Checks.Knocked = v 
    end
})

Sections["Silent Checks"]:Toggle({
    Name = "Grabbed",
    Default = false,
    Callback = function(v)
        Configurations.SilentAim.Checks.Grabbed = v 
    end
})
--
Sections["Target Aim"]:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Enabled = v 
    end
})

Sections["Target Aim"]:Keybind({
    Name = "Key",
    Mode = "Toggle",
    Callback = function(v)
        Configurations.TargetAim.Toggled = v 
        if Configurations.TargetAim.Toggled then
            target = GetClosestPlayer2()
            if Configurations.TargetAim.Notifications then 
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "lumina.cc", -- Required
                    Text = "Locked Onto:"..target.DisplayName, -- Required
                    Duration = 2
                })
            end
        else
            target = nil
            if Configurations.TargetAim.Notifications then 
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "lumina.cc", -- Required
                    Text = "Unlocked!", -- Required
                    Duration = 2
                })
            end
        end
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Notifications",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Notifications = v 
    end
})

Sections["Target Aim"]:Textbox({
    Name = "Prediction",
    Default = "0.13913",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.TargetAim.Prediction = v
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Automatic Prediction",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.AutomaticPrediction = v 
    end
})

Sections["Target Aim"]:List({
    Name = "Hit Part",
    Default = "Head",
    Options = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},
    Callback = function(v)
        Configurations.TargetAim.Aimpart = v 
        targetoldpart = v
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Closest Part",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.ClosestPart = v 
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Airshot Function",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Airshot.Enabled = v 
    end
})

Sections["Target Aim"]:List({
    Name = "Airshot Hit Part",
    Default = "HumanoidRootPart",
    Options = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},
    Callback = function(v)
        Configurations.TargetAim.Airshot.Aimpart = v 
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Use Air Prediction",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Airshot.UseAirprediction = v 
    end
})

Sections["Target Aim"]:Textbox({
    Name = "Air Prediction",
    Default = "0.13913",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.TargetAim.Airshot.AirPrediction = v
    end
})

Sections["Target Aim"]:Toggle({
    Name = "Use Jump Offset",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Airshot.UseJumpOffset = v 
    end
})


Sections["Target Aim"]:Textbox({
    Name = "Jump Offset",
    Default = "0.02",
    Placeholder = ". . .",
    Callback = function(v)
        Configurations.TargetAim.Airshot.JumpOffset = v
    end
})
--
Sections["Target Visuals"]:Toggle({
    Name = "Target Info",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Visuals.TargetInfo = v 
    end
})

Sections["Target Visuals"]:Toggle({
    Name = "Tracer",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Visuals.Tracer = v 
    end
})

Sections["Target Visuals"]:Slider({
    Name = "Tracer Thickness",
    Min = 1,
    Max = 20,
    Callback = function(v)
        Configurations.TargetAim.Visuals.TracerThickness = v 
    end
})

Sections["Target Visuals"]:Colorpicker({
    Name = "Tracer Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.TargetAim.Visuals.TracerColor = v 
    end
})

Sections["Target Visuals"]:Toggle({
    Name = "Dot",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Visuals.Dot = v 
    end
})

Sections["Target Visuals"]:Slider({
    Name = "Dot Size",
    Min = 5,
    Max = 30,
    Default = 5,
    Callback = function(v)
        Configurations.TargetAim.Visuals.DotSize = v 
    end
})

Sections["Target Visuals"]:Colorpicker({
    Name = "Dot Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.TargetAim.Visuals.DotColor = v 
    end
})

Sections["Target Visuals"]:Toggle({
    Name = "Chams",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Visuals.Chams = v 
    end
})

Sections["Target Visuals"]:Colorpicker({
    Name = "Chams Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.TargetAim.Visuals.ChamsColor = v 
    end
})

Sections["Target Visuals"]:Colorpicker({
    Name = "Chams Outline Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        Configurations.TargetAim.Visuals.ChamsOutline = v 
    end
})
--
Sections["Target Checks"]:Toggle({
    Name = "Wall",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Checks.Wall = v 
    end
})

Sections["Target Checks"]:Toggle({
    Name = "Friend",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Checks.Friend = v 
    end
})

Sections["Target Checks"]:Toggle({
    Name = "Knocked",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Checks.Knocked = v 
    end
})

Sections["Target Checks"]:Toggle({
    Name = "Grabbed",
    Default = false,
    Callback = function(v)
        Configurations.TargetAim.Checks.Grabbed = v 
    end
})

Sections["ESP"]:Toggle({
    Name = "Box",
    Default = false,
    Callback = function(v)
        settings.boxVisible = v
    end
})

Sections["ESP"]:Colorpicker({
    Name = "Box Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        settings.boxColor = v 
    end
})


Sections["ESP"]:Toggle({
    Name = "Tracers",
    Default = false,
    Callback = function(v)
        settings.tracerVisible = v
    end
})

Sections["ESP"]:Colorpicker({
    Name = "Tracers Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        settings.tracerColor = v 
    end
})

Sections["ESP"]:Toggle({
    Name = "Names",
    Default = false,
    Callback = function(v)
        settings.namesVisible = v
    end
})

Sections["ESP"]:Colorpicker({
    Name = "Names Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        settings.namesColor = v 
    end
})

Sections["ESP"]:Toggle({
    Name = "Skeleton",
    Default = false,
    Callback = function(v)
        settings.namesVisible = v
    end
})

Sections["ESP"]:Colorpicker({
    Name = "Skeleton Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        settings.skeletonColor = v 
    end
})

Sections["Misc"]:Toggle({
    Name = "CFrame Speed",
    Default = false,
    Callback = function(v)
        realcframe = v
    end
})

Sections["Misc"]:Keybind({
    Name = "Key",
    Mode = "Toggle",
    Callback = function(v)
        isSpeedEnabled = v
        if isSpeedEnabled then 
            modifySpeed()
        end
    end
})

Sections["Misc"]:Slider({
    Name = "Speed",
    Default = 5,
    Min = 1,
    Max = 50,
    Callback = function(v)
        speedMultiplier = v 
    end
})


local FOVCircle = Drawing.new("Circle") do 
    FOVCircle.Visible = Configurations.SilentAim.FieldOfView.Visible
    FOVCircle.Radius  = Configurations.SilentAim.FieldOfView.Radius
    FOVCircle.Color   = Configurations.SilentAim.FieldOfView.Color
    FOVCircle.Filled  = Configurations.SilentAim.FieldOfView.Filled
    FOVCircle.Transparency = Configurations.SilentAim.FieldOfView.Transparency
end

local TargetInfo = Drawing.new("Text") do
    TargetInfo.Visible = Configurations.SilentAim.Visuals.TargetInfo
    TargetInfo.Transparency = 0
    TargetInfo.Size = 16.000
    TargetInfo.Font = 2
    TargetInfo.Outline = true
    TargetInfo.Color = Color3.fromRGB(255,255,255)
    TargetInfo.OutlineColor = Color3.fromRGB(0,0,0)
end

local TargetTracer = Drawing.new("Line") do
    TargetTracer.Visible = true
    TargetTracer.Color = Configurations.SilentAim.Visuals.TracerColor
    TargetTracer.Thickness = Configurations.SilentAim.Visuals.TracerThickness
    TargetTracer.Transparency = 0
end
--
--
--
local targetinfo = Drawing.new("Text") do
    TargetInfo.Visible = Configurations.TargetAim.Visuals.TargetInfo
    TargetInfo.Transparency = 0
    TargetInfo.Size = 16.000
    TargetInfo.Font = 2
    TargetInfo.Outline = true
    TargetInfo.Color = Color3.fromRGB(255,255,255)
    TargetInfo.OutlineColor = Color3.fromRGB(0,0,0)
end

local targettracer = Drawing.new("Line") do
    TargetTracer.Visible = Configurations.TargetAim.Visuals.Tracer
    TargetTracer.Color = Configurations.TargetAim.Visuals.TracerColor
    TargetTracer.Thickness = Configurations.TargetAim.Visuals.TracerThickness
    TargetTracer.Transparency = 0
end

local targetcham = Instance.new("Highlight") do 
    targetcham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    targetcham.FillColor = Configurations.TargetAim.Visuals.ChamsColor
    targetcham.OutlineColor = Configurations.TargetAim.Visuals.ChamsOutline
    targetcham.Enabled = Configurations.TargetAim.Visuals.Chams
end

local targetdot = Drawing.new("Circle") do 
    targetdot.Visible = Configurations.TargetAim.Visuals.Dot
    targetdot.Radius  = Configurations.TargetAim.Visuals.DotSize
    targetdot.Color   = Configurations.TargetAim.Visuals.DotColor
    targetdot.Filled  = true
    targetdot.Transparency = 0
end


local function UpdateVisuals()
    FOVCircle.Visible = Configurations.SilentAim.FieldOfView.Visible
    FOVCircle.Radius  = Configurations.SilentAim.FieldOfView.Radius
    FOVCircle.Color   = Configurations.SilentAim.FieldOfView.Color
    FOVCircle.Filled  = Configurations.SilentAim.FieldOfView.Filled
    FOVCircle.Transparency = Configurations.SilentAim.FieldOfView.Transparency
    FOVCircle.Position = UserInputService:GetMouseLocation()

    TargetInfo.Visible = Configurations.SilentAim.Visuals.TargetInfo
    TargetInfo.Transparency = 0
    TargetInfo.Size = 16.000
    TargetInfo.Font = 2
    TargetInfo.Outline = false
    TargetInfo.Color = Color3.fromRGB(255,255,255)
    TargetInfo.OutlineColor = Color3.fromRGB(0,0,0)

    TargetTracer.Visible = Configurations.SilentAim.Visuals.Tracer
    TargetTracer.Color = Configurations.SilentAim.Visuals.TracerColor
    TargetTracer.Thickness = Configurations.SilentAim.Visuals.TracerThickness
    TargetTracer.Transparency = 0

    if SilentTarget then
        local Position, onscreen = Camera:WorldToViewportPoint(SilentTarget.Character.HumanoidRootPart.Position)
        if onscreen then
            TargetInfo.Position = Vector2.new(Position.X,Position.Y)
            TargetInfo.Text = "Health: "..SilentTarget.Character.Humanoid.Health.."\n"..SilentTarget.DisplayName

            TargetTracer.From = UserInputService:GetMouseLocation()
            TargetTracer.To = Vector2.new(Position.X,Position.Y)
        else
            TargetInfo.Visible = false
            TargetTracer.Visible = false
        end
    else
        TargetInfo.Visible = false
        TargetTracer.Visible = false
    end

end

local function UpdateTargetVisuals()
    targetdot.Visible = Configurations.TargetAim.Visuals.Dot
    targetdot.Radius  = Configurations.TargetAim.Visuals.DotSize
    targetdot.Color   = Configurations.TargetAim.Visuals.DotColor
    targetdot.Filled  = true
    targetdot.Transparency = 0

    targetinfo.Visible = Configurations.TargetAim.Visuals.TargetInfo
    targetinfo.Transparency = 0
    targetinfo.Size = 16.000
    targetinfo.Font = 2
    targetinfo.Outline = false
    targetinfo.Color = Color3.fromRGB(255,255,255)
    targetinfo.OutlineColor = Color3.fromRGB(0,0,0)

    targettracer.Visible = Configurations.TargetAim.Visuals.Tracer
    targettracer.Color = Configurations.TargetAim.Visuals.TracerColor
    targettracer.Thickness = Configurations.TargetAim.Visuals.TracerThickness
    targettracer.Transparency = 0

    targetcham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    targetcham.FillColor = Configurations.TargetAim.Visuals.ChamsColor
    targetcham.OutlineColor = Configurations.TargetAim.Visuals.ChamsOutline
    targetcham.Enabled = Configurations.TargetAim.Visuals.Chams

    if target then
        local Position, onscreen = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
        if onscreen then
            targetdot.Position = Vector2.new(Position.X,Position.Y)
            --
            targetinfo.Position = Vector2.new(Position.X,Position.Y)
            targetinfo.Text = "Health: "..target.Character.Humanoid.Health.."\n"..target.DisplayName
            --
            targettracer.From = UserInputService:GetMouseLocation()
            targettracer.To = Vector2.new(Position.X,Position.Y)
            --
            targetcham.Parent = target.Character
            targetcham.Adornee = target.Character
        else
            targetinfo.Visible = false
            targettracer.Visible = false
            targetdot.Visible = false
            targetcham.Enabled = false
        end
    else
        targetinfo.Visible = false
        targettracer.Visible = false
        targetdot.Visible = false
        targetcham.Enabled = false
    end
end

RunService.RenderStepped:Connect(function()
    UpdateVisuals()
    SilentTarget = GetClosestPlayer(Configurations.SilentAim.FieldOfView.Radius) -- this will update everytime someones in the fov circle
    SilentPos = SilentTarget.Character[Configurations.SilentAim.Aimpart].Position
    SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Prediction

    -- hood customs supported
    if game.PlaceId == 9825515356 then 
        SilentPos = SilentTarget.Character[Configurations.SilentAim.Aimpart].Position + Vector3.new(25,100,25)
    end

    if Configurations.SilentAim.ClosestPart then 
        Configurations.SilentAim.Aimpart = tostring(GetClosestBodyPart(SilentTarget.Character))
    else
        Configurations.SilentAim.Aimpart = silentoldpart
    end
    -- this is just a shitty method for the airshot, but it works fine
    if Configurations.SilentAim.Airshot.Enabled then 
        if Configurations.SilentAim.Airshot.UseAirprediction then 
            if Configurations.SilentAim.Airshot.UseJumpOffset then 
                if SilentTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                    Configurations.SilentAim.Aimpart = Configurations.SilentAim.Airshot.Aimpart
                    SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Airshot.AirPrediction + Vector3.new(0,Configurations.SilentAim.Airshot.JumpOffset,0)
                else
                    SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Prediction
                    Configurations.SilentAim.Aimpart = silentoldpart
                end
            else
                if SilentTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                Configurations.SilentAim.Aimpart = Configurations.SilentAim.Airshot.Aimpart
                SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Airshot.AirPrediction
                else
                    SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Prediction
                    Configurations.SilentAim.Aimpart = silentoldpart
                end
            end
        else
            if SilentTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or SilentTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                Configurations.SilentAim.Aimpart = Configurations.SilentAim.Airshot.Aimpart
            else
                SilentPredictionPos = (SilentTarget.Character[Configurations.SilentAim.Aimpart].Velocity) * Configurations.SilentAim.Prediction
                Configurations.SilentAim.Aimpart = silentoldpart
            end
        end
    end

end)

RunService.RenderStepped:Connect(function()
    UpdateTargetVisuals()
    if Configurations.TargetAim.Toggled and target then 

        targetpos = target.Character[Configurations.TargetAim.HitPart].Position
        targetpredpos = (target.Character[Configurations.TargetAim.HitPart].Velocity) * Configurations.TargetAim.Prediction
    
        if game.PlaceId == 9825515356 then 
            targetpos = targetpos.Character[Configurations.TargetAim.HitPart].Position + Vector3.new(25,100,25)
        end

        if Configurations.TargetAim.ClosestPart then 
            Configurations.TargetAim.HitPart = tostring(GetClosestBodyPart(TargetTracer.Character))
        else
            Configurations.TargetAim.HitPart = targetoldpart
        end

            -- this is just a shitty method for the airshot, but it works fine
    if Configurations.TargetAim.Airshot.Enabled then 
        if Configurations.TargetAim.Airshot.UseAirprediction then 
            if Configurations.TargetAim.Airshot.UseJumpOffset then 
                if target.Character.Humanoid.FloorMaterial == Enum.Material.Air or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                    Configurations.TargetAim.Aimpart = Configurations.TargetAim.Airshot.Aimpart
                    targetpredpos = (target.Character[Configurations.TargetAim.Aimpart].Velocity) * Configurations.TargetAim.Airshot.AirPrediction + Vector3.new(0,Configurations.TargetAim.Airshot.JumpOffset,0)
                else
                    targetpredpos = (target.Character[Configurations.TargetAim.Aimpart].Velocity) * Configurations.TargetAim.Prediction
                    Configurations.TargetAim.Aimpart = targetoldpart
                end
            else
                if target.Character.Humanoid.FloorMaterial == Enum.Material.Air or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                Configurations.TargetAim.Aimpart = Configurations.TargetAim.Airshot.Aimpart
                SilentPredictionPos = (target.Character[Configurations.TargetAim.Aimpart].Velocity) * Configurations.TargetAim.Airshot.AirPrediction
                else
                    SilentPredictionPos = (target.Character[Configurations.TargetAim.Aimpart].Velocity) * Configurations.TargetAim.Prediction
                    Configurations.TargetAim.Aimpart = targetoldpart
                end
            end
        else
            if target.Character.Humanoid.FloorMaterial == Enum.Material.Air or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
                Configurations.TargetAim.Aimpart = Configurations.TargetAim.Airshot.Aimpart
            else
                SilentPredictionPos = (target.Character[Configurations.TargetAim.Aimpart].Velocity) * Configurations.TargetAim.Prediction
                Configurations.TargetAim.Aimpart = targetoldpart
            end
        end
    end
    
    end
end)


-- the silent aim, i made this on solara because i dont own wave
local function SilentAim(tool)  
    if tool:IsA("Tool") then  
        tool.Activated:Connect(function()
            if Configurations.SilentAim.Enabled and SilentTarget and isValidTarget(SilentTarget) then  
                local Arguments = {  
                    getArg(),  
                   SilentPos + SilentPredictionPos
                }  
                
                getRemote():FireServer(unpack(Arguments))  
            end  
        end)  
    end  
end  

local function TargetAim(tool)  
    if tool:IsA("Tool") then  
        tool.Activated:Connect(function()
            if Configurations.TargetAim.Enabled and target and isValidTarget2(target) then  
                local Arguments = {  
                    getArg(),  
                   targetpos + targetpredpos
                }  
                
                getRemote():FireServer(unpack(Arguments))  
            end  
        end)  
    end  
end  

-- whenever character respawns or dies, call the function again
LocalPlayer.CharacterAdded:Connect(function(character)  
    character.ChildAdded:Connect(SilentAim)
    character.ChildAdded:Connect(TargetAim)
end)  

if LocalPlayer.Character then  
    LocalPlayer.Character.ChildAdded:Connect(SilentAim)  
    LocalPlayer.Character.ChildAdded:Connect(TargetAim)
end   

while Configurations.SilentAim.AutomaticPrediction == true do
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingValue = string.split(ping, " ")[1]
    local pingNumber = tonumber(pingValue)
   
    if pingNumber < 30 then
        Configurations.SilentAim.Prediction = 0.12588
    elseif pingNumber < 40 then
        Configurations.SilentAim.Prediction = 0.119
    elseif pingNumber < 50 then
        Configurations.SilentAim.Prediction = 0.1247
    elseif pingNumber < 60 then
        Configurations.SilentAim.Prediction = 0.127668
    elseif pingNumber < 70 then
        Configurations.SilentAim.Prediction = 0.12731
    elseif pingNumber < 80 then
        Configurations.SilentAim.Prediction = 0.12951
    elseif pingNumber < 90 then
        Configurations.SilentAim.Prediction = 0.1318
    elseif pingNumber < 100 then
        Configurations.SilentAim.Prediction = 0.1357
    elseif pingNumber < 110 then
        Configurations.SilentAim.Prediction = 0.133340
         elseif pingNumber < 120 then
        Configurations.SilentAim.Prediction = 0.1455
         elseif pingNumber < 130 then
        Configurations.SilentAim.Prediction = 0.143765
         elseif pingNumber < 140 then
        Configurations.SilentAim.Prediction = 0.156692
         elseif pingNumber < 150 then
        Configurations.SilentAim.Prediction = 0.1223333
         elseif pingNumber < 160 then
        Configurations.SilentAim.Prediction = 0.1521
        elseif pingNumber < 170 then
        Configurations.SilentAim.Prediction = 0.1626
        elseif pingNumber < 180 then
        Configurations.SilentAim.Prediction = 0.1923111
        elseif pingNumber < 190 then
        Configurations.SilentAim.Prediction = 0.19284
        elseif pingNumber < 200 then
        Configurations.SilentAim.Prediction = 0.166547
        elseif pingNumber < 210 then
        Configurations.SilentAim.Prediction = 0.16942
        elseif pingNumber < 260 then
        Configurations.SilentAim.Prediction = 0.1651
        elseif pingNumber < 310 then
        Configurations.SilentAim.Prediction = 0.16780
	end
 
    wait(0.1)
end

while Configurations.TargetAim.AutomaticPrediction == true do
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingValue = string.split(ping, " ")[1]
    local pingNumber = tonumber(pingValue)
   
    if pingNumber < 30 then
        Configurations.TargetAim.Prediction = 0.12588
    elseif pingNumber < 40 then
        Configurations.TargetAim.Prediction = 0.119
    elseif pingNumber < 50 then
        Configurations.TargetAim.Prediction = 0.1247
    elseif pingNumber < 60 then
        Configurations.TargetAim.Prediction = 0.127668
    elseif pingNumber < 70 then
        Configurations.TargetAim.Prediction = 0.12731
    elseif pingNumber < 80 then
        Configurations.TargetAim.Prediction = 0.12951
    elseif pingNumber < 90 then
        Configurations.TargetAim.Prediction = 0.1318
    elseif pingNumber < 100 then
        Configurations.TargetAim.Prediction = 0.1357
    elseif pingNumber < 110 then
        Configurations.TargetAim.Prediction = 0.133340
         elseif pingNumber < 120 then
        Configurations.TargetAim.Prediction = 0.1455
         elseif pingNumber < 130 then
        Configurations.TargetAim.Prediction = 0.143765
         elseif pingNumber < 140 then
        Configurations.TargetAim.Prediction = 0.156692
         elseif pingNumber < 150 then
        Configurations.TargetAim.Prediction = 0.1223333
         elseif pingNumber < 160 then
        Configurations.TargetAim.Prediction = 0.1521
        elseif pingNumber < 170 then
        Configurations.TargetAim.Prediction = 0.1626
        elseif pingNumber < 180 then
        Configurations.TargetAim.Prediction = 0.1923111
        elseif pingNumber < 190 then
        Configurations.TargetAim.Prediction = 0.19284
        elseif pingNumber < 200 then
        Configurations.TargetAim.Prediction = 0.166547
        elseif pingNumber < 210 then
        Configurations.TargetAim.Prediction = 0.16942
        elseif pingNumber < 260 then
        Configurations.TargetAim.Prediction = 0.1651
        elseif pingNumber < 310 then
        Configurations.TargetAim.Prediction = 0.16780
	end
 
    wait(0.1)
end
-- services
local runService = game:GetService("RunService");
local players = game:GetService("Players");
local userInputService = game:GetService("UserInputService");
local camera = workspace.CurrentCamera;

-- variables
local localPlayer = players.LocalPlayer;

-- functions
-- read the function names if youre not retarded

local newVector2, newDrawing = Vector2.new, Drawing.new;
local tan, rad = math.tan, math.rad;

local function round(number)
    return math.floor(number + 0.5)
end

local function wtvp(position)
    local viewportPoint, onScreen = camera:WorldToViewportPoint(position);
    return Vector2.new(viewportPoint.X, viewportPoint.Y), onScreen, viewportPoint.Z;
end

local espCache = {};
local function createEsp(player)
    local drawings = {};
    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    local healthy = player.Character.Humanoid.Health
    --local armorValue = player.DataFolder.Information.ArmorSave.Value
    
    drawings.box = newDrawing("Square");
    drawings.box.Thickness = 1;
    drawings.box.Filled = false;
    drawings.box.Color = settings.boxColor;
    drawings.box.Visible = settings.boxVisible;
    drawings.box.ZIndex = 3;

    drawings.boxoutline = newDrawing("Square");
    drawings.boxoutline.Thickness = 3;
    drawings.boxoutline.Filled = false;
    drawings.boxoutline.Color = Color3.new(0, 0, 0);
    drawings.boxoutline.Visible = settings.boxVisible;
    drawings.boxoutline.ZIndex = 2;

    drawings.nametag = newDrawing("Text");
    drawings.nametag.Text = player.DisplayName .. " (@" .. player.Name .. ")";
    drawings.nametag.Size = 14;
    drawings.nametag.Color = settings.namesColor
    drawings.nametag.Center = true;
    drawings.nametag.Outline = true;
    drawings.nametag.Visible = settings.namesVisible;
    drawings.nametag.ZIndex = 4;

    drawings.tracer = newDrawing("Line");
    drawings.tracer.Color = settings.tracerColor;
    drawings.tracer.Thickness = 1;
    drawings.tracer.Visible = settings.tracerVisible
    drawings.tracer.ZIndex = 1;

    drawings.distance = newDrawing("Text")
    drawings.distance.Text = math.round(distance).."m"
    drawings.distance.Size = 12
    drawings.distance.Color = Color3.fromRGB(255,255,255)
    drawings.distance.Outline = true 
    drawings.distance.Visible = settings.distanceVisible
    drawings.distance.ZIndex = 4

    drawings.health = newDrawing("Text")
    drawings.health.Text = math.round(healthy)
    drawings.health.Size = 12 
    drawings.health.Color = Color3.fromRGB(151, 255, 143)
    drawings.health.Outline = true 
    drawings.health.Visible = settings.flags.health
    drawings.health.ZIndex = 4

    -- skeleton esp below
    drawings.leftArm = newDrawing("Line")
    drawings.leftArm.Visible = settings.skeleton
    drawings.leftArm.Color = settings.skeletonColor
    drawings.leftArm.Thickness = 2
    drawings.leftArm.ZIndex = 1

    drawings.rightArm = newDrawing("Line")
    drawings.rightArm.Visible = settings.skeleton
    drawings.rightArm.Color = settings.skeletonColor
    drawings.rightArm.Thickness = 2
    drawings.rightArm.ZIndex = 1

    drawings.rightArmTorso = newDrawing("Line")
    drawings.rightArmTorso.Visible = settings.skeleton
    drawings.rightArmTorso.Color = settings.skeletonColor
    drawings.rightArmTorso.Thickness = 2
    drawings.rightArmTorso.ZIndex = 1

    drawings.leftarmLowerTorso = newDrawing("Line")
    drawings.leftarmLowerTorso.Visible = settings.skeleton
    drawings.leftarmLowerTorso.Color = settings.skeletonColor
    drawings.leftarmLowerTorso.Thickness = 2
    drawings.leftarmLowerTorso.ZIndex = 1
    
    drawings.rightarmtorsol = newDrawing("Line")
    drawings.rightarmtorsol.Visible = settings.skeleton
    drawings.rightarmtorsol.Color = settings.skeletonColor
    drawings.rightarmtorsol.Thickness = 2
    drawings.rightarmtorsol.ZIndex = 1

    drawings.uppertolower = newDrawing("Line")
    drawings.uppertolower.Visible = settings.skeleton
    drawings.uppertolower.Color = settings.skeletonColor
    drawings.uppertolower.Thickness = 2
    drawings.uppertolower.ZIndex = 1

    drawings.lowertorightleg = newDrawing("Line")
    drawings.lowertorightleg.Visible = settings.skeleton
    drawings.lowertorightleg.Color = settings.skeletonColor
    drawings.lowertorightleg.Thickness = 2
    drawings.lowertorightleg.ZIndex = 1

    drawings.upperlegtolowerleg = newDrawing("Line")
    drawings.upperlegtolowerleg.Visible = settings.skeleton
    drawings.upperlegtolowerleg.Color = settings.skeletonColor
    drawings.upperlegtolowerleg.Thickness = 2
    drawings.upperlegtolowerleg.ZIndex = 1

    drawings.uppertorsotoleftleg = newDrawing("Line")
    drawings.uppertorsotoleftleg.Visible = settings.skeleton
    drawings.uppertorsotoleftleg.Color = settings.skeletonColor
    drawings.uppertorsotoleftleg.Thickness = 2
    drawings.uppertorsotoleftleg.ZIndex = 1

    drawings.upperlegtolowerleft = newDrawing("Line")
    drawings.upperlegtolowerleft.Visible = settings.skeleton
    drawings.upperlegtolowerleft.Color = settings.skeletonColor
    drawings.upperlegtolowerleft.Thickness = 2
    drawings.upperlegtolowerleft.ZIndex = 1

    drawings.linetohead = newDrawing("Line")
    drawings.linetohead.Visible = settings.skeleton
    drawings.linetohead.Color = settings.skeletonColor
    drawings.linetohead.Thickness = 2
    drawings.linetohead.ZIndex = 1

    -- data 
    espCache[player] = drawings;
end

function toggleESP(enabled)
    settings.tracerVisible = enabled
    for _, esp in pairs(espCache) do
        esp.box.Visible = enabled
        esp.boxoutline.Visible = enabled 
        esp.nametag.Visible = enabled 
        esp.tracer.Visible = enabled 
        esp.distance.Visible = enabled 
        esp.health.Visible = enabled 
        esp.leftArm.Visible = enabled
        esp.rightArm.Visible = enabled
        esp.rightArmTorso.Visible = enabled
        esp.leftarmLowerTorso.Visible = enabled
        esp.rightarmtorsol.Visible = enabled
        esp.uppertolower.Visible = enabled
        esp.lowertorightleg.Visible = enabled
        esp.upperlegtolowerleg.Visible = enabled
        esp.uppertorsotoleftleg.Visible = enabled
        esp.upperlegtolowerleft.Visible = enabled
        esp.linetohead.Visible = enabled
    end
end


local function removeEsp(player)
    if espCache[player] then
        for _, drawing in pairs(espCache[player]) do
            drawing:Remove();
        end
        espCache[player] = nil;
    end
end

-- do not fuck with ts if u dunno what u doin
local function calculateBoundingBox(character)
    local minX, maxX, minY, maxY, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge, math.huge, -math.huge
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA('BasePart') then
            local partCFrame = part.CFrame
            local partSize = part.Size * 0.5
            for i = -1, 1, 2 do
                for j = -1, 1, 2 do
                    for k = -1, 1, 2 do
                        local corner = partCFrame * Vector3.new(partSize.X * i, partSize.Y * j, partSize.Z * k)
                        minX = math.min(minX, corner.X)
                        maxX = math.max(maxX, corner.X)
                        minY = math.min(minY, corner.Y)
                        maxY = math.max(maxY, corner.Y)
                        minZ = math.min(minZ, corner.Z)
                        maxZ = math.max(maxZ, corner.Z)
                    end
                end
            end
        end
    end
    return minX, maxX, minY, maxY, minZ, maxZ
end

local function updateEsp(player, esp)
    local character = player.Character
    if character and character.PrimaryPart then
        local minX, maxX, minY, maxY, minZ, maxZ = calculateBoundingBox(character)
        local centerX = (minX + maxX) / 2
        local centerY = (minY + maxY) / 2
        local centerZ = (minZ + maxZ) / 2
        local width = maxX - minX
        local height = maxY - minY

        local center = Vector3.new(centerX, centerY, centerZ)
        local position, onScreen, depth = wtvp(center)
        local leftarm1, onscreen = wtvp(player.Character.LeftUpperArm.Position)
        local leftarm2, onscreen = wtvp(player.Character.LeftHand.Position)
        local rightarm1, onscreen = wtvp(player.Character.RightUpperArm.Position)
        local rightarm2, onscreen = wtvp(player.Character.RightHand.Position)
        local rightarmtorso, onscreen = wtvp(player.Character.UpperTorso.Position)
        local leftarmlowertorso, onscreen = wtvp(player.Character.LowerTorso.Position)
        local loweringtorightleg, onscreen = wtvp(player.Character.RightUpperLeg.Position)
        local upperingtolowerlegright, onscreen = wtvp(player.Character.RightFoot.Position)
        local loweringtoleftleg, onscreen = wtvp(player.Character.LeftUpperLeg.Position)
        local loweringtoleftfoot, onscreen = wtvp(player.Character.LeftFoot.Position)
        local headpos, onscreen = wtvp(player.Character.Head.Position)


        if onScreen then
            local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
            local boxWidth = round(width * scaleFactor)
            local boxHeight = round(height * scaleFactor)
            esp.box.Size = newVector2(boxWidth, boxHeight)
            esp.box.Position = newVector2(position.X - boxWidth / 2, position.Y - boxHeight / 2)
            esp.box.Visible = settings.boxVisible
            esp.boxoutline.Size = esp.box.Size -- do NOT FUCK WITH THIS
            esp.boxoutline.Position = esp.box.Position -- DO NOT FUCK WITH THIS
            esp.boxoutline.Visible = settings.boxVisible
            esp.nametag.Position = newVector2(position.X, position.Y - boxHeight / 2 - 28)
            esp.nametag.Visible = settings.namesVisible
            esp.distance.Visible = settings.distanceVisible
            esp.distance.Position = esp.box.Position + Vector2.new(8,0)-- adjust the positions as you like
            esp.health.Position = esp.box.Position + Vector2.new(0,-12) -- adjust the positions as you like
            esp.health.Visible = settings.flags.health
            esp.leftArm.Visible = settings.skeleton
            esp.rightArm.Visible = settings.skeleton
            esp.rightArmTorso.Visible = settings.skeleton
            esp.leftarmLowerTorso.Visible = settings.skeleton
            esp.rightarmtorsol.Visible = settings.skeleton
            esp.uppertolower.Visible = settings.skeleton
            esp.lowertorightleg.Visible = settings.skeleton
            esp.upperlegtolowerleg.Visible = settings.skeleton
            esp.uppertorsotoleftleg.Visible = settings.skeleton
            esp.upperlegtolowerleft.Visible = settings.skeleton
            esp.linetohead.Visible = settings.skeleton

            if settings.tracerVisible then
                local tracerOrigin = settings.tracerOrigin == "Mouse" and userInputService:GetMouseLocation() or newVector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                esp.tracer.From = tracerOrigin
                esp.tracer.To = newVector2(position.X, position.Y)
                esp.tracer.Visible = settings.tracerVisible
            end
            if settings.skeleton then 
                esp.leftArm.Visible = settings.skeleton
                esp.rightArm.Visible = settings.skeleton
                esp.rightArmTorso.Visible = settings.skeleton
                esp.leftArm.From = leftarm1
                esp.leftArm.To = leftarm2
                esp.rightArm.From = rightarm1 
                esp.rightArm.To = rightarm2
                esp.rightArmTorso.From = rightarm1 
                esp.rightArmTorso.To = rightarmtorso
                esp.leftarmLowerTorso.From = rightarmtorso
                esp.leftarmLowerTorso.To = leftarmlowertorso
                esp.rightarmtorsol.From = leftarm1 
                esp.rightarmtorsol.To = rightarmtorso
                esp.uppertolower.From = rightarmtorso
                esp.uppertolower.To = leftarmlowertorso
                esp.lowertorightleg.From = leftarmlowertorso
                esp.lowertorightleg.To = loweringtorightleg
                esp.upperlegtolowerleg.From = loweringtorightleg
                esp.upperlegtolowerleg.To = upperingtolowerlegright
                esp.uppertorsotoleftleg.From = leftarmlowertorso
                esp.uppertorsotoleftleg.To = loweringtoleftleg
                esp.upperlegtolowerleft.From = loweringtoleftleg
                esp.upperlegtolowerleft.To = loweringtoleftfoot
                esp.linetohead.From = rightarmtorso 
                esp.linetohead.To = headpos
            end
        else
            esp.box.Visible = false 
            esp.boxoutline.Visible = false 
            esp.nametag.Visible = false 
            esp.tracer.Visible = false 
            esp.distance.Visible = false 
            esp.health.Visible = false 
            esp.leftArm.Visible = false
            esp.rightArm.Visible = false
            esp.rightArmTorso.Visible = false
            esp.leftarmLowerTorso.Visible = false
            esp.rightarmtorsol.Visible = false
            esp.uppertolower.Visible = false
            esp.lowertorightleg.Visible = false
            esp.upperlegtolowerleg.Visible = false
            esp.uppertorsotoleftleg.Visible = false
            esp.upperlegtolowerleft.Visible = false
            esp.linetohead.Visible = false
        end
    else
        esp.box.Visible = false 
        esp.boxoutline.Visible = false 
        esp.nametag.Visible = false 
        esp.tracer.Visible = false 
        esp.distance.Visible = false 
        esp.health.Visible = false 
        esp.leftArm.Visible = false
        esp.rightArm.Visible = false
        esp.rightArmTorso.Visible = false
        esp.leftarmLowerTorso.Visible = false
        esp.rightarmtorsol.Visible = false
        esp.uppertolower.Visible = false
        esp.lowertorightleg.Visible = false
        esp.upperlegtolowerleg.Visible = false
        esp.uppertorsotoleftleg.Visible = false
        esp.upperlegtolowerleft.Visible = false
        esp.linetohead.Visible = false
    end
end

-- main
for _, player in pairs(players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player);
    end
end

game.Players.PlayerAdded:Connect(updateEsp)
game.Players.PlayerRemoving:Connect(removeEsp)


-- team check doesnt work ❌
runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and not (settings.teamcheck and player.Team == localPlayer.Team) then
            updateEsp(player, espCache[player]);
        end
    end
end)

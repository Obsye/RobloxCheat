local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Enabled = false
local ExcludeFriends = true

local OffsetX = 0
local OffsetY = -1
local OffsetZ = 5

local RotationX = 0
local RotationY = 0
local RotationZ = 0

local STEP = 0.5

local OldGui = PlayerGui:FindFirstChild("LegTeleportGui")

if OldGui then
	OldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LegTeleportGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 410)
MainFrame.Position = UDim2.new(0, 20, 0.5, -205)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Leg Teleport"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -37, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local function StyleButton(Button)
	Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button
end


local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.Parent = MainFrame

StyleButton(ToggleButton)


local FriendButton = Instance.new("TextButton")
FriendButton.Name = "FriendButton"
FriendButton.Size = UDim2.new(1, -20, 0, 35)
FriendButton.Position = UDim2.new(0, 10, 0, 85)
FriendButton.Parent = MainFrame

StyleButton(FriendButton)


local ValueBoxes = {}

local function CreateValueBox(Name, Y, Getter, Setter)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 70, 0, 30)
	Label.Position = UDim2.new(0, 10, 0, Y)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.TextSize = 14
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = MainFrame

	local Box = Instance.new("TextBox")
	Box.Size = UDim2.new(0, 210, 0, 30)
	Box.Position = UDim2.new(0, 80, 0, Y)

	Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Box.BorderSizePixel = 0

	Box.TextColor3 = Color3.new(1, 1, 1)
	Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

	Box.TextSize = 14
	Box.Font = Enum.Font.GothamBold

	Box.ClearTextOnFocus = false

	Box.Text = tostring(Getter())

	Box.Parent = MainFrame

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Box

	ValueBoxes[Name] = Box
	Box.FocusLost:Connect(function()

		local Number = tonumber(Box.Text)

		if Number then
			Setter(Number)
			Box.Text = tostring(Number)
		else
			Box.Text = tostring(Getter())
		end

	end)
end

local PositionTitle = Instance.new("TextLabel")
PositionTitle.Size = UDim2.new(1, -20, 0, 25)
PositionTitle.Position = UDim2.new(0, 10, 0, 125)
PositionTitle.BackgroundTransparency = 1
PositionTitle.Text = "위치"
PositionTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
PositionTitle.TextSize = 15
PositionTitle.Font = Enum.Font.GothamBold
PositionTitle.TextXAlignment = Enum.TextXAlignment.Left
PositionTitle.Parent = MainFrame


CreateValueBox(
	"X",
	150,
	function()
		return OffsetX
	end,
	function(Value)
		OffsetX = Value
	end
)

CreateValueBox(
	"Y",
	185,
	function()
		return OffsetY
	end,
	function(Value)
		OffsetY = Value
	end
)

CreateValueBox(
	"Z",
	220,
	function()
		return OffsetZ
	end,
	function(Value)
		OffsetZ = Value
	end
)

local RotationTitle = Instance.new("TextLabel")
RotationTitle.Size = UDim2.new(1, -20, 0, 25)
RotationTitle.Position = UDim2.new(0, 10, 0, 255)
RotationTitle.BackgroundTransparency = 1
RotationTitle.Text = "회전"
RotationTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
RotationTitle.TextSize = 15
RotationTitle.Font = Enum.Font.GothamBold
RotationTitle.TextXAlignment = Enum.TextXAlignment.Left
RotationTitle.Parent = MainFrame


CreateValueBox(
	"RX",
	280,
	function()
		return RotationX
	end,
	function(Value)
		RotationX = Value
	end
)

CreateValueBox(
	"RY",
	315,
	function()
		return RotationY
	end,
	function(Value)
		RotationY = Value
	end
)

CreateValueBox(
	"RZ",
	350,
	function()
		return RotationZ
	end,
	function(Value)
		RotationZ = Value
	end
)

local function UpdateGUI()
	if Enabled then
		ToggleButton.Text = "이동: ON"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(50, 170, 80)
	else
		ToggleButton.Text = "이동: OFF"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(170, 50, 50)
	end

	if ExcludeFriends then
		FriendButton.Text = "친구 제외: ON"
	else
		FriendButton.Text = "친구 제외: OFF"
	end
end

UpdateGUI()

ToggleButton.MouseButton1Click:Connect(function()
	Enabled = not Enabled

	if not Enabled then
		CurrentTarget = nil
	end

	UpdateGUI()
end)

FriendButton.MouseButton1Click:Connect(function()
	ExcludeFriends = not ExcludeFriends

	CurrentTarget = nil

	UpdateGUI()
end)

CloseButton.MouseButton1Click:Connect(function()
	Enabled = false
	ScreenGui:Destroy()
end)

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = MainFrame.Position

		Input.Changed:Connect(function()

			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end

		end)
	end

end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch then

		local Delta =
			Input.Position - DragStart

		MainFrame.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end

end)

local function IsFriend(Player)

	if not Player then
		return false
	end

	local Success, Result = pcall(function()
		return LocalPlayer:IsFriendsWith(
			Player.UserId
		)
	end)

	if Success then
		return Result
	end

	return false
end

local function GetTargets()

	local Targets = {}

	for _, Object in ipairs(workspace:GetDescendants()) do

		if not Object:IsA("Model") then
			continue
		end

		local Humanoid =
			Object:FindFirstChildOfClass("Humanoid")

		local RootPart =
			Object:FindFirstChild("HumanoidRootPart")

		if not Humanoid or not RootPart then
			continue
		end

		if not RootPart:IsA("BasePart") then
			continue
		end

		if Object == LocalPlayer.Character then
			continue
		end

		if Humanoid.Health <= 0 then
			continue
		end

		local TargetPlayer =
			Players:GetPlayerFromCharacter(Object)

		if TargetPlayer then

			if ExcludeFriends
				and IsFriend(TargetPlayer) then

				continue
			end

		end

		table.insert(Targets, {

			Model = Object,

			Humanoid = Humanoid,

			RootPart = RootPart,

			Player = TargetPlayer

		})

	end

	return Targets
end

local function IsTargetValid(Target)

	if not Target then
		return false
	end

	if not Target.Model
		or not Target.Model.Parent then

		return false
	end

	if not Target.Humanoid
		or Target.Humanoid.Health <= 0 then

		return false
	end

	if not Target.RootPart
		or not Target.RootPart.Parent then

		return false
	end

	if ExcludeFriends and Target.Player then

		if IsFriend(Target.Player) then
			return false
		end

	end

	return true
end

local function TeleportBehind(Target)

	local Character = LocalPlayer.Character
	if not Character then
		return
	end

	local MyRoot = Character:FindFirstChild("HumanoidRootPart")
	if not MyRoot then
		return
	end

	local TargetRoot = Target.RootPart

	if not TargetRoot or not TargetRoot.Parent then
		return
	end

	local LocalOffset = Vector3.new(
		OffsetX,
		OffsetY,
		OffsetZ
	)

	local WorldPosition =
		TargetRoot.CFrame:PointToWorldSpace(LocalOffset)

	local Direction =
		TargetRoot.Position - WorldPosition

	if Direction.Magnitude < 0.001 then
		return
	end

	Direction = Direction.Unit

	local FlatDirection = Vector3.new(
		Direction.X,
		0,
		Direction.Z
	)

	if FlatDirection.Magnitude < 0.001 then
		FlatDirection = Vector3.new(0, 0, -1)
	else
		FlatDirection = FlatDirection.Unit
	end


	local BaseCFrame =
		CFrame.lookAt(
			WorldPosition,
			WorldPosition + FlatDirection,
			Vector3.new(0, 1, 0)
		)

	local RotationCFrame =
		CFrame.fromEulerAnglesXYZ(
			math.rad(RotationX),
			math.rad(RotationY),
			math.rad(RotationZ)
		)

	MyRoot.CFrame =
		BaseCFrame * RotationCFrame
end

CurrentTarget = nil

local CurrentTarget = nil

task.spawn(function()

	while ScreenGui.Parent do

		if Enabled then

			if not IsTargetValid(CurrentTarget) then

				CurrentTarget = nil

				local Targets = GetTargets()

				if #Targets > 0 then
					CurrentTarget = Targets[1]
				end

			end

			if CurrentTarget then
				TeleportBehind(CurrentTarget)
			end

		else
			CurrentTarget = nil
		end

		task.wait()
	end

end)

task.spawn(function()
	while ScreenGui.Parent do
		UpdateGUI()
		task.wait(0.05)
	end
end)

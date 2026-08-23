local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- 설정
--==================================================

local Enabled = false
local ExcludeFriends = true

-- 상대 HRP 기준 위치
local OffsetX = 0
local OffsetY = -1
local OffsetZ = 5

-- 추가 회전
local RotationX = 90
local RotationY = 0
local RotationZ = 0

local STEP = 0.5

--==================================================
-- 기존 GUI 제거
--==================================================

local OldGui = PlayerGui:FindFirstChild("LegTeleportGui")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- GUI
--==================================================

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

--==================================================
-- 제목
--==================================================

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

--==================================================
-- 닫기
--==================================================

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

--==================================================
-- 공통 버튼
--==================================================

local function StyleButton(Button)
	Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button
end

--==================================================
-- TP 버튼
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.Parent = MainFrame

StyleButton(ToggleButton)

--==================================================
-- 친구 버튼
--==================================================

local FriendButton = Instance.new("TextButton")
FriendButton.Name = "FriendButton"
FriendButton.Size = UDim2.new(1, -20, 0, 35)
FriendButton.Position = UDim2.new(0, 10, 0, 85)
FriendButton.Parent = MainFrame

StyleButton(FriendButton)

--==================================================
-- TextBox 기반 값 조절
--==================================================

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

	-- 입력 완료
	Box.FocusLost:Connect(function()

		local Number = tonumber(Box.Text)

		if Number then
			Setter(Number)
			Box.Text = tostring(Number)
		else
			-- 잘못 입력하면 기존 값으로 복구
			Box.Text = tostring(Getter())
		end

	end)
end

--==================================================
-- 위치
--==================================================

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


--==================================================
-- 회전
--==================================================

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
--==================================================
-- GUI 업데이트
--==================================================

local function UpdateGUI()
	if Enabled then
		ToggleButton.Text = "TP : ON"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(50, 170, 80)
	else
		ToggleButton.Text = "TP : OFF"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(170, 50, 50)
	end

	if ExcludeFriends then
		FriendButton.Text = "친구 제외 : ON"
	else
		FriendButton.Text = "친구 제외 : OFF"
	end
end

UpdateGUI()

--==================================================
-- 버튼
--==================================================

ToggleButton.MouseButton1Click:Connect(function()
	Enabled = not Enabled

	if not Enabled then
		CurrentTarget = nil
	end

	UpdateGUI()
end)

FriendButton.MouseButton1Click:Connect(function()
	ExcludeFriends = not ExcludeFriends

	-- 친구 제외 설정이 바뀌면
	-- 현재 타겟도 다시 검사
	CurrentTarget = nil

	UpdateGUI()
end)

CloseButton.MouseButton1Click:Connect(function()
	Enabled = false
	ScreenGui:Destroy()
end)

--==================================================
-- GUI 드래그
--==================================================

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

--==================================================
-- 친구 확인
--==================================================

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

--==================================================
-- 타겟 검색
--==================================================

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

--==================================================
-- 타겟 유효성
--==================================================

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

	-- 친구 제외가 켜진 상태에서
	-- 현재 타겟이 친구가 된 경우도 제외
	if ExcludeFriends and Target.Player then

		if IsFriend(Target.Player) then
			return false
		end

	end

	return true
end

--==================================================
-- TP
--==================================================
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

	--========================================
	-- 위치
	--========================================

	local LocalOffset = Vector3.new(
		OffsetX,
		OffsetY,
		OffsetZ
	)

	local WorldPosition =
		TargetRoot.CFrame:PointToWorldSpace(LocalOffset)

	--========================================
	-- 상대를 바라보는 방향
	--========================================

	local Direction =
		TargetRoot.Position - WorldPosition

	if Direction.Magnitude < 0.001 then
		return
	end

	Direction = Direction.Unit

	--========================================
	-- 땅 기준으로 상대를 바라보는 방향 계산
	--========================================

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

	--========================================
	-- 기본 방향
	--========================================

	local BaseCFrame =
		CFrame.lookAt(
			WorldPosition,
			WorldPosition + FlatDirection,
			Vector3.new(0, 1, 0)
		)

	--========================================
	-- 회전
	--========================================

	local RotationCFrame =
		CFrame.fromEulerAnglesXYZ(
			math.rad(RotationX),
			math.rad(RotationY),
			math.rad(RotationZ)
		)

	--========================================
	-- 최종
	--========================================

	MyRoot.CFrame =
		BaseCFrame * RotationCFrame
end

--==================================================
-- 현재 타겟
--==================================================

CurrentTarget = nil

--==================================================
-- 메인 루프
--==================================================

--==================================================
-- 현재 타겟
--==================================================

local CurrentTarget = nil

--==================================================
-- 메인 루프
--==================================================

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

--==================================================
-- 값 변경 감지
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		UpdateGUI()
		task.wait(0.05)
	end
end)

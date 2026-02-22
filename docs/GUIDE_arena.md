# 🏟️ Interactive Guide: Building the Pong Parry Arena in Godot 4.6

> **Goal**: Build the game arena from the design mockup — the court, paddles, ball, HUD, and basic gameplay.
> **Time**: ~90–120 minutes | **Difficulty**: Intermediate
> **What you'll learn**: Custom `_draw()`, `_process()`, `_physics_process()`, input handling, timers, signals, containers, and game logic in GDScript.

---

## 📐 Overview of What We're Building

```
┌──────────────────────────────────────────────────────────┐
│ 🔇  ┌──01──┐ TIME REMAINING ┌──00──┐     Boot Title Game │
│     │ cyan │    2:45        │white │                     │
│     └──────┘                └──────┘                     │
│  ┌──────────────────────────────────────────────────┐    │
│  │  ┃                    │                     ┃    │    │
│  │  ┃   ██ (P1 paddle)   │       ●→→→         ┃    │    │
│  │  ┃   cyan             │     (ball)    ██    ┃    │    │
│  │  ┃                    ◯                ██   ┃    │    │
│  │  ┃                    │          (P2 paddle)┃    │    │
│  │  ┃                    │              white  ┃    │    │
│  │  ┃                    │                     ┃    │    │
│  └──────────────────────────────────────────────────┘    │
│  P1 • OVERDRIVE ███████░░░░    ░░░░███████ OVERDRIVE • P2│
│  [▶▶ Q] [🛡 4.2]                       [🛡 L] [⊕ K]    │
│                    ESC TO QUIT MATCH                     │
└──────────────────────────────────────────────────────────┘
```

---

## Phase 0: Scene Setup (5 min)

### Step 0.1 — Create the Arena Scene

1. Go to **Scene → New Scene** (top menu)
2. Click **Other Node** → search for `Node2D` → Create
3. Rename the root to `Arena`
4. Save: **Cmd+S** → save as `res://scenes/arena/arena.tscn`

> 💡 **Why Node2D instead of Control?** We're separating the **game world** from the **UI**. The game world (court, paddles, ball) uses `Node2D` — positioned by pixel coordinates, no auto-layout. The HUD goes inside a `CanvasLayer`, which renders on a separate layer **on top** of the game world, so it never scrolls or moves with the camera.

### Step 0.2 — Understand the Full Node Tree

Here's everything we'll build. Don't create it all yet — we go step by step:

```
Arena (Node2D)                                — game world root
├── Background (ColorRect)                    — full-screen dark bg with grid shader
├── Court (Node2D)                            — the playing field
│   ├── CourtBorder (Control)                 — script draws border with colored edges
│   ├── CourtLines (Control)                  — script draws center line + circle
│   ├── LeftPaddle (ColorRect)                — P1 paddle
│   ├── RightPaddle (ColorRect)               — P2 paddle
│   └── Ball (ColorRect)                      — the ball
├── HUDLayer (CanvasLayer)                    — separate rendering layer for UI
│   └── HUD (Control)                         — UI root (Full Rect)
│       ├── TopBar (HBoxContainer)            — scores + timer
│       │   ├── P1ScoreBox (PanelContainer)
│       │   │   └── P1ScoreLabel (Label)      — "01"
│       │   ├── TimerContainer (VBoxContainer)
│       │   │   ├── TimeRemainingLabel (Label) — "TIME REMAINING"
│       │   │   └── TimerValue (Label)         — "2:45"
│       │   └── P2ScoreBox (PanelContainer)
│       │       └── P2ScoreLabel (Label)      — "00"
│       ├── P1HUD (VBoxContainer)             — bottom-left player info
│       │   ├── P1Label (Label)               — "P1 • OVERDRIVE"
│       │   ├── P1OverdriveBar (ProgressBar)
│       │   └── P1Abilities (HBoxContainer)
│       │       ├── AbilitySlot1 (PanelContainer)
│       │       └── AbilitySlot2 (PanelContainer)
│       ├── P2HUD (VBoxContainer)             — bottom-right player info
│       │   ├── P2Label (Label)               — "OVERDRIVE • P2"
│       │   ├── P2OverdriveBar (ProgressBar)
│       │   └── P2Abilities (HBoxContainer)
│       │       ├── AbilitySlot1 (PanelContainer)
│       │       └── AbilitySlot2 (PanelContainer)
│       └── QuitLabel (Label)                 — "ESC TO QUIT MATCH"
└── ArenaScript (attached to Arena root)
```

> 💡 **What you learned**: This is a standard game architecture pattern:
> - **`Node2D`** branch = game world (paddles, ball, court). Positioned with pixel coordinates. If you add a camera later, these move with it.
> - **`CanvasLayer`** branch = HUD/UI. Renders on top of everything and **never moves** with the camera. Inside it, `Control` nodes use anchors and containers just like the title screen.
> - This separation means you can shake the screen, zoom the camera, or add effects to the game world without messing up the HUD.

---

## Phase 1: Background (5 min)

### Step 1.1 — Add the Background

1. Select `Arena` → Add Child → `ColorRect` → Create
2. Rename to `Background`
3. Since the parent is a `Node2D` (not a `Control`), anchor presets won't work. Set the size manually:
   - **Position**: `x: 0, y: 0`
   - **Size**: `x: 1920, y: 1080`
4. Set **Color**: `#0A0E14` (very dark blue-black)

### Step 1.2 — Apply the Grid Shader (Optional)

You already have a grid shader at `res://assets/shaders/grid_background.gdshader`. Let's reuse it:

1. With `Background` selected, in Inspector find **Material**
2. Click `[empty]` → **New ShaderMaterial**
3. Click the ShaderMaterial to expand → **Shader** → click `[empty]` → **Load** → select `res://assets/shaders/grid_background.gdshader`
4. Set shader parameters:
   - **bg_color**: `#0A0E14`
   - **line_color**: `#1A222C`
   - **cell_size**: `40`
   - **line_thickness**: `1.0`
   - **scroll_speed**: `0.0`
   - **vignette_intensity**: `1.5`

> 💡 **What you learned**: You can reuse the same shader across multiple scenes. Each `ShaderMaterial` instance has its own parameter values, so the background can look different in the arena vs the title screen.

---

## Phase 2: The Court (20 min)

The court is the rounded rectangle playing field in the center of the screen.

### Step 2.1 — Create the Court Container

1. Select `Arena` → Add Child → `Node2D` → Create
2. Rename to `Court`
3. Set **Position**: `x: 80, y: 90` (offset from top-left to leave room for the HUD)

> 💡 **What you learned**: Unlike `Control` nodes, `Node2D` uses simple x/y coordinates. We position the court manually by setting its origin. All children will be relative to this position.

### Step 2.2 — Draw the Court Border (Script)

We'll use a `Control` child with `_draw()` to render the court's border. We use `Control` here because it has a `size` property, which makes drawing rectangles easier.

1. Select `Court` → Add Child → `Control` → Create
2. Rename to `CourtBorder`
3. Set **Size**: `x: 1760, y: 850` (1920 - 160 padding, 1080 - 230 for top/bottom HUD)
4. Attach a new script → save as `res://scenes/arena/court_border.gd`
5. Write this code:

```gdscript
extends Control

func _draw() -> void:
    var rect := Rect2(Vector2.ZERO, size)
    var corner_radius := 16.0

    # Dark court background
    var bg_color := Color("#0D1117")
    draw_rect(rect, bg_color, true)

    # Court border
    var border_color := Color("#1A222C")
    # Top edge
    draw_line(Vector2(corner_radius, 0), Vector2(size.x - corner_radius, 0), border_color, 2.0)
    # Bottom edge
    draw_line(Vector2(corner_radius, size.y), Vector2(size.x - corner_radius, size.y), border_color, 2.0)
    # Left edge — cyan tinted
    draw_line(Vector2(0, corner_radius), Vector2(0, size.y - corner_radius), Color("#00D2FF", 0.4), 2.0)
    # Right edge — white tinted
    draw_line(Vector2(size.x, corner_radius), Vector2(size.x, size.y - corner_radius), Color("#FFFFFF", 0.4), 2.0)
```

6. Press **F6** to test — you should see a dark rectangle with faintly colored edges.

> 💡 **What you learned**: Even inside a `Node2D` tree, you can use `Control` nodes for drawing when you need a `size` property. `draw_line()` takes a start point, end point, color, and thickness. We use different colors per side to match the player themes (cyan = P1, white = P2).

### Step 2.3 — Draw the Center Line and Circle

1. Select `Court` → Add Child → `Control` → Create
2. Rename to `CourtLines`
3. Set **Size**: same as `CourtBorder` — `x: 1760, y: 850`
4. Attach a new script → save as `res://scenes/arena/court_lines.gd`
5. Write this code:

```gdscript
extends Control

func _draw() -> void:
    var center := size / 2.0
    var line_color := Color("#1A222C")

    # Vertical center line
    draw_line(Vector2(center.x, 0), Vector2(center.x, size.y), line_color, 2.0)

    # Center circle
    var radius := 200.0
    draw_arc(center, radius, 0, TAU, 64, line_color, 2.0)

    # Side tick marks (ruler lines along left and right edges)
    var tick_length := 20.0
    var tick_spacing := 40.0
    var tick_color := Color("#2D3748")
    var y := tick_spacing
    while y < size.y:
        # Left side ticks
        draw_line(Vector2(0, y), Vector2(tick_length, y), tick_color, 1.0)
        # Right side ticks
        draw_line(Vector2(size.x - tick_length, y), Vector2(size.x, y), tick_color, 1.0)
        y += tick_spacing
```

6. Press **F6** to test — you should see the center line, circle, and ruler ticks.

> 💡 **What you learned**:
> - `draw_arc()` with `0` to `TAU` draws a full circle. The `64` is segment count — higher = smoother.
> - A `while` loop lets you repeat drawing at intervals. This creates the ruler-like tick marks.

### Step 2.4 — Add the Left Paddle (P1)

1. Select `Court` → Add Child → `ColorRect` → Create
2. Rename to `LeftPaddle`
3. In Inspector:
   - **Color**: `#00D2FF` (cyan)
   - **Custom Minimum Size**: `x: 16, y: 120`
   - **Size**: `x: 16, y: 120`
4. Position it manually:
   - **Position X**: `40` (offset from the left edge)
   - **Position Y**: center it vertically — set to `(court_height / 2) - 60`. For now, just eyeball it around `y: 340`

> 💡 **What you learned**: Paddles are just `ColorRect` nodes! We'll add movement via script later. Keeping game objects simple makes them easy to prototype.

### Step 2.5 — Add the Right Paddle (P2)

1. Select `Court` → Add Child → `ColorRect` → Create
2. Rename to `RightPaddle`
3. In Inspector:
   - **Color**: `#FFFFFF` (white)
   - **Custom Minimum Size**: `x: 16, y: 120`
   - **Size**: `x: 16, y: 120`
4. Position it:
   - **Position X**: near the right edge — around `court_width - 56`. Eyeball it for now, around `x: 1704`
   - **Position Y**: same vertical center as P1, around `y: 340`

### Step 2.6 — Add the Ball

1. Select `Court` → Add Child → `ColorRect` → Create
2. Rename to `Ball`
3. In Inspector:
   - **Color**: `#FFFFFF` (white)
   - **Custom Minimum Size**: `x: 20, y: 20`
   - **Size**: `x: 20, y: 20`
4. Position it at the center of the court:
   - **Position X**: center — around `(court_width / 2) - 10`
   - **Position Y**: center — around `(court_height / 2) - 10`

> ✅ **Checkpoint**: Press **F6**. You should see:
> - Dark court with colored borders
> - Center line and circle
> - A cyan paddle on the left, white paddle on the right
> - A white square ball in the center
>
> It won't move yet — that comes in Phase 5!

---

## Phase 3: Top HUD — Scores & Timer (20 min)

### Step 3.1 — Create the HUD Layer

1. Select `Arena` → Add Child → `CanvasLayer` → Create
2. Rename to `HUDLayer`
3. In Inspector, set **Layer**: `1` (this ensures it draws on top of the game world)
4. Select `HUDLayer` → Add Child → `Control` → Create
5. Rename to `HUD`
6. Set **Anchor Preset**: **Full Rect** (Layout → Full Rect)

> 💡 **What you learned**: `CanvasLayer` creates a separate rendering layer. Anything inside it is **independent from the game world** — if you later add a Camera2D to shake or zoom the court, the HUD stays perfectly still. The `Control` node inside gives us anchors and containers for UI layout.

### Step 3.2 — Create the Top Bar Container

1. Select `HUD` → Add Child → `HBoxContainer` → Create
2. Rename to `TopBar`
3. Set **Anchor Preset**: **Top Wide** (stretches across the top)
4. Set **Custom Minimum Size**: `y: 80`
5. In Inspector → **Theme Overrides → Constants**:
   - **Separation**: `0`
6. **Alignment**: `Center`

### Step 3.3 — Create P1 Score Box

1. Select `TopBar` → Add Child → `PanelContainer` → Create
2. Rename to `P1ScoreBox`
3. In Inspector → **Theme Overrides → Styles → Panel**:
   - Click `[empty]` → **New StyleBoxFlat**
   - **BG Color**: `#00D2FF` (cyan)
   - **Skew**: `0.15` (creates the slanted trapezoid shape)
   - **Content Margin**: Left `24`, Top `8`, Right `24`, Bottom `8`
4. **Custom Minimum Size**: `x: 120, y: 70`
5. Add a child: `PanelContainer` → Add Child → `Label` → Create
6. Rename to `P1ScoreLabel`
7. In Inspector:
   - **Text**: `01`
   - **Horizontal Alignment**: `Center`
   - **Vertical Alignment**: `Center`
   - **Theme Overrides → Fonts**: your bold italic font (Montserrat Black Italic)
   - **Theme Overrides → Font Sizes**: `48`
   - **Theme Overrides → Colors → Font Color**: `#000000` (black on cyan)

### Step 3.4 — Create the Timer

1. Select `TopBar` → Add Child → `VBoxContainer` → Create
2. Rename to `TimerContainer`
3. **Custom Minimum Size**: `x: 240`
4. **Theme Overrides → Constants → Separation**: `0`
5. **Alignment**: `Center`
6. Add first child: `Label` → rename to `TimeRemainingLabel`
   - **Text**: `TIME REMAINING`
   - **Horizontal Alignment**: `Center`
   - **Theme Overrides → Font Sizes**: `12`
   - **Theme Overrides → Colors → Font Color**: `#A0AEC0` (light grey)
   - **Theme Overrides → Fonts**: your bold font (Montserrat Black)
7. Add second child: `Label` → rename to `TimerValue`
   - **Text**: `2:45`
   - **Horizontal Alignment**: `Center`
   - **Theme Overrides → Fonts**: your bold italic font
   - **Theme Overrides → Font Sizes**: `40`
   - **Theme Overrides → Colors → Font Color**: `#FFFFFF` (white)

### Step 3.5 — Create P2 Score Box

1. Select `TopBar` → Add Child → `PanelContainer` → Create
2. Rename to `P2ScoreBox`
3. Style it the same as P1, but with different colors:
   - **BG Color**: `#FFFFFF` (white)
   - **Skew**: `-0.15` (slant the other direction to mirror P1!)
   - **Content Margin**: same as P1
   - **Custom Minimum Size**: `x: 120, y: 70`
4. Add child `Label` → rename `P2ScoreLabel`
   - **Text**: `00`
   - Same font/size as P1
   - **Font Color**: `#000000` (black on white)

> ✅ **Checkpoint**: Press **F6**. The top bar should show a cyan "01" box, timer in the middle, and white "00" box, all centered at the top.

> 💡 **What you learned**:
> - `PanelContainer` provides a styled background behind its children. Combined with `StyleBoxFlat`, it's perfect for score boxes.
> - Opposite **Skew** values on P1 and P2 create a mirrored trapezoid effect.
> - `VBoxContainer` stacks the timer label and value vertically with automatic alignment.

---

## Phase 4: Bottom HUD — Player Info & Abilities (20 min)

### Step 4.1 — Create P1 HUD (Bottom-Left)

1. Select `HUD` → Add Child → `VBoxContainer` → Create
2. Rename to `P1HUD`
3. Set **Anchor Preset**: **Bottom Left**
4. Set offsets:
   - **Offset Left**: `80`
   - **Offset Bottom**: `-60`
   - **Offset Top**: `-200`
   - **Offset Right**: `460`
5. **Theme Overrides → Constants → Separation**: `8`

### Step 4.2 — P1 Label

1. Select `P1HUD` → Add Child → `Label` → Create
2. Rename to `P1Label`
3. In Inspector:
   - **Text**: `P1 • OVERDRIVE`
   - **Theme Overrides → Fonts**: your bold font
   - **Theme Overrides → Font Sizes**: `14`
   - **Theme Overrides → Colors → Font Color**: `#00D2FF` (cyan)

### Step 4.3 — P1 Overdrive Bar

1. Select `P1HUD` → Add Child → `ProgressBar` → Create
2. Rename to `P1OverdriveBar`
3. In Inspector:
   - **Min Value**: `0`
   - **Max Value**: `100`
   - **Value**: `65` (for testing)
   - **Show Percentage**: OFF
   - **Custom Minimum Size**: `y: 4`
4. Style it:
   - **Theme Overrides → Styles → Fill**:
     - New `StyleBoxFlat` → **BG Color**: `#00D2FF` (cyan)
   - **Theme Overrides → Styles → Background**:
     - New `StyleBoxFlat` → **BG Color**: `#1A222C` (dark)

> 💡 **What you learned**: `ProgressBar` is perfect for meters like overdrive/health/energy. You style the "fill" and "background" separately. The `value` property controls how full it is — you'll update this from code later.

### Step 4.4 — P1 Ability Slots

1. Select `P1HUD` → Add Child → `HBoxContainer` → Create
2. Rename to `P1Abilities`
3. **Theme Overrides → Constants → Separation**: `8`
4. Add first ability slot:
   - Add Child → `PanelContainer` → rename `AbilitySlot1`
   - **Custom Minimum Size**: `x: 64, y: 64`
   - **Theme Overrides → Styles → Panel**: New `StyleBoxFlat`
     - **BG Color**: `#1A222C`
     - **Border Width** (all sides): `2`
     - **Border Color**: `#2D3748`
     - **Corner Radius** (all): `4`
   - Add child `Label` inside:
     - **Text**: `Q`
     - **Horizontal Alignment**: `Center`
     - **Vertical Alignment**: `Bottom`
     - **Theme Overrides → Font Sizes**: `12`
     - **Theme Overrides → Colors → Font Color**: `#A0AEC0`
5. Duplicate `AbilitySlot1` (Cmd+D) → rename to `AbilitySlot2`
   - Change the label text to `E`

> 💡 **What you learned**: Duplicating nodes (Cmd+D) is the fastest way to create similar UI elements. You can then tweak just the differences (text, icons). In a real game, you'd make each ability slot a **reusable scene** — but for now, inline is fine.

### Step 4.5 — P2 HUD (Bottom-Right)

Mirror the P1 HUD for Player 2:

1. Select `HUD` → Add Child → `VBoxContainer` → Create
2. Rename to `P2HUD`
3. Set **Anchor Preset**: **Bottom Right**
4. Set offsets:
   - **Offset Right**: `-80`
   - **Offset Bottom**: `-60`
   - **Offset Top**: `-200`
   - **Offset Left**: `-460`
5. **Theme Overrides → Constants → Separation**: `8`
6. Add children the same as P1, but mirrored:
   - `P2Label` → Text: `OVERDRIVE • P2`, Font Color: `#FFFFFF`
   - `P2OverdriveBar` → Fill color: `#FFFFFF` (white)
   - `P2Abilities` → Two slots with labels `L` and `K`
7. For the P2 label, set **Horizontal Alignment**: `Right`

### Step 4.6 — Quit Label (Footer)

1. Select `HUD` → Add Child → `Label` → Create
2. Rename to `QuitLabel`
3. Set **Anchor Preset**: **Center Bottom**
4. Set **Offset Bottom**: `-20`
5. In Inspector:
   - **Text**: `ESC TO QUIT MATCH`
   - **Horizontal Alignment**: `Center`
   - **Theme Overrides → Fonts**: your bold font
   - **Theme Overrides → Font Sizes**: `12`
   - **Theme Overrides → Colors → Font Color**: `#A0AEC0` (muted grey)

> ✅ **Checkpoint**: Press **F6**. Your full arena layout should now be visible:
> - Scores and timer at the top
> - Court with paddles and ball in the center
> - Player HUDs with overdrive bars and ability slots at the bottom
> - "ESC TO QUIT MATCH" at the footer

---

## Phase 5: Basic Gameplay Script (20 min)

Now the fun part — making things move!

### Step 5.1 — Set Up Input Actions

Before writing code, define the input mappings:

1. Go to **Project → Project Settings → Input Map**
2. Add these actions (type the name, press **Add**):
   - `p1_up` → Click **+** → press **W** key
   - `p1_down` → Click **+** → press **S** key
   - `p2_up` → Click **+** → press **Up Arrow** key
   - `p2_down` → Click **+** → press **Down Arrow** key

> 💡 **What you learned**: **Input Map** lets you define named actions and bind them to keys, gamepad buttons, or mouse inputs. Using `Input.is_action_pressed("p1_up")` in code is cleaner than checking specific keys, and lets you rebind controls easily.

### Step 5.2 — Create the Arena Script

1. Select `Arena` (root node) → click the **📜 script** icon → **New Script**
2. Save as `res://scenes/arena/arena.gd`
3. Start with references to nodes:

```gdscript
extends Node2D

# Court elements
@onready var left_paddle: ColorRect = $Court/LeftPaddle
@onready var right_paddle: ColorRect = $Court/RightPaddle
@onready var ball: ColorRect = $Court/Ball
@onready var court_border: Control = $Court/CourtBorder

# HUD elements (note: path goes through HUDLayer → HUD)
@onready var p1_score_label: Label = $HUDLayer/HUD/TopBar/P1ScoreBox/P1ScoreLabel
@onready var p2_score_label: Label = $HUDLayer/HUD/TopBar/P2ScoreBox/P2ScoreLabel
@onready var timer_value: Label = $HUDLayer/HUD/TopBar/TimerContainer/TimerValue

# Game state
var paddle_speed: float = 600.0
var ball_velocity: Vector2 = Vector2(400, 250)
var p1_score: int = 0
var p2_score: int = 0
var match_time: float = 180.0  # 3 minutes in seconds
```

> 💡 **What you learned**: `@onready` references use **node paths** relative to the script's node. `$Court/LeftPaddle` walks down the tree: Court → LeftPaddle. Game state variables at the top of the script make them easy to find and tweak.

### Step 5.3 — Paddle Movement

Add this function to `arena.gd`:

```gdscript
func _process(delta: float) -> void:
    _move_paddles(delta)
    _move_ball(delta)
    _update_timer(delta)

func _move_paddles(delta: float) -> void:
    # Player 1 (W/S)
    if Input.is_action_pressed("p1_up"):
        left_paddle.position.y -= paddle_speed * delta
    if Input.is_action_pressed("p1_down"):
        left_paddle.position.y += paddle_speed * delta

    # Player 2 (Up/Down arrows)
    if Input.is_action_pressed("p2_up"):
        right_paddle.position.y -= paddle_speed * delta
    if Input.is_action_pressed("p2_down"):
        right_paddle.position.y += paddle_speed * delta

    # Clamp paddles to court bounds
    left_paddle.position.y = clamp(left_paddle.position.y, 0, court_border.size.y - left_paddle.size.y)
    right_paddle.position.y = clamp(right_paddle.position.y, 0, court_border.size.y - right_paddle.size.y)
```

> 💡 **What you learned**:
> - `_process(delta)` runs every frame. `delta` is the time since last frame (~0.016s at 60fps). Multiplying speed by delta makes movement **framerate-independent**.
> - `clamp()` restricts a value between a min and max — this stops paddles from leaving the court.
> - `Input.is_action_pressed()` checks if the player is holding a key.

### Step 5.4 — Ball Movement & Bouncing

Add ball logic to `arena.gd`:

```gdscript
func _move_ball(delta: float) -> void:
    ball.position += ball_velocity * delta

    # Bounce off top and bottom walls
    if ball.position.y <= 0 or ball.position.y + ball.size.y >= court_border.size.y:
        ball_velocity.y = -ball_velocity.y

    # Check paddle collisions
    var ball_rect := Rect2(ball.position, ball.size)
    var left_rect := Rect2(left_paddle.position, left_paddle.size)
    var right_rect := Rect2(right_paddle.position, right_paddle.size)

    if ball_rect.intersects(left_rect) and ball_velocity.x < 0:
        ball_velocity.x = -ball_velocity.x
        ball_velocity *= 1.05  # Speed up slightly each hit

    if ball_rect.intersects(right_rect) and ball_velocity.x > 0:
        ball_velocity.x = -ball_velocity.x
        ball_velocity *= 1.05

    # Scoring — ball goes past left or right edge
    if ball.position.x + ball.size.x < 0:
        _score(2)  # P2 scores
    elif ball.position.x > court_border.size.x:
        _score(1)  # P1 scores
```

> 💡 **What you learned**:
> - `Rect2.intersects()` checks if two rectangles overlap — this is the simplest form of collision detection, perfect for Pong.
> - `ball_velocity *= 1.05` increases speed by 5% on each hit, making rallies more intense.
> - We check `ball_velocity.x < 0` before bouncing off the left paddle to prevent double-bouncing.

### Step 5.5 — Scoring & Reset

```gdscript
func _score(player: int) -> void:
    if player == 1:
        p1_score += 1
        p1_score_label.text = "%02d" % p1_score
    else:
        p2_score += 1
        p2_score_label.text = "%02d" % p2_score
    _reset_ball()

func _reset_ball() -> void:
    ball.position = court_border.size / 2.0 - ball.size / 2.0
    # Alternate serve direction, add some randomness
    var direction := -1.0 if ball_velocity.x > 0 else 1.0
    ball_velocity = Vector2(400 * direction, randf_range(-250, 250))
```

> 💡 **What you learned**:
> - `"%02d" % score` formats a number with leading zeros — `1` becomes `"01"`, `12` stays `"12"`.
> - `randf_range(-250, 250)` gives a random vertical angle each serve, so the game stays unpredictable.

### Step 5.6 — Match Timer

```gdscript
func _update_timer(delta: float) -> void:
    match_time -= delta
    if match_time <= 0:
        match_time = 0
        # TODO: End the match
    var minutes := int(match_time) / 60
    var seconds := int(match_time) % 60
    timer_value.text = "%d:%02d" % [minutes, seconds]
```

### Step 5.7 — ESC to Quit

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):  # ESC is mapped to ui_cancel by default
        Transition.transition_to("res://scenes/title_screen/title_screen.tscn")
```

> 💡 **What you learned**: Godot has built-in input actions like `ui_cancel` (ESC), `ui_accept` (Enter), `ui_up/down/left/right` (arrows). You don't need to define these — they already exist!

---

## Phase 6: Polish — Paddle Glow Effect (10 min)

The mockup shows paddles with a soft glow. You can fake this with a second, larger, semi-transparent ColorRect behind each paddle.

### Step 6.1 — Add a Glow Behind P1 Paddle

1. Select `Court` → Add Child → `ColorRect` → Create
2. Rename to `LeftPaddleGlow`
3. In Inspector:
   - **Color**: `#00D2FF` with alpha at ~`0.15` (so `#00D2FF26`)
   - **Size**: `x: 40, y: 150` (larger than the paddle)
4. **In the Scene tree**, drag `LeftPaddleGlow` **above** `LeftPaddle` so it draws behind
5. You'll need to update its position in the arena script to follow the paddle:

Add to `_move_paddles()`:

```gdscript
# Update glow positions (add @onready vars for these at the top)
left_paddle_glow.position = left_paddle.position - Vector2(12, 15)
right_paddle_glow.position = right_paddle.position - Vector2(12, 15)
```

### Step 6.2 — Repeat for P2

1. Duplicate `LeftPaddleGlow` → rename `RightPaddleGlow`
2. **Color**: `#FFFFFF26` (white at ~15% opacity)
3. Make sure it's above `RightPaddle` in the scene tree

> 💡 **What you learned**: A common game dev trick for "glow" is to layer a larger, semi-transparent copy behind an object. Real glow effects use shaders, but this simple approach looks surprisingly good and costs nothing performance-wise.

---

## Phase 7: Test & Verify (5 min)

1. Press **F6** to run the arena scene
2. Test:
   - **W/S** moves the left paddle
   - **Up/Down arrows** move the right paddle
   - The ball bounces off walls and paddles
   - Score updates when the ball passes a paddle
   - Timer counts down
   - **ESC** quits to the title screen

> ✅ **Final Checkpoint**: You should have a fully playable Pong arena with:
> - Styled court with center markings
> - Two moving paddles with player-themed colors
> - A bouncing ball with speed increase on hits
> - Live scoreboard and countdown timer
> - Player HUD areas with overdrive bars and ability slots
> - ESC to quit

---

## 🧠 Concepts You Learned

| Concept | Where You Used It |
|---|---|
| **Custom Drawing** | `_draw()` for court border, center line, circle, tick marks |
| **`_process(delta)`** | Frame-by-frame paddle/ball movement |
| **Input Actions** | Named inputs (p1_up, p2_up) via Input Map |
| **Rect2 Collision** | Ball-paddle intersection checks |
| **clamp()** | Keeping paddles inside the court |
| **String Formatting** | `"%02d"` for scores, `"%d:%02d"` for timer |
| **Game State Variables** | Scores, velocity, timer at the top of the script |
| **Node2D vs Control** | Node2D for game world, Control for UI elements |
| **CanvasLayer** | Separate rendering layer so HUD stays fixed during camera effects |
| **Node Organization** | Separating Court (gameplay) from HUD (UI) |
| **ProgressBar** | Overdrive meters with custom styling |
| **PanelContainer + StyleBoxFlat** | Score boxes and ability slots |
| **Signal: ui_cancel** | Built-in ESC key handling |
| **Glow Trick** | Layered semi-transparent ColorRect for fake glow |

---

## 🎯 Bonus Challenges

1. **Ball trail**: Add a `Line2D` or `GPUParticles2D` behind the ball for the motion blur effect
2. **Screen shake**: When a point is scored, briefly offset the court position and tween it back
3. **Sound effects**: Play a `ping` sound on paddle hit, `score` sound on goal
4. **AI opponent**: Replace P2 input with code that moves toward the ball's Y position
5. **Overdrive mechanic**: Fill the overdrive bar on successful parries, trigger a speed boost at 100%
6. **Parry system**: If the paddle hits the ball at the edge (timing-based), trigger a "parry" with screen flash and faster return

---

## 🔗 Godot Docs Reference

- [Custom Drawing in 2D](https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html)
- [Input Handling](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html)
- [Input Map](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html#inputmap)
- [ProgressBar](https://docs.godotengine.org/en/stable/classes/class_progressbar.html)
- [PanelContainer](https://docs.godotengine.org/en/stable/classes/class_panelcontainer.html)
- [Rect2](https://docs.godotengine.org/en/stable/classes/class_rect2.html)
- [Tween (for polish)](https://docs.godotengine.org/en/stable/classes/class_tween.html)

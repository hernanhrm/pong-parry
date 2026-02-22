extends Node2D

# Court elements
@onready var left_paddle: ColorRect = $Court/LeftPaddle
@onready var left_paddle_glow: ColorRect = $Court/LeftPaddleGlow

@onready var right_paddle: ColorRect = $Court/RightPaddle
@onready var right_paddle_glow: ColorRect = $Court/RightPaddleGlow


@onready var ball: ColorRect = $Court/Ball
@onready var court_border: Control = $Court/CourtBorder

@onready var hit_wall_sound: AudioStreamPlayer = $HitWall
@onready var hit_sound_paddle: AudioStreamPlayer = $HitPaddle

# HUD elements (note: path goes through HUDLayer → HUD)
@onready var p1_score_label: Label = $HUDLayer/HUD/TopBar/P1ScoreBox/P1ScoreLabel
@onready var timer_value: Label = $HUDLayer/HUD/TopBar/TimerContainer/TimerValue
@onready var p2_score_label: Label = $HUDLayer/HUD/TopBar/P2ScoreBox/P2ScoreLabel

@onready var p1_progress_bar = $HUDLayer/HUD/MarginContainer/P1HUD/P1OverdriveBar
@onready var p2_progress_bar = $HUDLayer/HUD/MarginContainer/P2HUD/P2OverdriveBar


# Constants
const COURT_PADDING: float = 10.0
const GLOW_OFFSET: Vector2 = Vector2(8, 8)
const BALL_SPEED_MULTIPLIER: float = 1.1
const BALL_RESET_SPEED: float = 400.0
const BALL_RESET_Y_RANGE: float = 250.0
const STREAK_MULTIPLIER: int = 10

# Game state
var paddle_speed: float = 600.0
var ball_velocity: Vector2 = Vector2(500, 350)

var p1_score: int = 0
var p1_streak: int = 0

var p2_score: int = 0
var p2_streak: int = 0

var match_time: float = 180.0  # 3 minutes in seconds
var is_timer_finished: bool = false

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(MusicManager.bg_music, "volume_db", -20.0, 2.0)


func _process(delta: float) -> void:
	if !is_timer_finished:
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
	left_paddle.position.y = clamp(left_paddle.position.y, COURT_PADDING, court_border.size.y - COURT_PADDING - left_paddle.size.y)
	right_paddle.position.y = clamp(right_paddle.position.y, COURT_PADDING, court_border.size.y - COURT_PADDING - right_paddle.size.y)

	# Update glow positions 
	left_paddle_glow.position = left_paddle.position - GLOW_OFFSET
	right_paddle_glow.position = right_paddle.position - GLOW_OFFSET

func _move_ball(delta: float) -> void:
	ball.position += ball_velocity * delta

	# Bounce off top and bottom walls
	if ball.position.y <= 0 or ball.position.y + ball.size.y >= court_border.size.y:
		hit_wall_sound.play()
		ball_velocity.y = -ball_velocity.y

	# Check paddle collisions
	var ball_rect := Rect2(ball.position, ball.size)
	var left_rect := Rect2(left_paddle.position, left_paddle.size)
	var right_rect := Rect2(right_paddle.position, right_paddle.size)

	if ball_rect.intersects(left_rect) and ball_velocity.x < 0:
		hit_sound_paddle.play()
		ball_velocity.x = -ball_velocity.x
		ball_velocity *= BALL_SPEED_MULTIPLIER

	if ball_rect.intersects(right_rect) and ball_velocity.x > 0:
		hit_sound_paddle.play()
		ball_velocity.x = -ball_velocity.x
		ball_velocity *= BALL_SPEED_MULTIPLIER

	# Scoring — ball goes past left or right edge
	if ball.position.x + ball.size.x < 0:
		_score(2)  # P2 scores
	elif ball.position.x > court_border.size.x:
		_score(1)  # P1 scores

func _score(player: int) -> void:
	if player == 1:
		p1_score += 1
		p1_score_label.text = "%02d" % p1_score

		p2_streak = 0
		p1_streak += 1
		p1_progress_bar.value += p1_streak * STREAK_MULTIPLIER

	else:
		p2_score += 1
		p2_score_label.text = "%02d" % p2_score

		p2_streak += 1
		p1_streak = 0
		p2_progress_bar.value += p2_streak * STREAK_MULTIPLIER
	_reset_ball()

func _reset_ball() -> void:
	ball.position = court_border.size / 2.0 - ball.size / 2.0
	# Alternate serve direction, add some randomness
	var direction := -1.0 if ball_velocity.x > 0 else 1.0
	ball_velocity = Vector2(BALL_RESET_SPEED * direction, randf_range(-BALL_RESET_Y_RANGE, BALL_RESET_Y_RANGE))

func _update_timer(delta: float) -> void:
	match_time -= delta
	if match_time <= 0:
		match_time = 0
		is_timer_finished = true
		_reset_ball()
	var minutes := int(match_time) / 60
	var seconds := int(match_time) % 60
	timer_value.text = "%d:%02d" % [minutes, seconds]

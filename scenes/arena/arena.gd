extends Node2D

# Court elements
@onready var court_border: Control = $Court/CourtBorder

@onready var hit_wall_sound: AudioStreamPlayer = $HitWall
@onready var hit_sound_paddle: AudioStreamPlayer = $HitPaddle
@onready var ball_destroyed_sound: AudioStreamPlayer = $BallDestroyed

# HUD
@onready var timer_value: Label = $HUDLayer/HUD/TopBar/TimerContainer/TimerValue

# Constants
const COURT_PADDING: float = 10.0
const GLOW_OFFSET: Vector2 = Vector2(8, 8)
const BALL_SPEED_MULTIPLIER: float = 1.1
const BALL_RESET_SPEED: float = 500.0
const BALL_RESET_Y_RANGE: float = 350.0
const STREAK_MULTIPLIER: int = 10

# Game state
var paddle_speed: float = 600.0
var match_time: float = 180.0
var is_timer_finished: bool = false

var p1: Player
var p2: Player
var ball: GameBall

func _ready() -> void:
	p1 = Player.new(
		$Court/LeftPaddle, $Court/LeftPaddleGlow,
		$HUDLayer/HUD/TopBar/P1ScoreBox/P1ScoreLabel,
		$HUDLayer/HUD/MarginContainer/P1HUD/P1OverdriveBar,
		"p1_up", "p1_down"
	)
	p2 = Player.new(
		$Court/RightPaddle, $Court/RightPaddleGlow,
		$HUDLayer/HUD/TopBar/P2ScoreBox/P2ScoreLabel,
		$HUDLayer/HUD/MarginContainer/P2HUD/P2OverdriveBar,
		"p2_up", "p2_down"
	)
	ball = GameBall.new($Court/Ball, BALL_RESET_SPEED, BALL_RESET_Y_RANGE, BALL_SPEED_MULTIPLIER)

	var tween := create_tween()
	tween.tween_property(MusicManager.bg_music, "volume_db", -20.0, 2.0)

func _process(delta: float) -> void:
	if !is_timer_finished:
		p1.move_paddle(delta, paddle_speed, court_border.size.y, COURT_PADDING, GLOW_OFFSET)
		p2.move_paddle(delta, paddle_speed, court_border.size.y, COURT_PADDING, GLOW_OFFSET)
		ball.move(delta, court_border.size.y, hit_wall_sound)
		ball.check_paddle_hit(p1, 1.0, hit_sound_paddle)
		ball.check_paddle_hit(p2, -1.0, hit_sound_paddle)
		ball.check_scoring(p1, p2, court_border.size, STREAK_MULTIPLIER, ball_destroyed_sound)
		_update_timer(delta)

func _update_timer(delta: float) -> void:
	match_time -= delta
	if match_time <= 0:
		match_time = 0
		is_timer_finished = true
		ball.reset(court_border.size)
	var minutes := int(match_time) / 60
	var seconds := int(match_time) % 60
	timer_value.text = "%d:%02d" % [minutes, seconds]

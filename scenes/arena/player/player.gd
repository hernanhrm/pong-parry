class_name Player
extends RefCounted

var paddle: ColorRect
var paddle_glow: ColorRect
var score_label: Label
var progress_bar: ProgressBar
var action_up: String
var action_down: String
var score: int = 0
var streak: int = 0

func _init(p_paddle: ColorRect, p_glow: ColorRect, p_label: Label, p_bar: ProgressBar, p_up: String, p_down: String) -> void:
	paddle = p_paddle
	paddle_glow = p_glow
	score_label = p_label
	progress_bar = p_bar
	action_up = p_up
	action_down = p_down

func move_paddle(delta: float, speed: float, court_height: float, padding: float, glow_offset: Vector2) -> void:
	if Input.is_action_pressed(action_up):
		paddle.position.y -= speed * delta
	if Input.is_action_pressed(action_down):
		paddle.position.y += speed * delta

	paddle.position.y = clamp(paddle.position.y, padding, court_height - padding - paddle.size.y)
	paddle_glow.position = paddle.position - glow_offset

func add_score(opponent: Player, streak_multiplier: int) -> void:
	score += 1
	score_label.text = "%02d" % score
	opponent.streak = 0
	streak += 1
	progress_bar.value += streak * streak_multiplier

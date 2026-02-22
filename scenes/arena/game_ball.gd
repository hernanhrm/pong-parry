class_name GameBall
extends RefCounted

var node: ColorRect
var velocity: Vector2
var reset_speed: float
var reset_y_range: float
var speed_multiplier: float

func _init(p_node: ColorRect, p_reset_speed: float, p_reset_y_range: float, p_speed_multiplier: float) -> void:
	node = p_node
	velocity = Vector2(p_reset_speed, p_reset_y_range)
	reset_speed = p_reset_speed
	reset_y_range = p_reset_y_range
	speed_multiplier = p_speed_multiplier

func move(delta: float, court_height: float, hit_wall_sound: AudioStreamPlayer) -> void:
	node.position += velocity * delta
	if node.position.y <= 0 or node.position.y + node.size.y >= court_height:
		hit_wall_sound.play()
		velocity.y = -velocity.y

func check_paddle_hit(player: Player, expected_dir: float, hit_sound: AudioStreamPlayer) -> void:
	var ball_rect := Rect2(node.position, node.size)
	if ball_rect.intersects(Rect2(player.paddle.position, player.paddle.size)) and velocity.x * expected_dir < 0:
		hit_sound.play()
		velocity.x = -velocity.x
		velocity *= speed_multiplier

func check_scoring(p1: Player, p2: Player, court_size: Vector2, streak_multiplier: int) -> void:
	if node.position.x + node.size.x < 0:
		p2.add_score(p1, streak_multiplier)
		reset(court_size)
	elif node.position.x > court_size.x:
		p1.add_score(p2, streak_multiplier)
		reset(court_size)

func reset(court_size: Vector2) -> void:
	node.position = court_size / 2.0 - node.size / 2.0
	var direction := -1.0 if velocity.x > 0 else 1.0
	velocity = Vector2(reset_speed * direction, randf_range(-reset_y_range, reset_y_range))

extends ColorRect

@onready var court: Control = $"../CourtBorder"

func _ready() -> void:
	color = Color.TRANSPARENT
	position.x = court.size.x / 2 - 10
	position.y = court.size.y / 2 - 10

func _draw() -> void:
	draw_circle(size / 2.0, size.x / 2.0, Color.WHITE)

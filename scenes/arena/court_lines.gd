extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var center := size / 2.0
	var line_color := Color("#1A222C")

	# Vertical center line
	draw_line(Vector2(center.x, 0), Vector2(center.x, size.y), line_color, 3.0)

	# Center circle
	var radius := 200.0
	draw_arc(center, radius, 0, TAU, 64, line_color, 3.0)

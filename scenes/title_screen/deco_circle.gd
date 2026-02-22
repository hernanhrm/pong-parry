extends Control

func _draw() -> void:
	# Large circle in bottom-left, mostly off-screen
	var center := Vector2(-80, size.y + 40)
	var radius := 300.0
	var color := Color("#1E2D3D")  # slightly lighter than background

	# Draw a thick ring (circle outline)
	draw_arc(center, radius, 0, TAU, 64, color, 8.0)
	draw_arc(center, radius - 40, 0, TAU, 64, color, 4.0)

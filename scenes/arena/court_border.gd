extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

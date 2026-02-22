extends CanvasLayer

@onready var cover:ColorRect = $Cover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cover.position.x = -get_viewport().get_visible_rect().size.x

func transition_to(screen_path: String):
	# Slide in (cover the screen)
	var tween_in = create_tween()
	tween_in.tween_property(cover, "position:x", 0.0, 0.4)
	await tween_in.finished

	# Change scene here...
	get_tree().change_scene_to_file(screen_path)

	# Slide out (reveal new scene)
	var tween_out = create_tween()
	tween_out.tween_property(cover, "position:x", -get_viewport().get_visible_rect().size.x, 0.4)
	await tween_out.finished

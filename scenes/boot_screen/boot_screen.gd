extends Control

@onready var logo = $Logo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_blink()
	await get_tree().create_timer(2.0).timeout
	Transition.transition_to("res://scenes/title_screen/title_screen.tscn")


func _start_blink() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(logo, "modulate:a", 0.4, 0.6)
	tween.tween_property(logo, "modulate:a", 1.0, 0.8)

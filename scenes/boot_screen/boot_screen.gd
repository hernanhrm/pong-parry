extends Control

@onready var logo = $Logo
@onready var boot_sound:AudioStreamPlayer = $BootSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boot_sound.volume_db = -30.0
	boot_sound.play()
	var vol_tween := create_tween()
	vol_tween.tween_property(boot_sound, "volume_db", 25.0, 1.5)
	
	_start_blink()
	await get_tree().create_timer(3.0).timeout
	Transition.transition_to("res://scenes/title_screen/title_screen.tscn")


func _start_blink() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(logo, "modulate:a", 0.4, 0.6)
	tween.tween_property(logo, "modulate:a", 1.0, 0.8)

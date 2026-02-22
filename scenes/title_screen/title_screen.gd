extends Control

@onready var start_button:Button = $StartButton
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	_start_blink()
	var vol_tween := create_tween()
	vol_tween.tween_property(music, "volume_db", 0.0, 4)

func _on_start_pressed() -> void:
	# TODO: Change to your game scene later
	print("Game starting!")
	# get_tree().change_scene_to_file("res://scenes/game.tscn")

func _start_blink() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(start_button, "modulate:a", 0.7, 0.9)
	tween.tween_property(start_button, "modulate:a", 1.0, 0.8)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_pressed():
			_on_start_pressed()

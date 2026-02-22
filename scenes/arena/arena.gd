extends Node2D

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(MusicManager.bg_music, "volume_db", -30.0, 1.0)

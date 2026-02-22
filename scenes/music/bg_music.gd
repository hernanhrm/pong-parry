extends Node

@onready var bg_music: AudioStreamPlayer = $BGMusic

func play_music() -> void:
	if not bg_music.playing:
		bg_music.stream.loop = true
		bg_music.volume_db = -50.0
		bg_music.play()
		var tween := create_tween()
		tween.tween_property(bg_music, "volume_db", 0.0, 2.5)

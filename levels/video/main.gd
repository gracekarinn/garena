extends Control

func _ready():
	await get_tree().create_timer(0.1).timeout 
	$VideoStreamPlayer.play()
	$VideoStreamPlayer.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file("res://levels/day-one/day_one.tscn")

func _on_button_pressed() -> void:
	$VideoStreamPlayer.stop()
	get_tree().change_scene_to_file("res://levels/day-one/day_one.tscn")

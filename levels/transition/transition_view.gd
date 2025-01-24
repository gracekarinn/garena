extends CanvasLayer

func change_scene(target_scene_path: String):
	var tween = create_tween()
	tween.tween_property($Black, "color", Color(0, 0, 0, 1), 1)
	tween.tween_callback(get_tree().change_scene_to_file.bind(target_scene_path))
	tween.tween_property($Black, "color", Color(0, 0, 0, 0), 1)

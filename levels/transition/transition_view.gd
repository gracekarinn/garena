extends CanvasLayer

func fade_out_in(callback: Callable):
	var tween = create_tween()
	tween.tween_property($Black, "color", Color(0,0,0,1), 0.1)

	tween.tween_callback(callback)

	tween.tween_property($Black, "color", Color(0,0,0,0), 0.1)

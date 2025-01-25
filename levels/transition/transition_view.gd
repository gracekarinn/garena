extends CanvasLayer

func fade_out_in(callback: Callable):
   var tween = create_tween()
   $Black.position = Vector2(0, get_viewport().size.y)
   tween.tween_property($Black, "position", Vector2.ZERO, 0.8).set_ease(Tween.EASE_OUT)
   tween.tween_callback(callback)
   tween.tween_property($Black, "position", Vector2(0, -get_viewport().size.y), 0.8).set_ease(Tween.EASE_IN)

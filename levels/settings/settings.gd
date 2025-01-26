extends Control

@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var music_bus_id = AudioServer.get_bus_index("music")

func _on_music_slider_value_changed(value: float) -> void:
	if music_bus_id >= 0:
		AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
		AudioServer.set_bus_mute(music_bus_id, value < 0.05)

func _on_sfx_slider_value_changed(value: float) -> void:
	if sfx_bus_id >= 0:
		AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
		AudioServer.set_bus_mute(sfx_bus_id, value < 0.05)

extends ReferenceRect

@onready var background = $Background
@onready var desk = $Meja
@onready var cv_overlay = $CVBackground
@onready var yes_button = $YesButton
@onready var no_button = $NoButton
@onready var candidate_photo = $Sprite
@onready var name_label = $CVBackground/VBoxContainer/NameLabel
@onready var experience_label = $CVBackground/VBoxContainer/ExperienceLabel
@onready var funfact_label = $CVBackground/VBoxContainer/FunfactLabel

var timer: Timer
var cv_parser: CVParser
var current_candidate_id: String = "C001"

func _ready():
	cv_parser = CVParser.new()
	add_child(cv_parser)
	
	background.visible = true
	desk.visible = true
	cv_overlay.visible = false
	yes_button.visible = false
	no_button.visible = false
	candidate_photo.visible = false
	
	candidate_photo.position = Vector2(342, -118)
	candidate_photo.modulate.a = 0
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	yes_button.pressed.connect(_on_yes_button_pressed)
	no_button.pressed.connect(_on_no_button_pressed)
	
	yes_button.z_index = 10
	no_button.z_index = 10

func _on_timer_timeout():
	var transitionview = get_node("/root/TransitionView")
	var display_cv_callable = Callable(self, "_fade_in_and_show_cv")
	transitionview.fade_out_in(display_cv_callable)

func _fade_in_and_show_cv():
	_fade_in_candidate_photo()
	await get_tree().create_timer(5.5).timeout  # 0.5 + 5.0 = 5.5 seconds
	_animate_cv_overlay()

func _fade_in_candidate_photo():
	candidate_photo.visible = true
	var photo_path = cv_parser.get_candidate_photo(current_candidate_id)
	candidate_photo.texture = load(photo_path)
	candidate_photo.modulate.a = 0
	
	var tween = create_tween()
	tween.tween_property(candidate_photo, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	# Optionally, add callbacks if needed after fade-in
	# tween.tween_callback(1.0, Callable(self, "_on_photo_fade_in_complete"))

func _animate_cv_overlay():
	display_cv(current_candidate_id)
	
	# Reset cv_overlay to initial state
	cv_overlay.position.y = get_viewport().size.y
	cv_overlay.rotation_degrees = -3
	cv_overlay.modulate.a = 0
	cv_overlay.scale = Vector2(0.9, 0.9)
	
	cv_overlay.visible = true
	yes_button.visible = true
	no_button.visible = true
	
	yes_button.scale = Vector2(0.8, 0.8)
	no_button.scale = Vector2(0.8, 0.8)
	yes_button.modulate.a = 0
	no_button.modulate.a = 0
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Animate cv_overlay with smoother transitions
	tween.tween_property(cv_overlay, "position:y", 0, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cv_overlay, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cv_overlay, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cv_overlay, "rotation_degrees", 0, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Animate yes_button
	tween.tween_property(yes_button, "scale", Vector2(1.2, 1.2), 0.2).set_delay(0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(yes_button, "scale", Vector2(1, 1), 0.1).set_delay(0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(yes_button, "modulate:a", 1, 0.3).set_delay(0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	# Animate no_button
	tween.tween_property(no_button, "scale", Vector2(1.2, 1.2), 0.2).set_delay(0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(no_button, "scale", Vector2(1, 1), 0.1).set_delay(0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(no_button, "modulate:a", 1, 0.3).set_delay(0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func advance_to_next_candidate():
	# Fade out cv_overlay and buttons before advancing
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Fade out cv_overlay
	tween.tween_property(cv_overlay, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	# Fade out buttons
	tween.tween_property(yes_button, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_button, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_callback(func(): _on_fade_out_complete())

func _on_fade_out_complete():
	# Reset cv_overlay properties for next candidate
	cv_overlay.visible = false
	cv_overlay.position.y = get_viewport().size.y
	cv_overlay.rotation_degrees = -5
	cv_overlay.modulate.a = 0
	cv_overlay.scale = Vector2(0.7, 0.7)
	
	yes_button.visible = false
	no_button.visible = false
	yes_button.scale = Vector2(0.8, 0.8)
	no_button.scale = Vector2(0.8, 0.8)
	yes_button.modulate.a = 0
	no_button.modulate.a = 0
	
	# Check if last candidate
	if current_candidate_id == cv_parser.get_all_cvs().back().id:
		get_tree().change_scene_to_file("res://levels/day-one/youtube_view.tscn")
	else:
		current_candidate_id = "C00" + str(int(current_candidate_id.substr(3)) + 1)
		_on_timer_timeout()

func display_cv(id: String):
	name_label.text = "Name: " + cv_parser.get_candidate_name(id)
	
	var experiences = cv_parser.get_experience(id)
	var exp_text = "Experience:\n"

	for i in range(len(experiences)):
		var e = experiences[i]
		exp_text += "%s\nRole: %s\nGenre: %s\nDescription: " % [e.years, e.role, e.genre]
		
		var words = e.description.split(" ")
		for w_index in range(len(words)):
			if w_index > 0 and w_index % 5 == 0:
				exp_text += "\n"
			exp_text += words[w_index] + " "
		
		exp_text = exp_text.rstrip(" \t\r\n")
		if i < len(experiences) - 1:
			exp_text += "\n\n"
	
	experience_label.text = exp_text

	var funfacts = cv_parser.get_funfact(id)
	var funfacts_text = "Fun Facts:\n"
	for fact in funfacts:
		funfacts_text += "• %s\n" % fact

	funfact_label.text = funfacts_text

func _on_yes_button_pressed():
	var tween = create_tween()
	tween.set_parallel(true)

	# Fade out buttons with smooth easing
	tween.tween_property(yes_button, "modulate:a", 0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_button, "modulate:a", 0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(yes_button, "scale", Vector2(0.9, 0.9), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_button, "scale", Vector2(0.9, 0.9), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Smooth upward CV animation
	tween.tween_property(cv_overlay, "position:y", -get_viewport().size.y * 1.2, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cv_overlay, "rotation_degrees", 2, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cv_overlay, "modulate:a", 0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	GameState.record_choice(current_candidate_id, true)
	
	await get_tree().create_timer(0.9).timeout
	advance_to_next_candidate()

func _on_no_button_pressed():
	var tween = create_tween()
	tween.set_parallel(true)

	# Fade out buttons with smooth easing
	tween.tween_property(yes_button, "modulate:a", 0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_button, "modulate:a", 0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(yes_button, "scale", Vector2(0.9, 0.9), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_button, "scale", Vector2(0.9, 0.9), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Smooth upward CV animation
	tween.tween_property(cv_overlay, "position:y", -get_viewport().size.y * 1.2, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)  
	tween.tween_property(cv_overlay, "rotation_degrees", -2, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cv_overlay, "modulate:a", 0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	GameState.record_choice(current_candidate_id, false)
	
	await get_tree().create_timer(0.9).timeout
	advance_to_next_candidate()

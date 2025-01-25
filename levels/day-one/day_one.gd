extends ReferenceRect

@onready var background = $Background
@onready var desk = $Meja
@onready var cv_overlay = $CVBackground
@onready var yes_button = $YesButton
@onready var no_button = $NoButton

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

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	print("Signals connected:", yes_button.get_signal_connection_list("pressed"))
	print("Node name:", name)

func _on_timer_timeout():
	var transitionview = get_node("/root/TransitionView")
	var display_cv_callable = func():
		display_cv(current_candidate_id)
		cv_overlay.visible = true
		yes_button.visible = true
		no_button.visible = true
	transitionview.fade_out_in(display_cv_callable)


func display_cv(id: String):
	name_label.text = "Name: " + cv_parser.get_candidate_name(id)

	var experiences = cv_parser.get_experience(id)
	var exp_text = "Experience:\n"

	for i in range(len(experiences)):
		var e = experiences[i]

		exp_text += "%s\nRole: %s\nGenre: %s\nDescription: " % [
			e.years,
			e.role,
			e.genre
		]

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
	print("YES pressed!")
	GameState.record_choice(current_candidate_id, true)
	advance_to_next_candidate()

func _on_no_button_pressed():
	print("NO pressed!")
	GameState.record_choice(current_candidate_id, false)
	advance_to_next_candidate()

func advance_to_next_candidate():
	if current_candidate_id == cv_parser.get_all_cvs().back().id:
		get_tree().change_scene_to_file("res://levels/day-one/youtube_view.tscn")
	else:
		current_candidate_id = "C00" + str(int(current_candidate_id.substr(3)) + 1)
		display_cv(current_candidate_id)

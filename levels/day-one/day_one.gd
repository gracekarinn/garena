extends ReferenceRect

@onready var background = $Background
@onready var desk = $Meja
@onready var cv_overlay = $CVBackground
@onready var yes_button = $YesButton
@onready var no_button = $NoButton

# If you have them inside a VBoxContainer:
@onready var name_label = $CVBackground/VBoxContainer/NameLabel
@onready var experience_label = $CVBackground/VBoxContainer/ExperienceLabel
@onready var funfact_label = $CVBackground/VBoxContainer/FunfactLabel

var timer: Timer
var cv_parser: CVParser
var current_candidate_id: String = "C001"

func _ready():
	# Initialize your parser
	cv_parser = CVParser.new()
	add_child(cv_parser)

	# Initial visibility states
	background.visible = true
	desk.visible = true
	cv_overlay.visible = false
	yes_button.visible = false
	no_button.visible = false

	# Start a timer to show the CV after 2 seconds
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	display_cv(current_candidate_id)
	cv_overlay.visible = true
	yes_button.visible = true
	no_button.visible = true

func display_cv(id: String):
	# 1) Display the Candidate's Name
	name_label.text = "Name: " + cv_parser.get_candidate_name(id)

	# 2) Build the Experience text
	var experiences = cv_parser.get_experience(id)
	var exp_text = "Experience:\n"

	# We iterate using an index to know when we're at the last entry
	for i in range(len(experiences)):
		var e = experiences[i]

		exp_text += "%s\nRole: %s\nGenre: %s\nDescription: " % [
			e.years,
			e.role,
			e.genre
		]

		# Insert a newline every 5 words in the description
		var words = e.description.split(" ")
		for w_index in range(len(words)):
			if w_index > 0 and w_index % 5 == 0:
				exp_text += "\n"
			exp_text += words[w_index] + " "

		# Strip any trailing spaces/newlines on this block
		exp_text = exp_text.rstrip(" \t\r\n")


		# Only add a blank line if it's not the last experience
		if i < len(experiences) - 1:
			exp_text += "\n\n"

	# Now assign the finished text to the label
	experience_label.text = exp_text

	# 3) Build the Fun Facts text
	var funfacts = cv_parser.get_funfact(id)
	var funfacts_text = "Fun Facts:\n"
	for fact in funfacts:
		funfacts_text += "• %s\n" % fact

	# Assign the finished text to the funfact label
	funfact_label.text = funfacts_text

func _on_yes_button_pressed():
	if current_candidate_id == "C005":
		current_candidate_id = "C001"
	else:
		# Increment the number part: "C00X" -> "C00(X+1)"
		current_candidate_id = "C00" + str(int(current_candidate_id.substr(3)) + 1)
	display_cv(current_candidate_id)

func _on_no_button_pressed():
	if current_candidate_id == "C005":
		current_candidate_id = "C001"
	else:
		current_candidate_id = "C00" + str(int(current_candidate_id.substr(3)) + 1)
	display_cv(current_candidate_id)

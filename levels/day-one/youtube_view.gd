extends Panel

@onready var label = $Textbox/MarginContainer/MarginContainer/Label
var displayed_text = ""
var target_text = ""
var typing_speed = 0.05
var typing_timer = 0.0
var current_char = 0

func _ready():
	GameState.connect("day_complete", Callable(self, "_on_day_complete"))
	set_text("The total views for today is 0")

func _process(delta):
	if current_char < target_text.length():
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0.0
			current_char += 1
			displayed_text = target_text.substr(0, current_char)
			label.text = displayed_text

func set_text(new_text: String):
	target_text = new_text
	current_char = 0
	typing_timer = 0.0
	displayed_text = ""

func _on_day_complete(avg_score, views):
	set_text("Average: " + str(avg_score) + "%\nTotal Views: " + str(views))

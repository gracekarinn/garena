extends Panel

@onready var label = $Textbox/MarginContainer/MarginContainer/Label

var displayed_text = ""
var target_text = ""
var typing_speed = 0.05
var typing_timer = 0.0
var current_char = 0


func _ready():
	await get_tree().create_timer(0.1).timeout
	set_text("The total views for today is 750000")
	await get_tree().create_timer(5.0).timeout  
	get_tree().change_scene_to_file("res://levels/day-two/day-two.tscn")
	
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
	print("PANEL: Received signal with score:", avg_score, " views:", views)
	if views > 0:
		var display_text = "The total views for today is " + str(views) + "\nAverage score: " + String("%.2f" % avg_score)
		print("PANEL: Setting text to:", display_text)
		set_text(display_text)
		await get_tree().create_timer(2.0).timeout  
		get_tree().change_scene_to_file("res://levels/day-two/day-two.tscn")

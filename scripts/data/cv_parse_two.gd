extends Node
class_name CVParserTwo

const CV_PATH = "res://assets/data/candidates/cv_data_2.json"
var cv_data: Dictionary = {}

func _ready():
	load_cv_data()

func load_cv_data() -> void:
	if FileAccess.file_exists(CV_PATH):
		var file = FileAccess.open(CV_PATH, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		if json and json.has("candidates"):
			for cv in json.candidates:
				cv_data[cv.id] = cv
				
				# Ensure avatar texture exists
				if cv.has("photo") and !ResourceLoader.exists(cv.photo):
					print("Warning: Avatar texture not found for candidate ", cv.id)
	else:
		print("CV data file not found!")

func get_cv(id: String) -> Dictionary:
	return cv_data.get(id, {})

func get_all_cvs() -> Array:
	return cv_data.values()

func get_candidate_name(id: String) -> String:
	var cv = get_cv(id)
	return cv.get("name", "")

func get_experience(id: String) -> Array:
	var cv = get_cv(id)
	return cv.get("experience", [])

func get_funfact(id: String) -> Array:
	var cv = get_cv(id)
	return cv.get("funfact", [])

func get_candidate_photo(id: String) -> String:
	var cv = get_cv(id)
	return cv.get("photo", "")

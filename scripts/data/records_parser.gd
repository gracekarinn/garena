extends Node

class_name RecordsParser

const RECORDS_PATH = "res://assets/data/candidates/records.json"

var records_data: Dictionary = {}

func _ready():
	load_records_data()

func load_records_data() -> void:
	if FileAccess.file_exists(RECORDS_PATH):
		var file = FileAccess.open(RECORDS_PATH, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		if json and json.has("records"):
			for record in json.records:
				records_data[record.id] = record

func get_record(id: String) -> Dictionary:
	return records_data.get(id, {})

func get_all_records() -> Array:
	return records_data.values()

func get_medical_record(id: String) -> String:
	var record = get_record(id)
	return record.get("medical_record", "")

func get_scandal(id: String) -> String:
	var record = get_record(id)
	return record.get("scandal", "")

func get_crime(id: String) -> String:
	var record = get_record(id)
	return record.get("crime", "")

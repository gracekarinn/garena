extends Node

var candidate_scores = {
	"candidate_1": 70,
	"candidate_2": 95,
	"candidate_3": 65,
	"candidate_4": 30,
	"candidate_5": 80,
	# TODO
}

var daily_averages: Array = []

func _ready():
	# Example TODO
	var chosen_candidates = ["candidate_1", "candidate_3", "candidate_5"]
	var day_average = calculate_day_average(chosen_candidates)

	print("Day 1 average:", day_average)

	bubub(day_average)



func calculate_day_average(chosen_candidates: Array) -> float:
	var final_scores = []
	for candidate_id in chosen_candidates:
		if candidate_scores.has(candidate_id):
			final_scores.append(candidate_scores[candidate_id])

	var avg_score = get_average(final_scores)
	return avg_score

func get_average(scores: Array) -> float:
	if scores.size() == 0:
		return 0.0
	var total = 0
	for score in scores:
		total += score
	return float(total) / scores.size()

func change_to_views(average: float) -> float:
	return average * 1000000


func bubub(day_average: float) -> void:
	daily_averages.append(day_average)

	if daily_averages.size() == 5:
		var fifteen_day_avg = get_average(daily_averages)
		print("15-day average:", fifteen_day_avg)

		if fifteen_day_avg > 50:
			print("SUCCESS! Average > 50% — Pacil is victorious!")
		else:
			print("FAILED. 5-day average <= 50%.")
		

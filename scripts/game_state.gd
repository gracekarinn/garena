extends Node


signal day_complete(avg_score, views)

var candidate_scores = {}
var chosen_candidates = []
var daily_averages = []
var total_candidates = 0

func _ready():
	var cv_parser = CVParser.new()
	cv_parser._ready() 
	var candidates = cv_parser.get_all_cvs()
	total_candidates = candidates.size()
	for candidate in candidates:
		candidate_scores[candidate.id] = candidate.score
	print("Total candidates loaded: ", total_candidates)
	print("Scores loaded: ", candidate_scores)

func record_choice(candidate_id: String, choice: bool):
	if choice:
		chosen_candidates.append(candidate_id)
		print("Chosen: ", candidate_id, " Score: ", candidate_scores[candidate_id])
		print("Current chosen: ", chosen_candidates)
	
	if len(chosen_candidates) > 0 && chosen_candidates.size() % total_candidates == 0:
		print("\nDay complete!")
		calculate_and_store_daily_average()
		chosen_candidates.clear()
		
func calculate_views(scores: Array) -> int:
	var avg = get_average(scores)
	return int(avg * 1000000)

func calculate_and_store_daily_average():
	var final_scores = []
	for candidate_id in chosen_candidates:
		if candidate_scores.has(candidate_id):
			final_scores.append(candidate_scores[candidate_id])
	
	var avg_score = get_average(final_scores)
	var views = calculate_views(final_scores)  # Add this
	emit_signal("day_complete", avg_score, views) 
	daily_averages.append(avg_score)
	print("Daily average: ", avg_score)
	print("All daily averages: ", daily_averages)
	
	if daily_averages.size() == 5:
		check_game_outcome()

func get_average(scores: Array) -> float:
	if scores.size() == 0:
		return 0.0
	var total = 0
	for score in scores:
		total += score
	return float(total) / scores.size()

func check_game_outcome():
	var five_day_avg = get_average(daily_averages)
	print("5-day average:", five_day_avg)
	if five_day_avg > 50:
		print("SUCCESS! Average > 50% — Game won!")
	else:
		print("FAILED. 5-day average <= 50%.")

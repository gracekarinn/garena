extends Node



var cv_parser: CVParser 
var candidate_scores = {}
var chosen_candidates = []
var daily_averages = []
var total_candidates = 0

func _ready():
	cv_parser = CVParser.new()  # Store the reference
	add_child(cv_parser) 
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
	# Calculate average after every choice
	calculate_and_store_daily_average()
	# Clear chosen candidates only after a full day
	if chosen_candidates.size() % total_candidates == 0:
		chosen_candidates.clear()
func calculate_and_store_daily_average():
	var final_scores = []
	print("Calculating average for candidates: ", chosen_candidates)
	print("Available scores: ", candidate_scores)
	for candidate_id in chosen_candidates:
		if candidate_scores.has(candidate_id):
			final_scores.append(candidate_scores[candidate_id])
			print("Added score for ", candidate_id, ": ", candidate_scores[candidate_id])
	print("Final scores to average: ", final_scores)
	var avg_score = get_average(final_scores)
	print("Calculated average: ", avg_score)
	daily_averages.append(avg_score)
	var views = calculate_views(final_scores)
func calculate_views(scores: Array) -> int:
	var avg = get_average(scores)
	return int(avg * 1000000)
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

extends CanvasLayer

@onready var score = $Score

func show_best_score():
	if MetaScore.save_data.is_empty():
		return
	var new = 0
	var old = 0
	for game in MetaScore.save_data["games"]:
		new = game["score"]
		if new > old:
			old = new
	score.text = "BEST SCORE: " + str(old)

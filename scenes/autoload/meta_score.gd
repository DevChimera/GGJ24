extends Node

const SAVE_FILE_PATH = "user://game.save"

var game = {"number" : 1, "score": 0}
var save_data : Dictionary = {"games" : []}

func _ready():
	GameEvents.ScoreAdded.connect(on_add_score)
	GameEvents.GameOver.connect(on_game_over)
	load_save_file()
	print(save_data)
	
func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	
func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func on_add_score():
	game["score"] += 1
	print(game["score"])
	save()
	
func on_game_over():
	if save_data.is_empty():
		game["number"] = 1
	else:
		game["number"] = save_data["games"].size() + 1
	save_data["games"].append(game)
	save()

extends Node

@export var total_minigames = 2

var minigames = [preload("res://scenes/minigames/lanza_tomates.tscn"), \
				preload("res://scenes/minigames/fishing.tscn")]

var current_minigames = []
var min_id = 0
var current_min : Node
var current_min_comp : MiniGameComponent

func _ready():
	select_minigames()

func select_minigames():
	for i in total_minigames:
		current_minigames.append(minigames[i])
	next_minigame()
	
func next_minigame():
	if min_id < total_minigames:
		current_min = current_minigames[min_id].instantiate()
		add_child(current_min)
		current_min_comp = current_min.find_child("MiniGameComponent")
		current_min_comp.GameFinished.connect(player_has_won)
		min_id += 1
	else:
		pass
	
func player_has_won(win : bool): #Just for test
	print(current_min_comp.key)
	current_min.queue_free()
	next_minigame()
	

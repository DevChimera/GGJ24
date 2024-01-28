extends Node


@onready var banners = $Banners
@onready var king = $Kingbackground/King
@onready var next_game_timer = $NextGameTimer

@export var total_minigames = 5

var minigames : Array = [preload("res://scenes/minigames/lanza_tomates.tscn"), \
				preload("res://scenes/minigames/fishing.tscn"), \
				preload("res://scenes/minigames/expand.tscn")]

var current_minigames = []
var min_id = 0
var current_min : Node
var current_min_comp : MiniGameComponent
var current_lifes = 4
var rng = RandomNumberGenerator.new()
var difficulty = 1


func select_minigames():
	for i in minigames.size():
		current_minigames.append(minigames[i])
	var rest_minigames = total_minigames - minigames.size()
	for i in rest_minigames:
		current_minigames.append(minigames.pick_random())
	next_minigame()
	
func next_minigame():
	if min_id >= total_minigames / 2:
		difficulty = 2
	elif min_id == total_minigames - 1:
		difficulty = 3
		
		
	if min_id >= current_minigames.size():
		return #finish game
	
	print("DIFICULTAD: ")
	print(difficulty)
	current_min = current_minigames[min_id].instantiate()
	min_id += 1
	
	current_min_comp = current_min.find_child("MiniGameComponent")
	current_min_comp.GameFinished.connect(on_game_finished)
	if difficulty == 1:
		if current_min.is_in_group("fishing"):
			current_min.find_child("FishingRod").click_time = 1.0 #tiempo pa pulsar
		elif current_min.is_in_group("expand"):
			current_min.times_next_frame = 5 #veces pa pulsar
		elif current_min.is_in_group("tomato"):
			current_min.find_child("TomatoTable").points = 2 #los que quito (hay 4)
			current_min_comp.win_score = 2 #cuantos necesito
	elif difficulty == 2:
		if current_min.is_in_group("fishing"):
			current_min.find_child("FishingRod").click_time = 0.8 #tiempo pa pulsar
		elif current_min.is_in_group("expand"):
			current_min.times_next_frame = 7 #veces pa pulsar
		elif current_min.is_in_group("tomato"):
			current_min.find_child("TomatoTable").points = 1 #los que quito (hay 4)
			current_min_comp.win_score = 3 #cuantos necesito
	elif difficulty == 3:
		if current_min.is_in_group("fishing"):
			current_min.find_child("FishingRod").click_time = 0.6 #tiempo pa pulsar
		elif current_min.is_in_group("expand"):
			current_min.times_next_frame = 9 #veces pa pulsar
		elif current_min.is_in_group("tomato"):
			current_min.find_child("TomatoTable").points = 0 #los que quito (hay 4)
			current_min_comp.win_score = 4 #cuantos necesito
	add_child(current_min)
func remove_banner():
	var banner : AnimatedSprite2D = banners.get_child(current_lifes - 1)
	banner.play("default")
	current_lifes -= 1
	
func on_game_finished(win : bool):
	if current_lifes == 0:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	if !win:
		remove_banner()
		king.play("angry")
	else:
		king.play("laugh")
	current_min.queue_free()
	next_game_timer.start()
	next_game_timer.timeout.connect(on_next_game_timer_timeout)

func on_next_game_timer_timeout():
	next_minigame()
	king.play("idle")
	next_game_timer.timeout.disconnect(on_next_game_timer_timeout)




	

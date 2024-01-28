extends Node


@onready var banners = $Banners
@onready var king = $Kingbackground/King
@onready var next_game_timer = $NextGameTimer
@onready var game_over = $GameOver/AnimationPlayer
@onready var theme = $Theme
@onready var menu = $Menu

#SFX
@onready var angry_fist = $Kingbackground/AngryFist
@onready var angry_voice = $Kingbackground/AngryVoice
@onready var laugh_fist = $Kingbackground/LaughFist
@onready var laugh_voice = $Kingbackground/LaughVoice


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
var intro = false


func _ready():
	GameEvents.GameBegin.connect(select_minigames)

func select_minigames():
	if intro:
		self.find_child("StartButton").queue_free()
		intro = false
		menu.stop()
		theme.play()
		for i in minigames.size():
			current_minigames.append(minigames[i])
		next_minigame()
	
func next_minigame():	
	if min_id >= current_minigames.size():
		current_minigames.append(minigames.pick_random())
	
	
	current_min = current_minigames[min_id].instantiate()
	min_id += 1
	
	current_min_comp = current_min.find_child("MiniGameComponent")
	current_min_comp.GameFinished.connect(on_game_finished)
	
	print("DIFICULTAD: ")
	print(difficulty)
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
	elif difficulty > 3:
		if current_min.is_in_group("fishing"):
			current_min.find_child("FishingRod").click_time = current_min.find_child("FishingRod").click_time - (difficulty * 0.05) #tiempo pa pulsar
		elif current_min.is_in_group("expand"):
			current_min_comp.time = current_min_comp.time - (difficulty/3)
		elif current_min.is_in_group("tomato"):
			current_min_comp.time = current_min_comp.time - difficulty
	
	difficulty += 1
	add_child(current_min)
	
func remove_banner():
	var banner : AnimatedSprite2D = banners.get_child(current_lifes - 1)
	banner.play("default")
	current_lifes -= 1
	
func on_game_finished(win : bool):
	current_min.queue_free()
	if !win:
		remove_banner()
		angry_fist.play()
		angry_voice.play()
		king.play("angry")
	else:
		GameEvents.ScoreAdded.emit()
		laugh_fist.play()
		laugh_voice.play()
		king.play("laugh")
		
	if current_lifes <= 0:
		theme.stop()
		game_over.play("game_over")
		GameEvents.GameOver.emit()
		return
	next_game_timer.start()
	next_game_timer.timeout.connect(on_next_game_timer_timeout)

func on_next_game_timer_timeout():
	next_minigame()
	king.play("idle")
	next_game_timer.timeout.disconnect(on_next_game_timer_timeout)

func on_game_over_finished():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func on_game_intro_finished():
	intro = true




	

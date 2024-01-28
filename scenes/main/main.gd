extends Node


@onready var banners = $Banners
@onready var king = $Kingbackground/King
@onready var next_game_timer = $NextGameTimer

@export var total_minigames = 2

var minigames = [preload("res://scenes/minigames/lanza_tomates.tscn"), \
				preload("res://scenes/minigames/fishing.tscn")]

var current_minigames = []
var min_id = 0
var current_min : Node
var current_min_comp : MiniGameComponent
var current_lifes = 4

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
		current_min_comp.GameFinished.connect(on_game_finished)
		min_id += 1
	else:
		pass
func remove_banner():
	var banner : AnimatedSprite2D = banners.get_child(current_lifes - 1)
	banner.play("default")
	current_lifes -= 1
	
func on_game_finished(win : bool):
	if current_lifes == 0:
		return
	if !win:
		remove_banner()
		king.play("angry")
	else:
		king.play("laugh")
	next_game_timer.start()
	next_game_timer.timeout.connect(on_next_game_timer_timeout)

func on_next_game_timer_timeout():
	current_min.queue_free()
	next_minigame()
	next_game_timer.timeout.disconnect(on_next_game_timer_timeout)




	

extends Node

class_name MiniGameComponent

signal GameFinished (win : bool)

@onready var timer = $Timer

@export var id : String
@export var key : String
@export var time : float = 60
@export var win_score : int = 5
@export var fails_score : int = 3
@export var animation : AnimationPlayer

var current_score = 0
var current_fails = 0
var victory

func _ready():
	timer.wait_time = time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ScoreWin.connect(on_score_win)
	GameEvents.ScoreFail.connect(on_score_fail)

func on_score_win():
	print(current_score)
	current_score += 1
	if current_score >= win_score:
		on_game_finished(true)
	
func on_score_fail():
	current_fails += 1
	if current_fails >= fails_score:
		on_game_finished(false)

func on_timer_timeout():
	on_game_finished(false)

func on_game_finished(_victory: bool):
	victory = _victory
	animation.play("fade_out")
	
func on_fade_out_finished():
	GameFinished.emit(victory)

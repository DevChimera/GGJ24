extends Node2D

@onready var road = $Road
@onready var exclamation = $Exclamation
@onready var exclamation_timer = $ExclamationTimer
@onready var wait_timer = $WaitTimer

@export var click_time = 1

var finished = true
var rng = RandomNumberGenerator.new()

func _ready():
	exclamation_timer.wait_time = rng.randf_range(5.0, 10.0)
	exclamation_timer.start()
	exclamation_timer.timeout.connect(on_timer_exclamation_timeout)
	GameEvents.GameStart.connect(on_game_start)

func _input(event):
	if event.is_action("shoot") && !finished:
		finished = true
		if exclamation.visible:
			play_win_anim()
		else:
			play_fail_anim()

func play_win_anim():
	var anim = rng.randi_range(1, 3)
	print(anim)
	if anim == 1:
		road.play("win_a")
	elif anim == 2:
		road.play("win_b")
	elif anim == 3:
		road.play("win_c")
	wait_timer.start()
	wait_timer.timeout.connect(on_wait_timer_finished_win)

func play_fail_anim():
	road.play("fail")
	wait_timer.start()
	wait_timer.timeout.connect(on_wait_timer_finished_fail)

func on_wait_timer_finished_win():
	GameEvents.ScoreWin.emit()
	
func on_wait_timer_finished_fail():
	GameEvents.ScoreFail.emit()
	
func on_timer_exclamation_timeout():
	if exclamation.visible:
		play_fail_anim()
	else:
		exclamation.visible = true
		exclamation.play("default")
		exclamation_timer.wait_time = click_time
		exclamation_timer.start()
		exclamation_timer.timeout.disconnect(on_timer_exclamation_timeout)
		exclamation_timer.timeout.connect(on_exclamation_timer_finished)
		
func on_exclamation_timer_finished():
	play_fail_anim()
	exclamation_timer.timeout.disconnect(on_exclamation_timer_finished)
	
func on_game_start():
	finished = false


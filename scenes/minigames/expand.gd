extends Node2D

@onready var palanca = $Visuals/Palanca
@onready var bolardo = $Visuals/Bolardo
@onready var sounds = $Sounds
@export var times_next_frame = 5


var finished = false

func _input(event):
	if event.is_action("shoot") && !finished:
		on_input_performed()

func on_input_performed():
	var sound : AudioStreamPlayer = sounds.get_child(bolardo.frame)
	sound.play()
	palanca.play("default")
	times_next_frame -= 1
	if times_next_frame == 0:
		bolardo.frame += 1
		times_next_frame = 5
		if bolardo.frame == 6:
			GameEvents.ScoreWin.emit()
			finished = true

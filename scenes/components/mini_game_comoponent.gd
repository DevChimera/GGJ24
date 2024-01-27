extends Node

class_name MiniGameComponent

signal GameFinished (win : bool)

@onready var timer = $Timer

@export var id : String
@export var key : String
@export var time : float = 60
@export var button : Button

func _ready():
	#button.pressed.connect(on_button_pressed)
	timer.wait_time = time
	timer.timeout.connect(on_timer_timeout)

func on_button_pressed():
	GameFinished.emit(true)
	
func on_timer_timeout():
	GameFinished.emit(false)

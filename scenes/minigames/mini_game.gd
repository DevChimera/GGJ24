extends Node

class_name MiniGameComponent

signal GameFinished (win : bool)

@export var id : String
@export var key : String
@export var button : Button

func _ready():
	button.pressed.connect(on_button_pressed)


func on_button_pressed():
	GameFinished.emit(true)

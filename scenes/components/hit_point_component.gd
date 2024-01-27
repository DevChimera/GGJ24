extends Node2D


@onready var area_2d = $Area2D


func _ready():
	area_2d.body_entered.connect(on_area_2d_entered)
	
func on_area_2d_entered(body : Node2D):
	GameEvents.ScoreWin.emit()

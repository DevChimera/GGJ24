extends Node2D

func _input(event):
	if event.is_action("shoot"):
		GameEvents.GameBegin.emit()

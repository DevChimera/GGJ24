extends Node2D

func _on_area_2d_area_entered(area):
	GameEvents.ScoreWin.emit()

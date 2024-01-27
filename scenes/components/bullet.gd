extends Path2D


@onready var animation_player = $AnimationPlayer
@onready var area_2d = $PathFollow2D/Area2D


var splashed = false
func _on_area_2d_area_entered(area):
	if splashed:
		return
	animation_player.play("splash")
	splashed = true

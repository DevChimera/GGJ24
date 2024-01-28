extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@export var new_texture : Texture2D

func _on_area_2d_area_entered(area):
	GameEvents.ScoreWin.emit()
	collision_shape_2d.call_deferred("set_disabled", true)
	change_texture()
	
func change_texture():
	sprite_2d.texture = new_texture

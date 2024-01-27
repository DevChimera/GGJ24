extends Node2D

@onready var animation_player = $AnimationPlayer
@export var velocity : float = 1


func _ready():
	animation_player.speed_scale = velocity

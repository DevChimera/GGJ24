extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@export var velocity : float = 1
@onready var shoot_delay = $ShootDelay

var bullet = preload("res://scenes/components/bullet.tscn")

func _ready():
	animation_player.speed_scale = velocity
	shoot_delay.timeout.connect(on_shoot_delay_timeout)
	
func _input(event):
	if event.is_action("shoot") && event.is_pressed():
		shoot()

func shoot():
	animation_player.pause()
	shoot_delay.start()
	var new = bullet.instantiate()
	new.global_position = sprite_2d.global_position
	new.global_rotation = sprite_2d.global_rotation
	add_child(new)

func on_shoot_delay_timeout():
	animation_player.play("angle")
	

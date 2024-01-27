extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@export var velocity : float = 1
@onready var shoot_delay = $ShootDelay

var bullet = preload("res://scenes/components/bullet.tscn")
var canShoot : bool = true
var rotation_state

func _ready():
	animation_player.speed_scale = velocity
	shoot_delay.timeout.connect(on_shoot_delay_timeout)
	
func _input(event):
	if event.is_action("shoot") && event.is_pressed():
		shoot()

func shoot():
	if canShoot:
		animation_player.pause()
		rotation_state = animation_player.current_animation_position
		canShoot = false
		
		var new = bullet.instantiate()
		new.global_rotation = sprite_2d.global_rotation
		add_child(new)
		animation_player.play("shoot")
		shoot_delay.start()
		
		

func on_shoot_delay_timeout():
	animation_player.play("angle")
	canShoot = true
	

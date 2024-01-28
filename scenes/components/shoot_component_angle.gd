extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@export var velocity : float = 1
@onready var shoot_delay = $ShootDelay

@onready var launch = $Launch

var bullet = preload("res://scenes/components/bullet.tscn")
var can_shoot : bool = false
var game_finished : bool = false
var rotation_state

func _ready():
	animation_player.speed_scale = velocity
	shoot_delay.timeout.connect(on_shoot_delay_timeout)
	GameEvents.GameStart.connect(on_game_start)
	GameEvents.GameFinished.connect(on_game_finished)
	
func _input(event):
	if event.is_action("shoot") && event.is_pressed() && !game_finished:
		shoot()

func shoot():
	if !can_shoot:
		return
	launch.play()
	animation_player.pause()
	rotation_state = animation_player.current_animation_position
	can_shoot = false
	
	var new = bullet.instantiate()
	new.global_rotation = sprite_2d.global_rotation
	add_child(new)
	animation_player.play("shoot")
	shoot_delay.start()

func on_game_start():
	can_shoot = true

func on_game_finished():
	game_finished = true

func on_shoot_delay_timeout():
	animation_player.play("angle")
	can_shoot = true
	


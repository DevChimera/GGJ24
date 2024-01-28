extends Node2D


@onready var hit_points = $HitPoints
@export var points = 0


func _ready():
	for point in hit_points.get_children():
		if points == 0:
			break
		else:
			points -= 1
			point.queue_free()

extends Node2D


@onready var road = $Road
@onready var exclamation = $Exclamation
@onready var exclamation_timer = $ExclamationTimer


var rng = RandomNumberGenerator.new()

func _ready():
	exclamation_timer.wait_time = rng.randf_range(5.0, 10.0)
	exclamation_timer.start()
	exclamation_timer.timeout.connect(on_timer_exclamation_timeout)

func _input(event):
	if event.is_action("shoot"):
		if exclamation.visible:
			GameEvents.ScoreWin.emit()
		else:
			GameEvents.ScoreFail.emit()

func on_timer_exclamation_timeout():
	exclamation.visible = true
	exclamation.play("default")

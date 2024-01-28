extends CanvasLayer

@onready var score = $Score

func _ready():
	GameEvents.ScoreAdded.connect(on_score_added)

func on_score_added():
	score.text = "SCORE: " + str(MetaScore.game["score"])

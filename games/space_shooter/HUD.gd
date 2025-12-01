extends CanvasLayer

func _ready():
    update_score()

func update_score():
    $ScoreLabel.text = "Score: " + str(GlobalState.score)

extends CanvasLayer

func update_score():
	$ScoreLabel.text = "Score: %s" % GlobalState.score

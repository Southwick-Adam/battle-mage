extends Node

var played = false
var hi_score = 0

func _played():
	played = true

func _game_over(score):
	if score > hi_score:
		hi_score = score
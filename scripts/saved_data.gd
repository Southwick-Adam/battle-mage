extends Node2D

var hiscore = 0
var max_kills = 0
var max_time = 0
var max_min = 0

signal stat

func _update(score, kills, minutes, time):
	if score > hiscore:
		hiscore = score
	if kills > max_kills:
		max_kills = kills
	if minutes > max_min:
		max_min = minutes
	if time > max_time:
		max_time = time

func _send():
	get_node("../HUD/trophy_screen")._update(hiscore, max_kills, max_min, max_time)

func _ready():
	pass

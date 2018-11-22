extends Control

onready var saved_data = get_node("../../saved_data")
var max_kills = 0
var hiscore = 0
var max_time = 0
var max_min = 0

func _update(score, kills, minute, time):
	var kills_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/kills/best/Label")
	var score_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/score/best/Label")
	var time_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/time/best/Label")
	hiscore = score
	max_kills = kills
	max_min = minute
	max_time = time
	score_label.set_text(str(hiscore))
	kills_label.set_text(str(max_kills))
	time_label.set_text(str("%d" % max_min).pad_zeros(2) + ":" + str("%d" % max_time).pad_zeros(2))

func _on_exit_pressed():
	var screen
	screen = load("res://scenes/start_screen.tscn").instance()
	get_node("/root/world/HUD").add_child(screen)
	queue_free()

func _ready():
	saved_data._send()
	var kill_medal = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/kills/best/Sprite")
	var score_medal = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/score/best/Sprite")
	var time_medal = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/stats/time/best/Sprite")
	#SCORE
	if hiscore >= 1000 and hiscore < 2000:
		score_medal.set_frame(1)
	elif hiscore >= 2000 and hiscore < 3000:
		score_medal.set_frame(2)
	elif hiscore >= 3000 and hiscore < 4000:
		score_medal.set_frame(3)
	elif hiscore >= 4000 and hiscore < 5000:
		score_medal.set_frame(4)
	elif hiscore >= 5000:
		score_medal.set_frame(5)
	else:
		score_medal.set_frame(0)
	#KILLS
	if max_kills >= 15 and max_kills < 30:
		kill_medal.set_frame(1)
	elif max_kills >= 30 and max_kills < 50:
		kill_medal.set_frame(2)
	elif max_kills >= 50 and max_kills < 100:
		kill_medal.set_frame(3)
	elif max_kills >= 100 and max_kills < 150:
		kill_medal.set_frame(4)
	elif max_kills >= 150:
		kill_medal.set_frame(5)
	else:
		kill_medal.set_frame(0)
#TIMER
	if max_min >= 1:
		time_medal.set_frame(1)
	elif max_min >= 2:
		time_medal.set_frame(2)
	elif max_min >= 3:
		time_medal.set_frame(3)
	elif max_min >= 4:
		time_medal.set_frame(4)
	elif max_min >= 5:
		time_medal.set_frame(5)
	else:
		time_medal.set_frame(0)
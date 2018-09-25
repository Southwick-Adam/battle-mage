extends Node2D

var score_count = 0
var kill_count = 0
var timer = 0
var minute = 0

func _update(score):
	kill_count += 1
	score_count += score

func _fixed_process(delta):
	timer += delta
	if timer >= 60:
		minute += 1
		timer = 0

	var timer_string = "%d : %02d" % [minute,timer]

	get_node("numbers/score").set_text(str(score_count))
	get_node("numbers/kills").set_text(str(kill_count))
	get_node("numbers/timer").set_text(str(timer_string).pad_zeros(2))
	get_node("numbers/timer").set_visible_characters(5)

func _ready():
	set_fixed_process(true)
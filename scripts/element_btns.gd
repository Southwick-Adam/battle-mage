extends Node2D

var state = 1 #   1-fire 2-water 3-wind 4-earth
var op_lvl = 0.4

func _input(event):
#ELEMENT SHIFT
	if (event.is_action_pressed("btn_a")):
		if state == 4:
			state = 1
		else:
			state += 1

func _fixed_process(delta):
	if state == 1:
		get_node("fire/button/Sprite").set_opacity(1)
		get_node("water/button/Sprite").set_opacity(op_lvl)
		get_node("wind/button/Sprite").set_opacity(op_lvl)
		get_node("earth/button/Sprite").set_opacity(op_lvl)
	elif state == 2:
		get_node("fire/button/Sprite").set_opacity(op_lvl)
		get_node("water/button/Sprite").set_opacity(1)
		get_node("wind/button/Sprite").set_opacity(op_lvl)
		get_node("earth/button/Sprite").set_opacity(op_lvl)
	elif state == 3:
		get_node("fire/button/Sprite").set_opacity(op_lvl)
		get_node("water/button/Sprite").set_opacity(op_lvl)
		get_node("wind/button/Sprite").set_opacity(1)
		get_node("earth/button/Sprite").set_opacity(op_lvl)
	elif state == 4:
		get_node("fire/button/Sprite").set_opacity(op_lvl)
		get_node("water/button/Sprite").set_opacity(op_lvl)
		get_node("wind/button/Sprite").set_opacity(op_lvl)
		get_node("earth/button/Sprite").set_opacity(1)

func _ready():
	set_fixed_process(true)
	set_process_input(true)

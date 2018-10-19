extends Node2D

signal angle
signal stop

onready var center = get_node("center")
var in_state = 0
var tap_state = 0
var follow = false

func _on_TouchScreenButton_pressed():
	tap_state = 1

func _on_TouchScreenButton_released():
	tap_state = 0

func _fixed_process(delta):
#CONTROLS
	if tap_state:
		var center_pos = center.get_global_pos()
		var pos_dif = center_pos - get_global_mouse_pos()
		var angle = atan2(pos_dif.y,pos_dif.x)
		emit_signal("angle", angle)
		if in_state == 1:
			if sqrt(pow(abs(pos_dif.x),2) + pow(abs(pos_dif.y),2)) < 60:
				get_node("knob").set_global_pos(get_global_mouse_pos())
		else:
			get_node("knob").set_pos(Vector2(-cos(angle)*120,-sin(angle)*120))
	else:
		get_node("knob").set_global_pos(center.get_global_pos())
		emit_signal("stop")
func _ready():
	set_fixed_process(true)
	
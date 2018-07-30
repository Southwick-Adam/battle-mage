extends Node2D

var timer = 3

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()


func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D").get_global_pos())
	set_fixed_process(true)
	var spike = load("res://scenes/rock_spike.tscn")
#1
	var spike1 = spike.instance()
	get_node("Position2D1").add_child(spike1)
#2
	var spike2 = spike.instance()
	get_node("Position2D2").add_child(spike2)
#3
	var spike3 = spike.instance()
	get_node("Position2D3").add_child(spike3)
#4
	var spike4 = spike.instance()
	get_node("Position2D4").add_child(spike4)
#5
	var spike5 = spike.instance()
	get_node("Position2D5").add_child(spike5)
#6
	var spike6 = spike.instance()
	get_node("Position2D6").add_child(spike6)
#7
	var spike7 = spike.instance()
	get_node("Position2D7").add_child(spike7)
#8
	var spike8 = spike.instance()
	get_node("Position2D8").add_child(spike8)
#9
	var spike9 = spike.instance()
	get_node("Position2D9").add_child(spike9)
#10
	var spike10 = spike.instance()
	get_node("Position2D10").add_child(spike10)
#11
	var spike11 = spike.instance()
	get_node("Position2D11").add_child(spike11)
#12
	var spike12 = spike.instance()
	get_node("Position2D12").add_child(spike12)
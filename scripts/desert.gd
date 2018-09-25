extends Node2D

var timer = 1.2

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		body._take_damage(80)
		body._stun()

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
#SPIKES
	get_node("Sprite").set_global_pos(get_node("Area2D/Position2D").get_global_pos())
	get_node("Sprite1").set_global_pos(get_node("Area2D/Position2D1").get_global_pos())
	get_node("Sprite2").set_global_pos(get_node("Area2D/Position2D2").get_global_pos())
	get_node("Sprite3").set_global_pos(get_node("Area2D/Position2D3").get_global_pos())
	get_node("Sprite4").set_global_pos(get_node("Area2D/Position2D4").get_global_pos())
	get_node("Sprite5").set_global_pos(get_node("Area2D/Position2D5").get_global_pos())
	get_node("Sprite6").set_global_pos(get_node("Area2D/Position2D6").get_global_pos())
	get_node("Sprite7").set_global_pos(get_node("Area2D/Position2D7").get_global_pos())
	get_node("Sprite8").set_global_pos(get_node("Area2D/Position2D8").get_global_pos())
	get_node("Sprite9").set_global_pos(get_node("Area2D/Position2D9").get_global_pos())
	get_node("Sprite10").set_global_pos(get_node("Area2D/Position2D10").get_global_pos())

func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D/anchor").get_rot()
	set_fixed_process(true)
	get_node("Area2D").set_rot(angle - PI/2)
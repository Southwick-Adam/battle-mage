extends Node2D

var state
var ammount
var angle
var SPEED

onready var player = get_node("/root/world/player/KinematicBody2D")

var timer = .1
var death_timer = 15

func _on_Area2D_body_enter( body ):
	if body == player:
		body._mana_up(state,(ammount * 3))
		queue_free()

func _stop():
	queue_free()

func _fixed_process(delta):
	timer -= delta
	if timer > 0:
		set_global_pos(Vector2(get_global_pos().x + (10 * SPEED * cos(angle)),get_global_pos().y + (10 * SPEED * sin(angle))))
	death_timer -= delta
	if death_timer <= 0:
		queue_free()

func _ready():
	set_fixed_process(true)
	player.connect("death", self, "_stop")
#MANA TYPE
	var rng = randf()
	var tex
	if rng < 0.25:
		get_node("Area2D/Sprite").set_frame(0)
		state = 1
	elif rng >= 0.25 and rng < .5:
		get_node("Area2D/Sprite").set_frame(1)
		state = 2
	elif rng >= 0.5 and rng < .75:
		get_node("Area2D/Sprite").set_frame(2)
		state = 3
	else:
		get_node("Area2D/Sprite").set_frame(3)
		state = 4
#MANA COUNT
	var size_rng = randf()
	var rng = randf()
	var tex
	if rng < 0.15:
		ammount = 1
		set_scale(Vector2(1,1))
	elif rng >= 0.15 and rng < .5:
		ammount = 2
		set_scale(Vector2(2,2))
	elif rng >= 0.5 and rng < .85:
		ammount = 3
		set_scale(Vector2(3,3))
	else:
		ammount = 4
		set_scale(Vector2(4,4))
#MOVEMENT ANGLES
	var neg_rng = randf()
	var neg
	if neg_rng <= 0.5:
		neg = -1
	else:
		neg = 1
	var direction = randf() * (2*PI) * neg
	angle = atan(direction)
	SPEED = randf()

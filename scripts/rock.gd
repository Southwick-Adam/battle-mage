extends KinematicBody2D

const SPEED = 300

var timer = 1.5
var velocity = Vector2()

func _on_Area2D_body_enter( body ):
	get_parent().queue_free()

func _erase():
	get_parent().queue_free()

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		get_parent().queue_free()
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)

func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_fixed_process(true)
#TEXTURE
	var rng = randf()
	if rng <= 0.083:
		get_node("Area2D/Sprite").set_frame(0)
	elif rng > 0.083 and rng <= 0.167:
		get_node("Area2D/Sprite").set_frame(1)
	elif rng > 0.167 and rng <= 0.25:
		get_node("Area2D/Sprite").set_frame(2)
	elif rng > 0.25 and rng <= 0.333:
		get_node("Area2D/Sprite").set_frame(3)
	elif rng > 0.333 and rng <= 0.416:
		get_node("Area2D/Sprite").set_frame(4)
	elif rng > 0.415 and rng <= 0.5:
		get_node("Area2D/Sprite").set_frame(5)
	elif rng > 0.5 and rng <= 0.583:
		get_node("Area2D/Sprite").set_frame(6)
	elif rng > 0.583 and rng <= 0.667:
		get_node("Area2D/Sprite").set_frame(7)
	elif rng > 0.667 and rng <= 0.75:
		get_node("Area2D/Sprite").set_frame(8)
	elif rng > 0.75 and rng <= 0.833:
		get_node("Area2D/Sprite").set_frame(9)
	elif rng > 0.833 and rng <= 0.917:
		get_node("Area2D/Sprite").set_frame(10)
	elif rng > 917:
		get_node("Area2D/Sprite").set_frame(11)


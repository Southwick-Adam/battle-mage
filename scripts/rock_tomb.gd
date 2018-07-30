extends KinematicBody2D

const SPEED = 600
const ACCEL = 0.04

var velocity = Vector2()
var init_timer = 1.5
var timer = 3

func _animate(anim):
	if get_node("Area2D/AnimationPlayer").get_current_animation() != anim:
		get_node("Area2D/AnimationPlayer").play(anim)

func _freeze(target):
	var scene = load("res://scenes/ice block.tscn")
	var ice = scene.instance()
	get_node("/root/world").add_child(ice)
	ice.set_global_pos(target.get_global_pos())

func _on_Area2D_body_enter( body ):
	_freeze(body)

func _fixed_process(delta):
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
	velocity.x = lerp(velocity.x,0,ACCEL)
	velocity.y = lerp(velocity.y,0,ACCEL)
#TIMERS
	init_timer -= delta

	if init_timer <= 0:
		_animate("start")
		velocity = Vector2(0,0)
		timer -= delta

	if timer < 2.8 and timer > 0.5:
		get_node("Area2D").set_enable_monitoring(true)
	else:
		get_node("Area2D").set_enable_monitoring(false)
	if timer <= 0:
		get_parent().queue_free()

func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_fixed_process(true)
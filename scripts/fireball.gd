extends KinematicBody2D

const SPEED = 400

var timer = 1
var velocity = Vector2()
var locked = false
var burn_perc = 0.33

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _on_Area2D_body_enter( body ):
	velocity = Vector2(0,0)
	#body._take_damage(5)
	_animate("boom")
	timer = 10
	var rng = randf()
	if rng < burn_perc:
		var scene = load("res://scenes/burn.tscn")
		var burn = scene.instance()
		body.add_child(burn)

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
	set_rot(angle - PI/2)
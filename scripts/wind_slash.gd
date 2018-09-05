extends KinematicBody2D

const SPEED = 600

var timer = .6
var velocity = Vector2()

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		body._take_damage(13)
	timer = .15

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
	set_fixed_process(true)
	set_global_pos(get_node("/root/world/player/KinematicBody2D/anchor/Position2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D/anchor").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_rot(angle - PI/2)
#TEXTURE
	var rng = randf()
	var tex
	if rng <= 0.167:
		tex = load("res://assets/small_0013.png")
	elif rng > 0.167 and rng <= 0.33:
		tex = load("res://assets/small_0014.png")
	elif rng > 0.33 and rng <= 0.5:
		tex = load("res://assets/small_0015.png")
	elif rng > 0.5 and rng <= 0.667:
		tex = load("res://assets/small_0022.png")
	elif rng > 0.667 and rng <= 0.833:
		tex = load("res://assets/small_0023.png")
	elif rng > 0.833:
		tex = load("res://assets/small_0024.png")
	get_node("Area2D/Sprite").set_texture(tex)
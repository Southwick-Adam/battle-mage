extends KinematicBody2D

const SPEED = 400

var timer = 1
var velocity = Vector2()

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		timer = 10
		_animate("explode")
		velocity = Vector2(0,0)
		body._freeze(.5,3)
		body._take_damage(10)
		body.get_node("Sprite").set_modulate("1f6dd1")

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
	set_global_pos(get_node("/root/world/player/KinematicBody2D/anchor/Position2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D/anchor").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_fixed_process(true)
	set_rot(angle - PI/2)
extends KinematicBody2D

const SPEED = 300

var timer = 1.5
var velocity = Vector2()
var still = true

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _on_Area2D_body_enter( body ):
	velocity = Vector2(0,0)
	_animate("break")
	if body.is_in_group("enemy"):
		body._take_damage(30)

func _erase():
	get_parent().queue_free()

func _go():
	still = false
	get_node("Area2D").set_enable_monitoring(true)
	var angle = get_node("/root/world/player/KinematicBody2D/anchor").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		_animate("break")
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
#STILL
	if still:
		set_global_pos(get_node("/root/world/player/KinematicBody2D/anchor/Position2D").get_global_pos())

func _ready():
	set_fixed_process(true)
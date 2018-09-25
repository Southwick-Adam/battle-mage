extends KinematicBody2D

const SPEED = 200

var timer = 1
var velocity = Vector2()

onready var player = get_node("/root/world/player/KinematicBody2D")

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _on_Area2D_body_enter( body ):
	if body == player:
		velocity = Vector2(0,0)
		body._take_damage(3)
		_animate("boom")
		timer = 10

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
	var player_pos = player.get_global_pos()
	var pos_dif = player_pos - get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)
	velocity.x = cos(angle) * SPEED
	velocity.y = sin(angle) * SPEED
	set_fixed_process(true)
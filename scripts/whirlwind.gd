extends KinematicBody2D

const SPEED = 700
const ACCEL = 0.04

var velocity = Vector2()
var timer = 2

var target1
var target2
var target3
var target4

func _on_Area2D_body_enter( body ):
	if target1 == null:
		target1 = body
	else:
		if target2 == null:
			target2 = body
		else:
			if target3 == null:
				target3 = body
			else:
				if target4 == null:
					target4 = body
				else:
					get_node("Area2D").set_enable_monitoring(false)

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		get_parent().queue_free()
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
	velocity.x = lerp(velocity.x,0,ACCEL)
	velocity.y = lerp(velocity.y,0,ACCEL)
#EFFECT
	if target1 != null:
		var pos_dif = target1.get_global_pos() - get_node("Area2D/Position2D").get_global_pos()
		target1.set_global_pos(Vector2(target1.get_global_pos().x - (pos_dif.x/abs(pos_dif.x)),target1.get_global_pos().y - (pos_dif.y/abs(pos_dif.y))))
	if target2 != null:
		var pos_dif = target2.get_global_pos() - get_node("Area2D/Position2D").get_global_pos()
		target2.set_global_pos(Vector2(target2.get_global_pos().x - (pos_dif.x/abs(pos_dif.x)),target2.get_global_pos().y - (pos_dif.y/abs(pos_dif.y))))
	if target3 != null:
		var pos_dif = target3.get_global_pos() - get_node("Area2D/Position2D").get_global_pos()
		target3.set_global_pos(Vector2(target3.get_global_pos().x - (pos_dif.x/abs(pos_dif.x)),target3.get_global_pos().y - (pos_dif.y/abs(pos_dif.y))))
	if target4 != null:
		var pos_dif = target4.get_global_pos() - get_node("Area2D/Position2D").get_global_pos()
		target4.set_global_pos(Vector2(target4.get_global_pos().x - (pos_dif.x/abs(pos_dif.x)),target4.get_global_pos().y - (pos_dif.y/abs(pos_dif.y))))


func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_fixed_process(true)

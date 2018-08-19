extends KinematicBody2D

const SPEED = 700
const ACCEL = 0.04

var velocity = Vector2()
var timer = 2.3

var target1
var target2
var target3
var target4
var target5
var target6
var target7
var target8

func _pull(target):
	var pos_dif = target.get_global_pos() - get_node("Area2D/Position2D").get_global_pos()
	if abs(pos_dif.x) > 20:
		target.set_global_pos(Vector2(target.get_global_pos().x - 1.5*(pos_dif.x/abs(pos_dif.x)),target.get_global_pos().y))
	if abs(pos_dif.y) > 20:
		target.set_global_pos(Vector2(target.get_global_pos().x,target.get_global_pos().y - 1.5*(pos_dif.y/abs(pos_dif.y))))
	target._take_damage(0.1)

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
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
						if target5 == null:
							target5 = body
						else:
							if target6 == null:
								target6 = body
							else:
								if target7 == null:
									target7 = body
								else:
									if target8 == null:
										target8 = body
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
		target1._freeze(0,.5)
		_pull(target1)
	if target2 != null:
		target2._freeze(0,.5)
		_pull(target2)
	if target3 != null:
		target3._freeze(0,.5)
		_pull(target3)
	if target4 != null:
		target4._freeze(0,.5)
		_pull(target4)
	if target5 != null:
		target5._freeze(0,.5)
		_pull(target5)
	if target6 != null:
		target6._freeze(0,.5)
		_pull(target6)
	if target7 != null:
		target7._freeze(0,.5)
		_pull(target7)
	if target8 != null:
		target8._freeze(0,.5)
		_pull(target8)

func _ready():
	set_global_pos(get_node("/root/world/player/KinematicBody2D/anchor/Position2D").get_global_pos())
	var angle = get_node("/root/world/player/KinematicBody2D/anchor").get_rot()
	velocity.x = cos(angle) * SPEED
	velocity.y = -sin(angle) * SPEED
	set_fixed_process(true)
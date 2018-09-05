extends Node2D

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _erase():
	queue_free()

func _fixed_process(delta):

	var mouse_pos = get_global_mouse_pos()
	var pos_dif = mouse_pos - get_parent().get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)

#ANGLE ANIMS
	if angle > -7*PI/8 and angle <= -5*PI/8:
		get_node("Sprite").set_frame(3)
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		get_node("Sprite").set_frame(4)
	elif angle > -3*PI/8 and angle <= -PI/8:
		get_node("Sprite").set_frame(3)
	elif angle > -PI/8 and angle <= PI/8:
		get_node("Sprite").set_frame(2)
	elif angle > PI/8 and angle <= 3*PI/8:
		get_node("Sprite").set_frame(1)
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		get_node("Sprite").set_frame(0)
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		get_node("Sprite").set_frame(1)
	else:
		get_node("Sprite").set_frame(2)

	if angle > -PI/2 and angle <= PI/2:
		get_node("Sprite").set_flip_h(true)
	else:
		get_node("Sprite").set_flip_h(false)

func _ready():
	set_fixed_process(true)
	get_node("Sprite").set_opacity(0)
	var mouse_pos = get_global_mouse_pos()
	var pos_dif = mouse_pos - get_parent().get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)

	#ANGLE ANIMS
	if angle > -7*PI/8 and angle <= -5*PI/8:
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").set_frame(3)
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").set_frame(4)
	elif angle > -3*PI/8 and angle <= -PI/8:
		get_node("Sprite").set_flip_h(true)
		get_node("Sprite").set_frame(3)
	elif angle > -PI/8 and angle <= PI/8:
		get_node("Sprite").set_flip_h(true)
		get_node("Sprite").set_frame(2)
	elif angle > PI/8 and angle <= 3*PI/8:
		get_node("Sprite").set_flip_h(true)
		get_node("Sprite").set_frame(1)
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").set_frame(0)
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").set_frame(1)
	else:
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").set_frame(2)
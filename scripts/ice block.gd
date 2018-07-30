extends Node2D

var timer = 4

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _erase():
	queue_free()

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		_animate("melt")

func _ready():
	set_fixed_process(true)

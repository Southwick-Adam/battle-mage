extends Node2D

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _erase():
	queue_free()

func _ready():
	pass

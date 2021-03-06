extends Node2D

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _erase():
	queue_free()

func _fixed_process(delta):
	get_parent()._take_damage(-0.05)
	if get_node("AnimationPlayer").get_current_animation() == ("start"):
		if get_node("Sprite").get_scale().x < .7 and get_node("Sprite").get_scale().y < .7:
			get_node("Sprite").set_scale(get_node("Sprite").get_scale() + Vector2(0.02,0.02))
	rotate(0.1)

func _ready():
	set_fixed_process(true)
	get_node("Sprite").set_scale(Vector2(0.05,0.05))
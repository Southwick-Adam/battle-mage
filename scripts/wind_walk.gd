extends Node2D

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _erase():
	queue_free()

func _fixed_process(delta):
	if get_node("AnimationPlayer").get_current_animation() == ("start"):
		if get_node("Position2D").get_scale().x < 0.4 and get_node("Position2D").get_scale().y < 0.2:
			get_node("Position2D").set_scale(get_node("Position2D").get_scale() + Vector2(0.02,0.01))
	get_node("Position2D/Sprite").rotate(0.1)

func _ready():
	set_fixed_process(true)
	get_node("Position2D").set_scale(Vector2(0.05,0.05))

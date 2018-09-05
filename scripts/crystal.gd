extends StaticBody2D

var health = 4

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _death():
	get_parent().queue_free()

func _mana_spawn(ammount):
	var count = ammount
	while count > 0:
		var mana = load("res://scenes/mana.tscn").instance()
		get_node("/root/world").add_child(mana)
		mana.set_global_pos(get_global_pos())
		count -= 1

func _input(event):
	if (event.is_action_pressed("ui_accept")):
		health -= 1

func _fixed_process(delta):
	if health <= 0 and health > -10:
		_mana_spawn(10)
		_animate("end")
		health = -20

func _ready():
	set_scale(Vector2(0.2,0.2))
	set_fixed_process(true)
	set_process_input(true)
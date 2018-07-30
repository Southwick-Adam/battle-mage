extends Area2D

func _fixed_process(delta):
	if (Input.is_action_pressed("btn_x")):
		set_enable_monitoring(true)
	else:
		set_enable_monitoring(false)

func _ready():
	set_fixed_process(true)


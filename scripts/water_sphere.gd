extends Node2D

func _erase():
	queue_free()

func _fixed_process(delta):
	#get_parent()._take_damage(-0.03)
	pass

func _ready():
	set_fixed_process(true)
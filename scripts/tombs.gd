extends Node2D

var timer = 1

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()

func _ready():
	set_fixed_process(true)

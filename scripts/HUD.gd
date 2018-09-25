extends CanvasLayer

onready var screen = get_node("/root/world/player/KinematicBody2D").get_viewport().get_rect().size

func _fixed_process(delta):
	print(screen)

func _ready():
	set_fixed_process(true)

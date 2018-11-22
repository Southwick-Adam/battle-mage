extends Control

onready var world_members = get_tree().get_nodes_in_group("world")

func _on_play_pressed():
	for members in world_members:
		members._start()
		members.set_opacity(1)
		queue_free()

func _on_settings_pressed():
	var screen
	screen = load("res://scenes/options_screen.tscn").instance()
	get_node("/root/world/HUD").add_child(screen)
	queue_free()

func _on_trophy_pressed():
	var screen
	screen = load("res://scenes/trophy_screen.tscn").instance()
	get_node("/root/world/HUD").add_child(screen)
	queue_free()

func _ready():
	for members in world_members:
		members.set_opacity(0)
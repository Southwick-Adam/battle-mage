extends Node2D

var timer = 2
onready var player = get_node("/root/world/player/KinematicBody2D")

func _spawn():
	var enemy
	var location_x = (randf() * 1900) + 85
	var location_y = (randf() * 1800) + 130
	if abs(player.get_global_pos().x - location_x) > 612 and abs(player.get_global_pos().y - location_y) > 400:
		var enemy_rng = randf()
		if enemy_rng >= 0.5:
			enemy = load("res://scenes/zombie.tscn").instance()
		elif enemy_rng < 0.5 and enemy_rng >= 0.2:
			enemy = load("res://scenes/witch.tscn").instance()
		elif enemy_rng < 0.2:
			enemy = load("res://scenes/stone_man.tscn").instance()
		enemy.set_global_pos(Vector2(location_x, location_y))
		get_node("/root/world").add_child(enemy)
	else:
		_spawn()

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		_spawn()
		timer = 5

func _ready():
	set_fixed_process(true)
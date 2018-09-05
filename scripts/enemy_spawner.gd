extends Node2D

var timer = 10

func _spawn():
	var enemy
	var enemy_rng = randf()
	var yrng = randf()
	var y_neg
	if yrng < 0.5:
		y_neg = -1
	else:
		y_neg = 1
	var xrng = randf()
	var x_neg
	if xrng < 0.5:
		x_neg = -1
	else:
		x_neg = 1
	var location = randf() * 1000
	if enemy_rng >= 0.5:
		enemy = load("res://scenes/zombie.tscn").instance()
	elif enemy_rng < 0.5:
		enemy = load("res://scenes/witch.tscn").instance()
	get_node("/root/world").add_child(enemy)
	enemy.set_global_pos(Vector2(location * x_neg, location * y_neg))

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		_spawn()
		timer = 10

func _ready():
	set_fixed_process(true)

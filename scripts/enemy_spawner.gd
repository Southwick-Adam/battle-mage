extends Node2D

var world_timer = 0
var timer = 2
onready var player = get_node("/root/world/player/KinematicBody2D")

var prob_zombie
var prob_witch
var prob_stoneman
var prob_shade

func _spawn():
	var enemy
	var location_x = (randf() * 1900) + 85
	var location_y = (randf() * 1800) + 130
	if abs(player.get_global_pos().x - location_x) > 612 and abs(player.get_global_pos().y - location_y) > 400:
		var enemy_rng = randf()
		if enemy_rng >= prob_zombie:
			enemy = load("res://scenes/zombie.tscn").instance()
		elif enemy_rng < prob_zombie and enemy_rng >= prob_witch:
			enemy = load("res://scenes/witch.tscn").instance()
		elif enemy_rng < prob_witch and enemy_rng >= prob_shade:
			enemy = load("res://scenes/shadow.tscn").instance()
		elif enemy_rng < prob_shade and enemy_rng >= prob_stoneman:
			enemy = load("res://scenes/stone_man.tscn").instance()
		else:
			enemy = load("res://scenes/god_men.tscn").instance()
		enemy.set_global_pos(Vector2(location_x, location_y))
		get_node("/root/world").add_child(enemy)
	else:
		_spawn()

func _start():
	set_fixed_process(true)
	_spawn()
	_spawn()
	_spawn()
	_spawn()

func _stop():
	print("STOP")
	set_fixed_process(false)
	world_timer = 0

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		_spawn()
		timer = 5
	world_timer += delta
	if world_timer > 30 and world_timer <= 50:
		prob_zombie = 0.3
	elif world_timer > 50 and world_timer <= 70:
		prob_zombie = 0.5
		prob_witch = 0.1
	elif world_timer > 70 and world_timer <= 85:
		prob_zombie = 0.7
		prob_witch = 0.3
	elif world_timer > 85 and world_timer <= 100:
		prob_zombie = 0.7
		prob_witch = 0.4
		prob_shade = 0.1
	elif world_timer > 100 and world_timer <= 120:
		prob_zombie = 0.75
		prob_witch = 0.55
		prob_shade = 0.3
		prob_stoneman = 0.1
	elif world_timer > 120:
		prob_zombie = 0.8
		prob_witch = 0.6
		prob_shade = 0.4
		prob_stoneman = 0.2

func _ready():
	prob_zombie = 0
	prob_witch = 0
	prob_shade = 0
	prob_stoneman = 0
	player.connect("death", self, "_stop")
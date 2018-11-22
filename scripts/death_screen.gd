extends Control

onready var GUI = get_node("/root/world/HUD/GUI")
onready var world_members = get_tree().get_nodes_in_group("world")
onready var AOE_member = get_tree().get_nodes_in_group("AOE")

signal stat

var top_score = 0
var top_kills = 0
var top_minuites = 0
var top_time = 0

var max_score
var max_kills
var max_time
var max_minuites

var score = 0
var kills = 0
var time = 0
var minuites = 0

var num = 0
var timer = 0

onready var score_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/scores/score/num/Label")
onready var kills_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/scores/kills/num/Label")
onready var time_label = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/scores/time/num/Label")
onready var enemy = get_tree().get_nodes_in_group("enemy")
var delete = true

func _update(score, kills, time, minute):
	max_score = score
	max_kills = kills
	max_time = time
	max_minuites = minute
	if max_score > top_score:
		top_score = max_score
	if max_kills > top_kills:
		top_kills = max_kills
	if minuites > top_minuites:
		top_minuites = minuites
	if time > top_time:
		top_time = time
	get_node("/root/world/saved_data")._update(top_score,top_kills,top_minuites,top_time)

func _enemy_delete():
	for enemies in enemy:
		enemies.queue_free()
		delete = false

func _on_TouchScreenButton_pressed():
	get_node("/root/world/player/KinematicBody2D")._reset()
	get_node("/root/world/HUD/GUI")._reset()
	for members in world_members:
		members._start()
		members.set_opacity(1)
	queue_free()

func _on_exit_pressed():
	get_node("/root/world/player/KinematicBody2D")._reset()
	get_node("/root/world/HUD/GUI")._reset()
	var screen
	screen = load("res://scenes/start_screen.tscn").instance()
	get_node("/root/world/HUD").add_child(screen)
	queue_free()

func _fixed_process(delta):
	timer += delta
	if timer > 1 and delete:
		for enemies in enemy:
			if enemies.get_opacity() > 0:
				enemies.set_opacity(enemies.get_opacity() - 0.02)
			else:
				_enemy_delete()
	if timer > 1.6:
		GUI.set_opacity(GUI.get_opacity() - 0.01)
		if get_opacity() < 1:
			set_opacity(get_opacity() + 0.1)
	if timer > 2.6:
		if kills < max_kills:
			kills += 1
		else:
			kills = max_kills
			num = 1
	if num >= 1:
		if score < max_score:
			score += (max_score/60)
		else:
			score = max_score
			num = 2
	if num >= 2:
		if minuites < max_minuites:
			if time < 60:
				time += 1
			else:
				minuites += 1
		else:
			if time < max_time:
				time += 1
#LABELS
	score_label.set_text(str(score))
	kills_label.set_text(str(kills))
	time_label.set_text(str("%d" % minuites).pad_zeros(2) + ":" + str("%d" % time).pad_zeros(2))

func _ready():
	set_fixed_process(true)
	set_opacity(0)
	get_node("../../enemy_spawner")._stop()
	for members in AOE_member:
		members.queue_free()
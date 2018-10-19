extends Control

onready var GUI = get_node("/root/world/HUD/GUI")

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
onready var enemy = get_tree().get_nodes_in_group("enemy")
var delete = true

func _update(score, kills, time, minuite):
	max_score = score
	max_kills = kills
	max_time = time
	max_minuites = minuite

func _enemy_delete():
	for enemies in enemy:
		enemies.queue_free()
		delete = false

func _on_TextureButton_pressed():
	get_tree().reload_current_scene()

func _fixed_process(delta):
	timer += delta
	if timer > 0.5 and delete:
		for enemies in enemy:
			if enemies.get_opacity() > 0.04:
				enemies.set_opacity(enemies.get_opacity() - 0.02)
			else:
				_enemy_delete()
	if timer > 2:
		GUI.set_opacity(GUI.get_opacity() - 0.01)
	if timer > 2.6:
		if score < max_score:
			score += (max_score/60)
		else:
			score = max_score
			num += 1
	if num > 1:
		if kills < max_kills:
			kills += 1
		else:
			kills = max_kills
			num += 1
#LABELS
	score_label.set_text(str(score))
	kills_label.set_text(str(kills))

func _ready():
	max_time = 16
	max_minuites = 2
	get_node("/root/world/enemy_spawner").queue_free()
	get_node("/root/world/mana_spawner").queue_free()
	set_fixed_process(true)
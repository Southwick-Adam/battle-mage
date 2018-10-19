extends Control

signal score_sig
signal kills_sig

var op_lvl = 0.4

onready var fire = get_node("elements/fire")
onready var water = get_node("elements/water")
onready var wind = get_node("elements/wind")
onready var earth = get_node("elements/earth")

onready var score = get_node("counters/scores_v/scores_h/score/Label")
onready var kills = get_node("counters/scores_v/scores_h/kills/Label")
onready var time = get_node("counters/scores_v/scores_h/time/Label")

onready var fire_mana = get_node("elements/fire/color")
onready var water_mana = get_node("elements/water/color")
onready var wind_mana = get_node("elements/wind/color")
onready var earth_mana = get_node("elements/earth/color")

onready var window = get_viewport().get_visible_rect().size
onready var player = get_node("/root/world/player/KinematicBody2D")

var max_value = 100.0

var fire_percent = 1.0
var water_percent = 1.0
var wind_percent = 1.0
var earth_percent = 1.0

var fire_value = 100.0
var water_value = 100.0
var wind_value = 100.0
var earth_value = 100.0

var score_count = 0
var kill_count = 0
var timer = 0
var minuite = 0
var state = 1
var btn_timer_state = false
var btn_timer = 0

func _on_fire_pressed():
	if state == 1:
		btn_timer_state = true
	else:
		fire.set_opacity(1)
		water.set_opacity(op_lvl)
		wind.set_opacity(op_lvl)
		earth.set_opacity(op_lvl)
		player._change_state(1)
		state = 1

func _on_water_pressed():
	if state == 2:
		btn_timer_state = true
	else:
		fire.set_opacity(op_lvl)
		water.set_opacity(1)
		wind.set_opacity(op_lvl)
		earth.set_opacity(op_lvl)
		player._change_state(2)
		state = 2

func _on_wind_pressed():
	if state == 3:
		btn_timer_state = true
	else:
		fire.set_opacity(op_lvl)
		water.set_opacity(op_lvl)
		wind.set_opacity(1)
		earth.set_opacity(op_lvl)
		player._change_state(3)
		state = 3

func _on_earth_pressed():
	if state == 4:
		btn_timer_state = true
	else:
		fire.set_opacity(op_lvl)
		water.set_opacity(op_lvl)
		wind.set_opacity(op_lvl)
		earth.set_opacity(1)
		player._change_state(4)
		state = 4

func _release():
	if btn_timer > 0:
		if btn_timer < 0.3:
			player._projectile()
		elif btn_timer >= 0.3:
			player._AOE()
		btn_timer_state = false

func _on_fire_released():
		_release()
func _on_water_released():
		_release()
func _on_wind_released():
		_release()
func _on_earth_released():
		_release()

func _fire_update(mana):
	fire_value = clamp(mana, 0, max_value)
func _water_update(mana):
	water_value = clamp(mana, 0, max_value)
func _wind_update(mana):
	wind_value = clamp(mana, 0, max_value)
func _earth_update(mana):
	earth_value = clamp(mana, 0, max_value)

func _death_update():
	print("TEST")
	get_node("../death_screen")._update(score_count, kill_count, timer, minuite)
	set_fixed_process(false)

func _update(num):
	score_count += num
	kill_count += 1

func _health_check(health):
	get_node("counters/health_v/health").set_value(health)

func _fixed_process(delta):
	score.set_text(str(score_count))
	kills.set_text(str(kill_count))
	time.set_text(str("%d" % minuite).pad_zeros(2) + ":" + str("%d" % timer).pad_zeros(2))
#SIGNALS
	emit_signal("score_sig", score_count)
	emit_signal("kills_sig", kill_count)
#TIMER
	timer += delta
	if timer >= 60:
		minuite += 1
		timer = 0
#BTN_TIMER
	if btn_timer_state:
		btn_timer += delta
	else:
		btn_timer = 0
#POSITION NODES
	get_node("elements").set_global_pos(Vector2(window.x,window.y/2))
	get_node("mover_pos").set_global_pos(Vector2(0,window.y))

#CHANGING MANA BAR
	fire_percent = float(fire_value / max_value)
	fire_mana.set_scale(Vector2(1, -fire_percent))
	water_percent = float(water_value / max_value)
	water_mana.set_scale(Vector2(1, -water_percent))
	wind_percent = float(wind_value / max_value)
	wind_mana.set_scale(Vector2(1, -wind_percent))
	earth_percent = float(earth_value / max_value)
	earth_mana.set_scale(Vector2(1, -earth_percent))

func _ready():
	fire.set_opacity(1)
	water.set_opacity(op_lvl)
	wind.set_opacity(op_lvl)
	earth.set_opacity(op_lvl)
	set_fixed_process(true)
	player.connect("mana_fire", self, "_fire_update")
	player.connect("mana_water", self, "_water_update")
	player.connect("mana_wind", self, "_wind_update")
	player.connect("mana_earth", self, "_earth_update")
	player.connect("death", self, "_death_update")

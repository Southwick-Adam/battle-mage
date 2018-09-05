extends Control

onready var player = get_node("/root/world/player/KinematicBody2D")
onready var mana_bar = get_node("mana")

var max_value = 100.0
var current_value = 100.0
var percent = 1.0

func _update(mana):
	current_value = clamp(mana, 0, max_value)

func _fixed_process(delta):
	percent = float(current_value / max_value)
	mana_bar.set_scale(Vector2(1, -percent))

func _ready():
	player.connect("mana_wind", self, "_update")
	set_fixed_process(true)
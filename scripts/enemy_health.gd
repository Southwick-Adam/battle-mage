extends Control

onready var health_bar = get_node("health")

var max_value = 100.0
var current_value = 100.0
var percent = 1.0

func _update(health):
	current_value = clamp(health, 0, max_value)

func _fixed_process(delta):
	percent = float(current_value / max_value)
	health_bar.set_scale(Vector2(percent, 1))

func _ready():
	get_parent().connect("health", self, "_update")
	set_fixed_process(true)
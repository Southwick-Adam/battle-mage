extends Node2D

var mana_timer = 2
var vortex_timer = 10

func _spawn(item):
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
	if item == ("mana"):
		var location = randf() * 1000
		var mana = load("res://scenes/mana.tscn").instance()
		get_node("/root/world").add_child(mana)
		mana.set_global_pos(Vector2(location * x_neg, location * y_neg))
	elif item == ("vortex"):
		var location = randf() * 1000
		var vortex = load("res://scenes/vortex.tscn").instance()
		get_node("/root/world").add_child(vortex)
		vortex.set_global_pos(Vector2(location * x_neg, location * y_neg))

func _fixed_process(delta):
	mana_timer -= delta
	if mana_timer <= 0:
		_spawn("mana")
		mana_timer = 2
	vortex_timer -= delta
	if vortex_timer <= 0:
		#_spawn("vortex")
		vortex_timer = 60 + (randf() * 30)

func _ready():
	set_fixed_process(true)

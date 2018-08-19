extends Area2D

var timer = 2

var marked = []

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		body._take_damage(2)
		var scene = load("res://scenes/burn.tscn")
		var burn = scene.instance()
		body.add_child(burn)
		if not marked.has(body):
			marked.insert(0,body)

func _fixed_process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
#DAMAGE
	if not marked.empty():
		marked.front()._take_damage(0.2)
		marked.push_back(marked.front())

func _ready():
	set_fixed_process(true)

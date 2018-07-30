extends Particles2D

var timer = 4
var damage_timer = 0.5

func _fixed_process(delta):
	timer -= delta
	if timer <= 3.5 and timer > 3:
		set_amount(23)
	if timer <= 3 and timer > 1:
		set_amount(32)
	if timer <= 1 and timer > 0.5:
		set_amount(15)
	if timer <= 0.5:
		set_amount(7)
	if timer <= 0:
		queue_free()

#EFFECT
	damage_timer -= delta
	if damage_timer <= 0:
		#get_parent()._take_damage(1)
		damage_timer = 0.5

func _ready():
	set_fixed_process(true)

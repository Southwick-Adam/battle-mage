extends KinematicBody2D

const SPEED = 100
const ACCEL = 0.5

var velocity = Vector2()
var health = 100

signal health

func _input(event):
#PROJECTILE ATTACK
	if (event.is_action_pressed("btn_z")):
		var spell_1 = load("res://scenes/fireball.tscn")
		var attack_1 = spell_1.instance()
		get_node("/root/world").add_child(attack_1)
	if (event.is_action_pressed("btn_x")):
		var spell_8 = load("res://scenes/rock.tscn")
		var attack_8 = spell_8.instance()
		get_node("/root/world").add_child(attack_8)
	if (event.is_action_pressed("btn_n")):
		var spell_5 = load("res://scenes/wind_slash.tscn")
		var attack_5 = spell_5.instance()
		get_node("/root/world").add_child(attack_5)
	if (event.is_action_pressed("btn_a")):
		var spell_6 = load("res://scenes/icicle.tscn")
		var attack_6 = spell_6.instance()
		get_node("/root/world").add_child(attack_6)
#AOE ATTACK
	if (event.is_action_pressed("btn_v")):
		var spell_3 = load("res://scenes/flame_wheel.tscn")
		var attack_3 = spell_3.instance()
		add_child(attack_3)
	if (event.is_action_pressed("btn_b")):
		var spell_4 = load("res://scenes/desert.tscn")
		var attack_4 = spell_4.instance()
		get_node("/root/world").add_child(attack_4)
	if (event.is_action_pressed("btn_m")):
		var spell_7 = load("res://scenes/frost_field.tscn")
		var attack_7 = spell_7.instance()
		get_node("/root/world").add_child(attack_7)
	if (event.is_action_pressed("btn_c")):
		var spell_2 = load("res://scenes/whirlwind.tscn")
		var attack_2 = spell_2.instance()
		get_node("/root/world").add_child(attack_2)
#BUFFS
	if (event.is_action_pressed("btn_s")):
		var bspell_1 = load("res://scenes/water_ball.tscn")
		var buff_1 = bspell_1.instance()
		add_child(buff_1)

func _fixed_process(delta):
#SIGNALS
	emit_signal("health", health)
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
#MOVE
	var mouse_pos = get_global_mouse_pos()
	var pos_dif = mouse_pos - get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)
	if (abs(pos_dif.x) > 10 or abs(pos_dif.y) > 10):
		set_rot(-angle)
		velocity.x = cos(angle) * SPEED
		velocity.y = sin(angle) * SPEED
	else:
		velocity.x = lerp(velocity.x,0,ACCEL)
		velocity.y = lerp(velocity.y,0,ACCEL)

func _ready():
	set_fixed_process(true)
	set_process_input(true)
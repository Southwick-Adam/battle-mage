extends KinematicBody2D

const ACCEL = .5

var SPEED
var speed_val
var velocity = Vector2()

onready var sprite = get_node("Sprite")
onready var player = get_node("/root/world/player/KinematicBody2D")
#info
var health = 100
var damage_mult = 1
#timers
var freeze_timer = 0
var attack_timer = 0
#bool
var frozen = false
#attributes
var attack_power = 5

signal health

func _update(dam):
	damage_mult = dam

func _take_damage(damage):
	health -= damage * damage_mult

func _on_attack_body_enter( body ):
	if body == player:
		body._take_damage(attack_power)
		attack_timer = 0.8

func _freeze(perc, time):
	if perc == 0:
		frozen = true
	freeze_timer = time
	SPEED = SPEED * perc

func _bounce():
	var pos_dif = player.get_global_pos() - get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)
	velocity.x = cos(angle) * -2000
	velocity.y = sin(angle) * -2000

func _mana_spawn(ammount):
	var count = ammount
	while count > 0:
		var mana = load("res://scenes/mana.tscn").instance()
		get_node("/root/world").add_child(mana)
		mana.set_global_pos(get_global_pos())
		count -= 1

func _fixed_process(delta):
#SIGNALS
	emit_signal("health", health)
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
#BASIC COLLISION LAWS
	if (is_colliding()):
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		velocity = normal.slide(velocity)
		move(motion)
#MOVE
	var player_pos = player.get_global_pos()
	var pos_dif = player_pos - get_global_pos()
	var angle = atan2(pos_dif.y,pos_dif.x)
	if (abs(pos_dif.x) > 50 or abs(pos_dif.y) > 50):
		velocity.x = cos(angle) * SPEED
		velocity.y = sin(angle) * SPEED
		get_node("anchor").set_rot(-angle)
	else:
		velocity.x = lerp(velocity.x,0,ACCEL)
		velocity.y = lerp(velocity.y,0,ACCEL)
#ATTACK
	get_node("attack").set_global_pos(get_node("anchor/Position2D").get_global_pos())
	if attack_timer >= 0:
		attack_timer -= delta
	if attack_timer > 0:
		get_node("attack").set_enable_monitoring(false)
	else:
		get_node("attack").set_enable_monitoring(true)
#FREEZE
	freeze_timer -= delta
	if freeze_timer <= 0:
		SPEED = speed_val
		frozen = false
		get_node("Sprite").set_modulate("ffffff")

#ANGLE ANIMS
	if angle > -3*PI/4 and angle <= -PI/4:
		get_node("Sprite").set_frame(2)
		get_node("Sprite").set_flip_h(false)
	elif angle > -PI/4 and angle <= PI/4:
		get_node("Sprite").set_frame(1)
		get_node("Sprite").set_flip_h(false)
	elif angle > PI/4 and angle <= 3*PI/4:
		get_node("Sprite").set_frame(0)
		get_node("Sprite").set_flip_h(false)
	else:
		get_node("Sprite").set_frame(1)
		get_node("Sprite").set_flip_h(true)

#DEATH
	if health <= 0:
		var drop_rng = randi()%4+1
		_mana_spawn(drop_rng * attack_power/5)
		get_parent().queue_free()

func _ready():
	set_fixed_process(true)
	SPEED = rand_range(20,70)
	speed_val = SPEED
	player.connect("damage_mult", self, "_update")

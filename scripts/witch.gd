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
var death_timer = 10
var stun_timer = 0
#bool
var frozen = false
var dead = false
#attributes
var attack_power = 5

signal health

func _update(dam):
	damage_mult = dam

func _take_damage(damage):
	health -= damage * damage_mult

func _stun():
	attack_timer = 1.5
	stun_timer = 0.4

func _attack():
	var projectile
	projectile = load("res://scenes/magic.tscn").instance()
	projectile.set_global_pos(get_node("anchor/Position2D").get_global_pos())
	get_node("/root/world").add_child(projectile)
	attack_timer = 2.5

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

func _death():
	var drop_rng = randi()%4+1
	_mana_spawn(drop_rng * attack_power/5)
	get_node("/root/world/HUD/counter")._update(70)
	get_parent().set_opacity(0)
	get_node("CollisionShape2D").queue_free()
	dead = true

func _fixed_process(delta):
	if not dead:
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
		if (abs(pos_dif.x) > 150 or abs(pos_dif.y) > 150) and stun_timer <= 0:
			velocity.x = cos(angle) * SPEED
			velocity.y = sin(angle) * SPEED
			get_node("anchor").set_rot(-angle)
		else:
			velocity.x = lerp(velocity.x,0,ACCEL)
			velocity.y = lerp(velocity.y,0,ACCEL)
#ATTACK
		if attack_timer >= 0:
			attack_timer -= delta
		if attack_timer <= 0 and (abs(pos_dif.x) < 250 or abs(pos_dif.y) < 250) and stun_timer <= 0:
			_attack()
#FREEZE
		freeze_timer -= delta
		if freeze_timer <= 0:
			SPEED = speed_val
			frozen = false
			get_node("Sprite").set_modulate("ffffff")
#STUN
		if stun_timer >= 0:
			stun_timer -= delta
#ANGLE ANIMS
		if stun_timer <= 0:
			if angle > -7*PI/8 and angle <= -5*PI/8:
				get_node("Sprite").set_frame(3)
			elif angle > -5*PI/8 and angle <= -3*PI/8:
				get_node("Sprite").set_frame(4)
			elif angle > -3*PI/8 and angle <= -PI/8:
				get_node("Sprite").set_frame(3)
			elif angle > -PI/8 and angle <= PI/8:
				get_node("Sprite").set_frame(2)
			elif angle > PI/8 and angle <= 3*PI/8:
				get_node("Sprite").set_frame(1)
			elif angle > 3*PI/8 and angle <= 5*PI/8:
				get_node("Sprite").set_frame(0)
			elif angle > 5*PI/8 and angle <= 7*PI/8:
				get_node("Sprite").set_frame(1)
			else:
				get_node("Sprite").set_frame(2)
	
			if angle > -PI/2 and angle <= PI/2:
				get_node("Sprite").set_flip_h(false)
			else:
				get_node("Sprite").set_flip_h(true)
#DEATH
	if health <= 0:
		if dead == false:
			_death()
		death_timer -= delta
		if death_timer <= 0:
			get_parent().queue_free()

func _ready():
	set_fixed_process(true)
	SPEED = rand_range(20,70)
	speed_val = SPEED
	player.connect("damage_mult", self, "_update")

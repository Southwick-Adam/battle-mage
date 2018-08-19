extends KinematicBody2D

const GRAVITY = 1400.0
const ACCELERATION = .5

var SPEED = rand_range(150,250)
var velocity = Vector2()
var DIRECTION = 1
#bool vars
var ground_contact = false
var wall_contact = false
var wall_contact_left = false
var wall_contact_right = false
var basic_anim = true
var alert = false
#onready vars
onready var sprite = get_node("Sprite")
onready var player = get_node("/root/world/player/KinematicBody2D")
#health
var health = 100
#timers
var alert_timer = 0
var turn_timer = 0

func _animate(animation):
	if get_node("AnimationPlayer").get_current_animation() != (animation):
		get_node("AnimationPlayer").play(animation)

func _reset():
	basic_anim = true

func _move():
	if ground_contact:
		velocity.x = lerp(velocity.x, (SPEED * DIRECTION), ACCELERATION)

func _attack(close):
	if close == true:
		var rng = randf()
		if rng <= 0.3:
			_animate("attack_high")
		else:
			_animate("attack_low")
	else:
		_animate("attack_high")

func _take_damage(damage):
	health -= damage

func _on_blade_area_enter( area ):
	if body == get_node("/root/world/player/KinematicBody2D"):
		body._take_damage(25)

func _fixed_process(delta):
#DATA
	var pos_dif = player.get_global_pos() - get_global_pos()
#FLIP STATE
	sprite.set_scale(Vector2(DIRECTION, 1) * 0.5)
#BASIC MOTION LAWS
	var motion = velocity * delta
	motion = move(motion)
#BASIC COLLISION LAWS
	if (is_colliding()):
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		velocity = normal.slide(velocity)
		move(motion)
		ground_contact = true if normal.y <= -0.7 else false
	else: 
		ground_contact = false
#WALL CONTACT
	wall_contact_left = true if test_move(Vector2(-1, 0)) else false
	wall_contact_right = true if test_move(Vector2(1, 0)) else false
	wall_contact = true if wall_contact_right or wall_contact_left else false
#GRAVITY
	velocity.y += delta * GRAVITY
	if abs(velocity.x) > SPEED:
		velocity.x = SPEED * DIRECTION
#IF ALERT
	if alert:
#ALERT
		if abs(pos_dif.x) > 400 or abs(pos_dif.y) > 200:
			alert_timer -= delta
			if alert_timer <= 0:
				alert = false
#MOVE
		if get_node("AnimationPlayer").get_current_animation() != ("attack_high") and get_node("AnimationPlayer").get_current_animation() != ("attack_low") and get_node("AnimationPlayer").get_current_animation() != ("broken"):
			if pos_dif.x > 0: 
				DIRECTION = 1
			elif pos_dif.x < 0: 
				DIRECTION = -1
			if abs(pos_dif.x) >= 100:
				_move()
			else:
				velocity.x = lerp(velocity.x,0,ACCELERATION)
				if abs(pos_dif.y) < 140:
					basic_anim = false
					if abs(pos_dif.y) > 70:
						_attack(false)
					else:
						_attack(true)
		else:
			velocity.x = lerp(velocity.x,0,ACCELERATION)
#IF NOT ALERT
	else:
#ALERT
		if pos_dif.x < 300 and pos_dif.x > -200 and abs(pos_dif.y) < 150:
			alert = true
			alert_timer = 5
#MOVE
		_move()
		if turn_timer < 0:
			turn_timer = rand_range(2,5)
			DIRECTION = -DIRECTION
		else:
			turn_timer -= delta
#ANIMATIONS
	if basic_anim:
		if abs(velocity.x) > 100:
			_animate("move") 
		else:
			_animate("idle")

#DEATH
	if health <= 0:
		queue_free()

func _ready():
	set_fixed_process(true)
#MAKE OVER
	var head_rng = randf()
	var head_tex
	var body_rng = randf()
	var body_tex
#HEAD
	if head_rng < 0.1:
		head_tex = load("res://sprites/zombies/undead_01.png")
	elif head_rng >= 0.1 and head_rng < 0.2:
		head_tex = load("res://sprites/zombies/undead_02.png")
	elif head_rng >= 0.2 and head_rng < 0.3:
		head_tex = load("res://sprites/zombies/undead_03.png")
	elif head_rng >= 0.3 and head_rng < 0.4:
		head_tex = load("res://sprites/zombies/undead_04.png")
	elif head_rng >= 0.4 and head_rng < 0.5:
		head_tex = load("res://sprites/zombies/undead_05.png")
	elif head_rng >= 0.5 and head_rng < 0.6:
		head_tex = load("res://sprites/zombies/undead_06.png")
	elif head_rng >= 0.6 and head_rng < 0.7:
		head_tex = load("res://sprites/zombies/undead_07.png")
	elif head_rng >= 0.7 and head_rng < 0.8:
		head_tex = load("res://sprites/zombies/undead_08.png")
	elif head_rng >= 0.8 and head_rng < 0.9:
		head_tex = load("res://sprites/zombies/undead_09.png")
	elif head_rng >= 0.9 and head_rng < 1:
		head_tex = load("res://sprites/zombies/undead_10.png")
#BODY
	if body_rng < 0.17:
		body_tex = load("res://sprites/zombies/undead_11.png")
	elif body_rng >= 0.17 and body_rng < 0.33:
		body_tex = load("res://sprites/zombies/undead_12.png")
	elif body_rng >= 0.33 and body_rng < 0.5:
		body_tex = load("res://sprites/zombies/undead_13.png")
	elif body_rng >= 0.5 and body_rng < 0.67:
		body_tex = load("res://sprites/zombies/undead_14.png")
	elif body_rng >= 0.67 and body_rng < 0.83:
		body_tex = load("res://sprites/zombies/undead_15.png")
	elif body_rng >= 0.83 and body_rng < 1:
		body_tex = load("res://sprites/zombies/undead_16.png")
#SET TEXTURE
	get_node("Sprite/torso/head").set_texture(head_tex)
	get_node("Sprite/torso").set_texture(body_tex)
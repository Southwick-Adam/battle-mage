extends KinematicBody2D

const ACCEL = 0.5
var SPEED = 100

var velocity = Vector2()
var health = 100
var damage_mult = 1

var damage_score = 1

var buffed = false
var tex

#ELEMENT STATE
var state = 1 #   1-fire 2-water 3-wind 4-earth
var buff_state

signal health
signal damage_mult

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _take_damage(damage):
	health -= (damage * damage_score)

func _buff_end():
	if buff_state == 1:
		get_node("flame_buff").queue_free()
		get_node("Sprite").set_modulate("ffffff")
	elif buff_state == 2:
		get_node("water_ball")._animate("shrink")
	elif buff_state == 3:
		get_node("wind_walk")._animate("shrink")
		SPEED = 100
	elif buff_state == 4:
		get_node("earth_armor")._animate("shrink")
		damage_score = 1
	buffed = false

func _death():
	set_fixed_process(false)
	set_process_input(false)
	_animate("death")

func _input(event):
#ELEMENT SHIFT
	if (event.is_action_pressed("btn_a")):
		if state == 4:
			state = 1
		else:
			state += 1
#PROJECTILE ATTACK
	if (event.is_action_pressed("btn_z")):
		var projectile
		if state == 1: #FIRE
			projectile = load("res://scenes/fireball.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("fire")
		elif state == 2: #WATER
			projectile = load("res://scenes/icicle.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("water")
		elif state == 3: #WIND
			projectile = load("res://scenes/wind_slash.tscn").instance()
			get_node("/root/world").add_child(projectile)
		elif state == 4: #EARTH
			projectile = load("res://scenes/rock.tscn").instance()
		get_node("/root/world").add_child(projectile)
#AOE
	if (event.is_action_pressed("btn_x")):
		var AOE
		if state == 1: #FIRE
			AOE = load("res://scenes/flame_wheel.tscn").instance()
		elif state == 2: #WATER
			AOE = load("res://scenes/frost_field.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("water")
		elif state == 3: #WIND
			AOE = load("res://scenes/whirlwind.tscn").instance()
		elif state == 4: #EARTH
			AOE = load("res://scenes/desert.tscn").instance()
		if state == 1:
			add_child(AOE)
		else:
			get_node("/root/world").add_child(AOE)
#BUFF
	if (event.is_action_pressed("btn_c")):
		if not buffed:
			buff_state = state
			var buff
			if state == 1: #FIRE
				buff = load("res://scenes/flame_buff.tscn").instance()
				get_node("Sprite").set_modulate("ff0000")
				damage_mult = 1.5
				emit_signal("damage_mult", damage_mult)
			elif state == 2: #WATER
				buff = load("res://scenes/water_ball.tscn").instance()
				add_child(buff)
			elif state == 3: #WIND
				buff = load("res://scenes/wind_walk.tscn").instance()
				SPEED = 250
			elif state == 4: #EARTH
				buff = load("res://scenes/earth_armor.tscn").instance()
				damage_score = 0.33
				SPEED = 60
			add_child(buff)
			buffed = true
		else:
			_buff_end()

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
		velocity.x = cos(angle) * SPEED
		velocity.y = sin(angle) * SPEED
		get_node("anchor").set_rot(-angle)
	else:
		velocity.x = lerp(velocity.x,0,ACCEL)
		velocity.y = lerp(velocity.y,0,ACCEL)
#POSITION W/ ELEMENTS
	if state == 1:
		get_node("anchor/Position2D").set_pos(Vector2(25,0))
	elif state == 2:
		get_node("anchor/Position2D").set_pos(Vector2(30,0))
	elif state == 3:
		get_node("anchor/Position2D").set_pos(Vector2(10,0))
	elif state == 4:
		get_node("anchor/Position2D").set_pos(Vector2(40,0))

#ANGLE ANIMS
	if angle > -7*PI/8 and angle <= -5*PI/8:
		_animate("up-left")
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		_animate("up")
	elif angle > -3*PI/8 and angle <= -PI/8:
		_animate("up-right")
	elif angle > -PI/8 and angle <= PI/8:
		_animate("right")
	elif angle > PI/8 and angle <= 3*PI/8:
		_animate("down-right")
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		_animate("down")
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		_animate("down-left")
	else:
		_animate("left")
#DEATH
	if health <= 0:
		_buff_end()
		_death()

func _ready():
	set_fixed_process(true)
	set_process_input(true)
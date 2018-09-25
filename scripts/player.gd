extends KinematicBody2D

const ACCEL = 0.5
var SPEED = 100

var velocity = Vector2()
var health = 100
var tex
#BUFF VALUES
var damage_mult = 1
var damage_score = 1
var buffed = 0
#MANAS
var mana_fire = 100
var mana_water = 100
var mana_wind = 100
var mana_earth = 100
var max_mana = 100
#COSTS
var fire_cost = Vector3(4,15,0.05)
var water_cost = Vector3(3,12,0.08)
var wind_cost = Vector3(2,12,0.03)
var earth_cost = Vector3(4,15,0.03)

#COOLDOWNS
var AOE_timer = 0
var buff_timer = 0

#ELEMENT STATE
var state = 1 #   1-fire 2-water 3-wind 4-earth

signal health
signal damage_mult
signal mana_fire
signal mana_water
signal mana_wind
signal mana_earth

func _animate(anim):
	if get_node("AnimationPlayer").get_current_animation() != anim:
		get_node("AnimationPlayer").play(anim)

func _take_damage(damage):
	health -= (damage * damage_score)

func _buff_end():
	if buffed == 1:
		get_node("flame_buff").queue_free()
		get_node("Sprite").set_modulate("ffffff")
	elif buffed == 2:
		get_node("water_ball")._animate("shrink")
	elif buffed == 3:
		get_node("wind_walk")._animate("shrink")
		SPEED = 100
	elif buffed == 4:
		get_node("earth_armor")._animate("shrink")
		damage_score = 1
		SPEED = 100
	buffed = 0
	buff_timer = 0.5

func _mana_up(state,ammount):
	if state == 1:
		mana_fire += ammount
	elif state == 2:
		mana_water += ammount
	elif state == 3:
		mana_wind += ammount
	elif state == 4:
		mana_earth += ammount

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
		if state == 1 and mana_fire >= fire_cost.x: #FIRE
			projectile = load("res://scenes/fireball.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("fire")
			mana_fire -= fire_cost.x
			get_node("/root/world").add_child(projectile)
		elif state == 2 and mana_water >= water_cost.x: #WATER
			projectile = load("res://scenes/icicle.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("water")
			mana_water -= water_cost.x
			get_node("/root/world").add_child(projectile)
		elif state == 3 and mana_wind >= wind_cost.x: #WIND
			projectile = load("res://scenes/wind_slash.tscn").instance()
			mana_wind -= wind_cost.x
			get_node("/root/world").add_child(projectile)
		elif state == 4 and mana_earth >= earth_cost.x: #EARTH
			projectile = load("res://scenes/rock.tscn").instance()
			mana_earth -= earth_cost.x
			get_node("/root/world").add_child(projectile)
#AOE
	if (event.is_action_pressed("btn_x")) and AOE_timer <= 0:
		var AOE
		if state == 1 and mana_fire >= fire_cost.y: #FIRE
			AOE = load("res://scenes/flame_wheel.tscn").instance()
			mana_fire -= fire_cost.y
			get_node("/root/world").add_child(AOE)
		elif state == 2 and mana_water >= water_cost.y: #WATER
			AOE = load("res://scenes/frost_field.tscn").instance()
			get_node("anchor/Position2D/AnimationPlayer").play("water")
			mana_water -= water_cost.y
			get_node("/root/world").add_child(AOE)
		elif state == 3 and mana_wind >= wind_cost.y: #WIND
			AOE = load("res://scenes/whirlwind.tscn").instance()
			mana_wind -= wind_cost.y
			get_node("/root/world").add_child(AOE)
		elif state == 4 and mana_earth >= earth_cost.y: #EARTH
			AOE = load("res://scenes/desert.tscn").instance()
			mana_earth -= earth_cost.y
			get_node("/root/world").add_child(AOE)
		AOE_timer = 2
#BUFF
	if (event.is_action_pressed("btn_c")) and buff_timer <= 0:
		if buffed == 0:
			var buff
			if state == 1 and mana_fire >= 10 * fire_cost.z: #FIRE
				buff = load("res://scenes/flame_buff.tscn").instance()
				add_child(buff)
				get_node("Sprite").set_modulate("ff0000")
				damage_mult = 1.5
				emit_signal("damage_mult", damage_mult)
				buffed = 1
			elif state == 2 and mana_water >= 10 * water_cost.z: #WATER
				buff = load("res://scenes/water_ball.tscn").instance()
				add_child(buff)
				buffed = 2
			elif state == 3 and mana_wind >= 10 * wind_cost.z: #WIND
				buff = load("res://scenes/wind_walk.tscn").instance()
				SPEED = 250
				add_child(buff)
				buffed = 3
			elif state == 4 and mana_earth >= 10 * earth_cost.z: #EARTH
				get_node("earth_armor")._animate("create")
				damage_score = 0.25
				SPEED = 50
				buffed = 4
		else:
			_buff_end()

func _fixed_process(delta):
#SIGNALS
	emit_signal("health", health)
	emit_signal("mana_fire", mana_fire)
	emit_signal("mana_water", mana_water)
	emit_signal("mana_wind", mana_wind)
	emit_signal("mana_earth", mana_earth)
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
#BUFF COSTS
	if buffed == 1:
		mana_fire -= fire_cost.z
		if mana_fire < fire_cost.z:
			_buff_end()
	elif buffed == 2:
		mana_water -= water_cost.z
		if mana_water < water_cost.z:
			_buff_end()
	elif buffed == 3:
		mana_wind -= wind_cost.z
		if mana_wind < wind_cost.z:
			_buff_end()
	elif buffed == 4:
		mana_earth -= earth_cost.z
		if mana_earth < earth_cost.z:
			_buff_end()
#COOLDOWN
	if AOE_timer >= 0:
		AOE_timer -= delta
	if buff_timer >= 0:
		buff_timer -= delta
#MAX MANA
	if mana_fire > max_mana:
		mana_fire = max_mana
	if mana_water > max_mana:
		mana_water = max_mana
	if mana_wind > max_mana:
		mana_wind = max_mana
	if mana_earth > max_mana:
		mana_earth = max_mana
#ANGLE ANIMS
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
		get_node("Sprite").set_flip_h(true)
	else:
		get_node("Sprite").set_flip_h(false)
#DEATH
	if health <= 0:
		if buffed != 0:
			_buff_end()
		_death()

func _ready():
	set_fixed_process(true)
	set_process_input(true)
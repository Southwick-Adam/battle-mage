extends Control

var music_on = true
var sound_on = true

onready var music_check = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/settings/music/icon/music/Sprite")
onready var sound_check = get_node("MarginContainer/Patch9Frame/MarginContainer/VBoxContainer/settings/sound/icon/sound/Sprite")

func _on_music_pressed():
	if music_on:
		music_on = false
	else:
		music_on = true

func _on_sound_pressed():
	if sound_on:
		sound_on = false
	else:
		sound_on = true

func _on_exit_pressed():
	var screen
	screen = load("res://scenes/start_screen.tscn").instance()
	get_node("/root/world/HUD").add_child(screen)
	queue_free()

func _fixed_process(delta):
	if sound_on:
		sound_check.set_opacity(1)
	else:
		sound_check.set_opacity(0)
	if music_on:
		music_check.set_opacity(1)
	else:
		music_check.set_opacity(0)

func _ready():
	set_fixed_process(true)



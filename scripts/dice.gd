extends Node2D

signal move_ended
signal roll_ended(result)

const MOVES_MAX = 50.0
const ROLLS_MAX = 6.0
const MOVE_TIME = 1.0 / MOVES_MAX
const ROLL_TIME = 1.5 / ROLLS_MAX

var value_sprite : Sprite2D
var rng = RandomNumberGenerator.new()
var last_roll = -1
var moves_left = -1
var rolls_left = -1
var start_position = global_position
var final_position = global_position

func _ready():
	get_node("BGSprite").texture = load("res://pictures/Dice-"+get_parent().color+".png")
	value_sprite = get_node("ValueSprite")
	value_sprite.texture = Global.dice_textures_value[5]
	Global.timeout.connect(_move_continue)
	Global.timeout.connect(_roll_continue)

@warning_ignore("shadowed_variable_base_class")
func _move_continue(name):
	if name != str(get_path())+"move":
		return
	moves_left -= 1
	if moves_left == 0:
		global_position = final_position
		move_ended.emit()
		return
	global_position = start_position + (final_position - start_position) * ((MOVES_MAX - moves_left) / MOVES_MAX)
	Global.add_timer(str(get_path())+"move", MOVE_TIME)

@warning_ignore("shadowed_variable_base_class")
func _roll_continue(name):
	if name != str(get_path())+"roll":
		return
	rolls_left -= 1
	if rolls_left == 0:
		roll_ended.emit(last_roll)
		return
	last_roll = rng.randi_range(1, 6)
	value_sprite.texture = Global.dice_textures_value[last_roll-1]
	Global.add_timer(str(get_path())+"roll", ROLL_TIME)

func move(marker):
	moves_left = MOVES_MAX
	start_position = global_position
	final_position = marker.global_position
	Global.add_timer(str(get_path())+"move", MOVE_TIME)

func roll():
	rolls_left = ROLLS_MAX
	Global.add_timer(str(get_path())+"roll", ROLL_TIME)

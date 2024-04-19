extends Node2D

signal place_ended(current_dice)
signal enable_ended(rolls_result)

@export var color : String

var label_color_enabled = Color(1.0, 1.0, 0.0, 1.0)
var label_color_disabled = Color(1.0, 1.0, 1.0, 1.0)
var label : Label
var taken = []
var dices = []
var markers = []
var rolls_result = []
var rolls_left = 0
var current_place = 0
var dices_left = 4

func _ready():
	for i in 4:
		taken.append(false)
		markers.append(get_node("Marker2D"+str(i+1)))
		dices.append(get_node("Dice"+str(i+1)))
		dices[i].move_ended.connect(_place_continue)
		dices[i].roll_ended.connect(_enable_continue)
	label = get_node("Label")
	label.text = get_name()
	label.set("theme_override_colors/font_color", label_color_disabled)

func _enable_continue(roll):
	rolls_result.append(roll)
	rolls_left -= 1
	if rolls_left == 0:
		enable_ended.emit(rolls_result)

func _place_continue():
	place_ended.emit(dices[current_place])

func enable():
	label.set("theme_override_colors/font_color", label_color_enabled)
	rolls_result = []
	rolls_left = 0
	for i in 4:
		if taken[i]:
			continue
		rolls_left += 1
		dices[i].roll()

func disable():
	label.set("theme_override_colors/font_color", label_color_disabled)
	return dices_left == 0

func place(value, marker):
	dices_left -= 1
	for i in range(3, -1, -1):
		if taken[i]:
			continue
		if dices[i].last_roll != value:
			continue
		current_place = i
		taken[i] = true
		dices[i].move(marker)
		return

func retrive(dice):
	dices_left += 1
	for i in len(dices):
		if dice != dices[i]:
			continue
		current_place = i
		taken[i] = false
		dice.move(markers[i])
		break

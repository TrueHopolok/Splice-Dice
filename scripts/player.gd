extends Node2D

signal place_ended(current_dice)
signal enable_ended(rolls_result)

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
	get_node("Label").text = get_name()
	#TODO:BORDER_COLOR = dark_grey

func _enable_continue(roll):
	rolls_result.append(roll)
	rolls_left -= 1
	if rolls_left == 0:
		enable_ended.emit(rolls_result)

func _place_continue():
	place_ended.emit(dices[current_place])

func playable():
	#TODO:BORDER_COLOR = weak_yellow
	pass

func enable():
	# TODO:BORDER_COLOR = full_yellow
	rolls_result = []
	rolls_left = 0
	for i in 4:
		if taken[i]:
			continue
		rolls_left += 1
		dices[i].roll()

func disable():
	# TODO:BORDER_COLOR = weak_yellow
	return dices_left == 0

func place(marker):
	dices_left -= 1
	for i in range(3, -1, -1):
		if taken[i]:
			continue
		current_place = i
		taken[i] = true
		dices[i].move(marker)
		break

func retrive(dice):
	dices_left += 1
	for i in len(dices):
		if dice != dices[i]:
			continue
		current_place = i
		taken[i] = false
		dice.move(markers[i])
		break

extends Node2D

signal place_ended(current_cube)
signal enable_ended(rolls_result)

var taken = []
var cubes = []
var markers = []
var rolls_result = []
var rolls_left = 0
var current_place = 0
var cubes_left = 4

func _ready():
	for i in 4:
		taken.append(false)
		markers.append(get_node("Marker2D"+str(i+1)))
		cubes.append(get_node("Cube"+str(i+1)))
		cubes[i].move_ended.connect(_place_continue)
		cubes[i].roll_ended.connect(_enable_continue)
	get_node("Label").text = get_name()

func _enable_continue(roll):
	rolls_result.append(roll)
	rolls_left -= 1
	if rolls_left == 0:
		enable_ended.emit(rolls_result)

func _place_continue():
	place_ended.emit(cubes[current_place])

func enable():
	# TODO:GLOW 100%
	rolls_result = []
	rolls_left = 0
	for i in 4:
		if taken[i]:
			continue
		rolls_left += 1
		cubes[i].roll()

func disable():
	# TODO:GLOW 0%
	return cubes_left == 0

func place(marker):
	cubes_left -= 1
	for i in range(3, -1, -1):
		if taken[i]:
			continue
		current_place = i
		taken[i] = true
		cubes[i].move(marker)
		break

func retrive(cube):
	cubes_left += 1
	for i in len(cubes):
		if cube != cubes[i]:
			continue
		current_place = i
		taken[i] = false
		cube.move(markers[i])
		break

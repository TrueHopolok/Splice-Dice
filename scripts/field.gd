extends StaticBody2D

signal clear_ended
signal place_ended
signal selected(emitter)

@onready var collision = get_node("CollisionShape2D")
@onready var cube_position = get_node("Marker2D")
var detection = false
var current_cube = null
var current_player = null

func _ready():
	collision.disabled = true

func _mouse_enter():
	# TODO:GLOW 100%
	detection = true

func _input(event):
	if detection and not collision.disabled:
		if is_instance_of(event, InputEventMouseButton):
			if event.button_index == 1 and event.pressed:
				selected.emit(self)

func _mouse_exit():
	# TODO:GLOW 50%
	detection = false

func _place_continue(cube):
	# TODO:SET TO PLAYER COLOR
	current_player.place_ended.disconnect(_place_continue)
	current_cube = cube
	place_ended.emit()

func _clear_continue(cube):
	# TODO:SET TO DEFAULT COLOR
	current_player.place_ended.disconnect(_clear_continue)
	current_player = null
	current_cube = null
	clear_ended.emit()

func enable():
	# TODO:GLOW 50%
	collision.disabled = false
	
func disable():
	# TODO:GLOW 0%
	collision.disabled = true

func place(player):
	current_player = player
	current_player.place_ended.connect(_place_continue)
	current_cube = player.place(cube_position)

func clear():
	if current_cube == null:
		clear_ended.emit()
		return
	current_player.place_ended.connect(_clear_continue)
	current_player.retrive(current_cube)

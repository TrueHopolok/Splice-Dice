extends StaticBody2D

signal clear_ended
signal place_ended
signal selected(emitter)

@onready var collision = get_node("CollisionShape2D")
@onready var dice_position = get_node("Marker2D")
var detection = false
var current_dice = null
var current_player = null

func _ready():
	collision.disabled = true
	# TODO:BG_COLOR = STANDART_COLOR
	# TODO:BORDER_COLOR = dark_gray

func _mouse_enter():
	detection = true
	# TODO:BORDER_COLOR = full_yellow

func _input(event):
	if detection and not collision.disabled:
		if is_instance_of(event, InputEventMouseButton):
			if event.button_index == 1 and event.pressed:
				selected.emit(self)

func _mouse_exit():
	detection = false
	# TODO:BORDER_COLOR = weak_yellow

func _place_continue(dice):
	current_player.place_ended.disconnect(_place_continue)
	current_dice = dice
	# TODO:BG_COLOR = PLAYER_COLOR
	place_ended.emit()

func _clear_continue(dice):
	current_player.place_ended.disconnect(_clear_continue)
	current_player = null
	current_dice = null
	# TODO:BG_COLOR = STANDART_COLOR
	clear_ended.emit()

func enable():
	collision.disabled = false
	# TODO:BORDER_COLOR = weak_yellow
	
func disable():
	collision.disabled = true
	# TODO:BORDER_COLOR = dark_grey

func place(player):
	current_player = player
	current_player.place_ended.connect(_place_continue)
	current_dice = player.place(dice_position)

func clear():
	if current_dice == null:
		clear_ended.emit()
		return
	current_player.place_ended.connect(_clear_continue)
	current_player.retrive(current_dice)

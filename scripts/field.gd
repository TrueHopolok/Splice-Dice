extends StaticBody2D

signal clear_ended
signal place_ended
signal selected(emitter)

@export var field_value : int

var bg_texture_standart : Texture2D
var bg_sprite : Sprite2D
var collision : CollisionShape2D
var dice_position : Marker2D
var detection = false
var current_dice = null
var current_player = null

func _ready():
	collision = get_node("CollisionShape2D")
	dice_position = get_node("Marker2D")
	bg_texture_standart = load("res://pictures/Dice-Grey.png")
	bg_sprite = get_node("BGSprite")
	bg_sprite.texture = bg_texture_standart
	get_node("ValueSprite").texture = load("res://pictures/Dice-"+str(field_value)+".png")
	collision.disabled = true
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
	current_dice.hide()
	bg_sprite.texture = load("res://pictures/Dice-"+current_player.color+".png")
	place_ended.emit()

func _clear_continue(dice):
	current_player.place_ended.disconnect(_clear_continue)
	current_player = null
	current_dice = null
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
	current_dice = player.place(field_value, dice_position)

func clear():
	if current_dice == null:
		clear_ended.emit()
		return
	bg_sprite.texture = bg_texture_standart
	current_dice.show()
	current_player.place_ended.connect(_clear_continue)
	current_player.retrive(current_dice)

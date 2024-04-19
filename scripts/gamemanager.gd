extends Node2D

var fields = []
var players = []
var current_player = 0
var current_rolls = []
var moves_amount = 0
var current_field = null
var gameover_window = null

func _ready():
	gameover_window = get_node("Window")
	gameover_window.hide()
	for i in Global.player_amount:
		players.append(get_node("Player"+str(i+1)))
		players[i].enable_ended.connect(_move_rolled)
	for i in 6:
		fields.append(get_node("Field"+str(i+1)))
		fields[i].connect("selected", _move_selected)
	print("DEBUG: "+get_name()+" players_amount = "+str(Global.player_amount))
	move_start()

func _move_end():
	if players[current_player].disable():
		gameover()
		return
	current_player += 1
	if current_player >= Global.player_amount:
		current_player = 0
	move_start()

func _move_placed():
	print("DEBUG: "+get_name()+" placed field")
	current_field.clear_ended.disconnect(_move_placed)
	_move_end()

func _move_cleared():
	print("DEBUG: "+get_name()+" cleared field")
	current_field.clear_ended.disconnect(_move_cleared)
	_move_end()

func _move_selected(field):
	print("DEBUG: "+get_name()+" selected "+field.get_name())
	current_field = field
	for i in current_rolls:
		fields[i-1].disable()
	if current_field.current_dice != null:
		current_field.clear_ended.connect(_move_cleared)
		current_field.clear()
		return
	current_field.place_ended.connect(_move_placed)
	current_field.place(players[current_player])

func _move_rolled(rolls_result):
	print("DEBUG: "+get_name()+" rolled "+str(rolls_result))
	current_rolls = rolls_result
	for i in current_rolls:
		fields[i-1].enable()	

func move_start():
	print("DEBUG: "+get_name()+" started Player"+str(current_player+1))
	moves_amount += 1
	players[current_player].enable()

func gameover():
	print("DEBUG: "+get_name()+ \
	"\n  winner = Player"+str(current_player+1)+\
	"\n  moves_amount = "+str(moves_amount))
	gameover_window.show()
	# TODO: OPEN WINDOW (game result + name request) 
	# TODO: SAVE GAME (db insert + encryption)
	# TODO: LOAD MAINMENU (write MAINMENU)

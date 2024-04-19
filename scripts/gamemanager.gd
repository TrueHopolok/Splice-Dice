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
	for i in range(Global.player_amount, 6):
		get_node("Player"+str(i+1)).hide()
	for i in 6:
		fields.append(get_node("Field"+str(i+1)))
		fields[i].connect("selected", _move_selected)
	#print("DEBUG: "+get_name()+" players_amount = "+str(Global.player_amount))
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
	#print("DEBUG: "+get_name()+" placed field")
	current_field.clear_ended.disconnect(_move_placed)
	_move_end()

func _move_cleared():
	#print("DEBUG: "+get_name()+" cleared field")
	current_field.clear_ended.disconnect(_move_cleared)
	current_field.place_ended.connect(_move_placed)
	current_field.place(players[current_player])

func _move_selected(field):
	#print("DEBUG: "+get_name()+" selected "+field.get_name())
	current_field = field
	for i in current_rolls:
		fields[i-1].disable()
	current_field.clear_ended.connect(_move_cleared)
	current_field.clear()

func _move_rolled(rolls_result):
	#print("DEBUG: "+get_name()+" rolled "+str(rolls_result))
	current_rolls = rolls_result
	for i in current_rolls:
		fields[i-1].enable()	

func _gameover_continue():
	var winner_name = gameover_window.get_node("GameoverUI/Input").text
	if winner_name == "":
		winner_name = "Player"+str(current_player+1)
	Global.database.insert_row("Games", { 
		#TODO:ecryption
		"winner" = winner_name, 
		"datetime" = Time.get_datetime_string_from_system(), 
		"length" = str(moves_amount),
	})
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func move_start():
	#print("DEBUG: "+get_name()+" started Player"+str(current_player+1))
	moves_amount += 1
	players[current_player].enable()

func gameover():
	#print("DEBUG: "+get_name()+ \
	#"\n  winner = Player"+str(current_player+1)+\
	#"\n  moves_amount = "+str(moves_amount))
	gameover_window.show()
	gameover_window.get_node("GameoverUI/Info").text = \
	"Winner is Player"+str(current_player+1)+"\nGame lasted "+str(moves_amount)+" moves"
	gameover_window.get_node("GameoverUI/Button").pressed.connect(_gameover_continue)

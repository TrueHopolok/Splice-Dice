extends Control

func _ready():
	var games = Global.database.select_rows(
		"Games", "", ["datetime", "winner", "length"]
	)
	games.reverse()
	var label = get_node(
		"ColorRect/RichTextLabel"
	)
	for game in games:
		label.text += "\
When happened = %s | \
Winner's name = %s | \
Moves amount = %s\n" % [
			Global.xor(game["datetime"]), 
			Global.xor(game["winner"]), 
			Global.xor(game["length"])
		]
	get_node(
		"Button"
	).pressed.connect(
		load_mainmenu
	)
	
func load_mainmenu():
	get_tree().change_scene_to_file(
		"res://scenes/mainmenu.tscn"
	)

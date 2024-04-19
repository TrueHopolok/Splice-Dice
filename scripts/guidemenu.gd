extends Control

func _ready():
	get_node(
		"Button"
	).pressed.connect(
		load_mainmenu
	)
	
func load_mainmenu():
	get_tree().change_scene_to_file(
		"res://scenes/mainmenu.tscn"
	)

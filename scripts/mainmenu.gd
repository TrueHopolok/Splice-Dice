extends Control

func _ready():
	get_node(
		"VBoxContainer/PlayContainer/PlayButton"
	).pressed.connect(
		start_game
	)
	get_node(
		"VBoxContainer/QuitButton"
	).pressed.connect(
		get_tree().quit
	)
	get_node(
		"VBoxContainer/GuideButton"
	).pressed.connect(
		show_guide
	)
	get_node(
		"VBoxContainer/HistoryButton"
	).pressed.connect(
		show_history
	)

func show_guide():
	get_tree().change_scene_to_file(
		"res://scenes/guidemenu.tscn"
	)

func show_history():
	get_tree().change_scene_to_file(
		"res://scenes/historymenu.tscn"
	)

func start_game():
	Global.player_amount = get_node(
		"VBoxContainer/PlayContainer/PlayersAmount/OptionButton"
	).selected + 2
	get_tree().change_scene_to_file(
		"res://scenes/gamemanager.tscn"
	)

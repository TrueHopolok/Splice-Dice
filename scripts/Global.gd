extends Node

signal timeout(name)

var database : SQLite
var player_amount = 6
var requests = []
var dice_textures_value = []

func _ready():
	database = SQLite.new()
	database.path = "db/games_history.db"
	database.open_db()
	for i in range(1, 7):
		dice_textures_value.append(load("res://pictures/Dice-"+str(i)+".png"))

func _process(delta):
	var i = 0
	while i < len(requests):
		requests[i][1] -= delta
		if requests[i][1] <= 0.0:
			timeout.emit(requests[i][0])
			requests.remove_at(i)
			continue
		i += 1

func add_timer(name, time):
	requests.append([name, time])

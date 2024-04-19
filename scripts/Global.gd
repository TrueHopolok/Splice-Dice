extends Node

signal timeout(name)

var player_amount = 2
var requests = []

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

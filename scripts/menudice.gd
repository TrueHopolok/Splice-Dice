extends Node2D

func _ready():
	var rng = RandomNumberGenerator.new()
	get_node("ValueSprite").texture = load("res://pictures/Dice-"+str(rng.randi_range(1, 6))+".png")

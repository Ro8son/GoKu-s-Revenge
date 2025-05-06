extends Enemy

@export var speed = 30

@onready var explosion = preload("res://scenes/effects/explosion_small.tscn")

func _ready():
	add_to_group("enemies")
	pass

func _process(delta: float) -> void:
	position.y += speed * delta

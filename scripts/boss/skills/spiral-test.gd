extends Node2D

@onready var marker: Marker2D = $Marker2D

@onready var bullet = preload("res://scenes/bullets/green-bullet.tscn")
@onready var bullet_script = preload("res://scripts/boss/bullets/basic-bullet.gd")

func _ready() -> void:
	add_to_group("spawner")
	print(global_position)
	print(position)
	pass

var j := 0
var can_attack := true

func _physics_process(_delta: float) -> void:
	if can_attack:
		can_attack = false
		for i in range(15):
			var b = bullet.instantiate()
			b.set_script(bullet_script)
			b.position = position
			var angle = j + i * TAU / 15
			b.dir = Vector2(sin(angle), cos(angle)) * 200.0
			get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
		get_tree().create_timer(0.2).timeout.connect(func(): j+= 1; can_attack = true)

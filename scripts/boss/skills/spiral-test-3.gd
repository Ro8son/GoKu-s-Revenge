extends Node2D

@onready var marker: Marker2D = $Marker2D

@onready var bullet = preload("res://scenes/bullets/red-bullet.tscn")
@onready var bullet_script = preload("res://scripts/boss/bullets/spiral-bullet-2.gd")

func _ready() -> void:
	add_to_group("spawner")
	print(global_position)
	print(position)
	pass


var can_attack := true
var j := 0
var dir := 10

func _physics_process(_delta: float) -> void:
	if can_attack:
		can_attack = false
		
		for i in range(15):
			var b = bullet.instantiate()
			b.set_script(bullet_script)
			b.position = position
			b.angle_rad = j + i * TAU / 15
			b.angle_div = dir
			get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
		get_tree().create_timer(2).timeout.connect(func(): j+=1 ;can_attack = true)
		dir = -dir
		if j > 20:
			j = 0

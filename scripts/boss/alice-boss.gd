extends Boss

#Needed to switch animations  
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var plr: Node

@onready var bullet_green = preload("res://scenes/bullets/enemy_bullet_basic_shoot_green.tscn")
@onready var bullet_yellow = preload("res://scenes/bullets/enemy_bullet_basic_shoot_yello.tscn")
@onready var bullet_red = preload("res://scenes/bullets/enemy_bullet_basic_shoot_red.tscn")
@onready var bullet = preload("res://scenes/bullets/enemy_bullet_basic_shoot.tscn")
@onready var bullet_narumi = preload("res://scenes/bullets/enemy_bullet_narumi_shoot_green.tscn")
@onready var bullet_aunn = preload("res://scenes/bullets/enemy_bullet_aunn_shoot_green.tscn")

func wait_background():
	anim.animation = "idle"
	plr = get_tree().get_nodes_in_group("player")[0]
	await get_tree().create_timer(1).timeout

@onready var basic_spawner = preload("res://scenes/bosses/skills/Spiral-test.tscn")
@onready var ext_spawner = preload("res://scenes/bosses/skills/Spiral-test-2.tscn")
@onready var ext3_spawner = preload("res://scenes/bosses/skills/Spiral-test-3.tscn")

func first_stage():
	var spn = basic_spawner.instantiate()
	spn.global_position = global_position
	add_child(spn)
	#var spn3 = ext_spawner.instantiate()
	#spn3.global_position = global_position
	#add_child(spn3)
	var spn2 = ext3_spawner.instantiate()
	spn2.global_position = global_position
	add_child(spn2)
	await stage_end(0)

func stage_end(percentage: int):
	while hp * 100 / max_hp > percentage and not interrupt:
		await get_tree().create_timer(1).timeout
	print("next stage!")
	

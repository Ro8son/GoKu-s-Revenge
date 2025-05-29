extends Boss

#Needed to switch animations  
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var plr: Node



func wait_background():
	anim.animation = "idle"
	plr = get_tree().get_nodes_in_group("player")[0]
	await get_tree().create_timer(1).timeout
	
func move_background():
	for i in range(180):
		if interrupt:
			break
		var angle = (i + 135) * TAU / 180
		position = Vector2(640,250) + Vector2(sin(angle), cos(angle)-1) * 50.0
		if cos(angle) < 0:
			anim.animation = "move_left"
		elif cos(angle) > 0:
			anim.animation = "move_right"
		await get_tree().create_timer(0.01).timeout
	for i in range(180):
		if interrupt:
			break
		var angle = (i + 135) * TAU / 180
		position = Vector2(640,250) + Vector2(-sin(angle), cos(angle)-1) * 50.0 - Vector2(100,0)
		if cos(angle) > 0:
			anim.animation = "move_left"
		elif cos(angle) < 0:
			anim.animation = "move_right"
		await get_tree().create_timer(0.01).timeout

func wait_stage():
	anim.animation = "idle"
	plr = get_tree().get_nodes_in_group("player")[0]
	await get_tree().create_timer(1).timeout
	

func first_stage():
	anim.animation = "idle"
	shoot_at_player()
	con_non_spell(20, 100)
	await next_stage_hp(50)
	
	
func second_stage():
	anim.animation = "cast"
	con_spiral()
	dan(30, 80)
	await next_stage_hp(1)

	
#Example shooting function
@onready var bullet_green = preload("res://scenes/bullets/enemy_bullet_basic_shoot_green.tscn")
@onready var bullet_yellow = preload("res://scenes/bullets/enemy_bullet_basic_shoot_yello.tscn")
@onready var bullet_red = preload("res://scenes/bullets/enemy_bullet_basic_shoot_red.tscn")
@onready var bullet = preload("res://scenes/bullets/enemy_bullet_basic_shoot.tscn")
@onready var bullet_aunn = preload("res://scenes/bullets/enemy_bullet_aunn_shoot_green.tscn")

func con_non_spell( amount , radius):
	var stage := currrent
	while true:
		for j in range(4):
			if interrupt or ends[stage]:
				break
			var origin = points_on_circle(global_position, 10, amount)
			var target = points_on_circle(global_position, 10 + radius, amount)

			for i in range(amount):
				var b = bullet_aunn.instantiate()
				b.position = origin[i]
				b.target_position = target[i]  # Now valid because bullet_aunn.gd defines this property
				get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
			await get_tree().create_timer(1.5).timeout
		await get_tree().create_timer(3).timeout

func con_spiral():
	var stage := currrent
	while true:
		if interrupt or ends[stage]:
			break
		anim.animation = "cast"	
		for j in range(14):
			if interrupt or ends[stage]:
				break
			for i in range(4):
				var b = bullet_yellow.instantiate()
				b.position = position
				var angle_offset = deg_to_rad(-25 + j * 24 + i * 4)
				var angle = angle_offset
				b.dir = Vector2(cos(angle), sin(angle)) * 200.0
				get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
				await get_tree().create_timer(0.08).timeout

func points_on_circle(center: Vector2, radius: float, count: int) -> Array:
	var points = []
	for i in range(count):
		var angle = (2.0 * PI / count) * i
		var point = Vector2(
			center.x + radius * cos(angle),
			center.y + radius * sin(angle)
		)
		points.append(point)
	return points

func dan( amount , radius):
	var stage := currrent
	while true:
		if interrupt or ends[stage]:
			break
		for j in range(6):
			if interrupt or ends[stage]:
				break

			var origin = points_on_circle(global_position, 10, amount)
			var targets: Array
			targets.append(points_on_circle(global_position, 10 + radius, amount))
			targets.append(points_on_circle(global_position, 10 + radius * 2, amount))
			targets.append(points_on_circle(global_position, 10 + radius * 3, amount))

			for i in range(amount):
				var b = bullet_aunn.instantiate()
				b.position = origin[i]
				b.target_position = targets[i%3][i]  # Now valid because bullet_aunn.gd defines this property
				get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
			await get_tree().create_timer(3).timeout
		await get_tree().create_timer(5).timeout

func con_shoot():
	anim.animation = "cast"
	for j in range(80):
		if interrupt or end:
			break
		for i in range(15):
			var b = bullet_green.instantiate()
			b.position = position
			var angle = j + i * TAU / 15
			b.dir = Vector2(sin(angle), cos(angle)) * 200.0
			get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
		await get_tree().create_timer(0.3).timeout
		
func shoot_at_player():
	var stage := currrent
	while true:
		anim.animation = "cast"
		var angle_main = (plr.global_position - global_position).angle()

		for j in range(5):
			if interrupt or ends[stage]:
				break
			for i in range(6):
				var b = bullet.instantiate()
				b.position = position
				var angle_offset = deg_to_rad(-25 + i * 10)
				var angle = angle_main + angle_offset
				b.dir = Vector2(cos(angle), sin(angle)) * 200.0
				get_node("/root/Main/SubViewportContainer/Main_Viewport").add_child(b)
			await get_tree().create_timer(0.2).timeout
		await get_tree().create_timer(2).timeout
	

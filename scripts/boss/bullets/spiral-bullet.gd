extends Area2D

@export var speed = 80

var center: Vector2
var angle_rad: float

@export var current_radius: float = 0
@export var target_radius: float = 200

var target_pos: Vector2
var done := false

func _ready():
	add_to_group("bullets")
	body_entered.connect(_on_body_entered)
	center = position
	await get_tree().create_timer(10).timeout
	if not entered:
		queue_free()
	
func  _physics_process(delta: float) -> void:
	if current_radius < target_radius:
		current_radius += 1
		angle_rad = deg_to_rad(rad_to_deg(angle_rad)+1)
		target_pos = point_on_circle(center, current_radius, angle_rad)
	elif !done:
		done = true
		current_radius += 1000
		speed *= 4 
		target_pos = point_on_circle(center, current_radius, angle_rad)
	position = position.move_toward(target_pos, delta * speed)

func point_on_circle(center: Vector2, radius: float, angle_radians: float) -> Vector2:
	var point = Vector2(
		center.x + radius * cos(angle_radians),
		center.y + radius * sin(angle_radians)
	)
	return point

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.hit()
		
var entered = false
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	entered = true
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

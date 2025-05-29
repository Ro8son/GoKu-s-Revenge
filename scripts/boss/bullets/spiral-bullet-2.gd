extends Area2D

@export var speed = 50 * 2

var _center: Vector2
var angle_rad: float
var angle_div: int

@export var current_radius: float = 0

var target_pos: Vector2
var done := false

func _ready():
	add_to_group("bullets")
	body_entered.connect(_on_body_entered)
	_center = position
	await get_tree().create_timer(10).timeout
	if not entered:
		queue_free()

var here := false

func  _physics_process(delta: float) -> void:
	if !here:
		current_radius += 100
		target_pos = point_on_circle(_center, current_radius, angle_rad + deg_to_rad(angle_div) )
		here = true

	position = position.move_toward(target_pos, delta * speed)
	if position.distance_to(target_pos) <= 1:
		angle_div = -angle_div
		print(angle_div)
		here = false

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

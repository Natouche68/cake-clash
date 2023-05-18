extends CharacterBody3D


@export var speed: float = 0.7
@export var dash_speed: float = 15
@export var dash_force_modifier: float = 1.5
@export var control_scheme: String
@export var player_number: int
@export var can_move: bool = false

@onready var move_left_action: String = "move_left_" + control_scheme
@onready var move_right_action: String = "move_right_" + control_scheme
@onready var move_up_action: String = "move_up_" + control_scheme
@onready var move_down_action: String = "move_down_" + control_scheme
@onready var dash_action: String = "dash_" + control_scheme

var force: Vector2
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if not is_dashing:
		var direction = Vector2.ZERO
		if can_move:
			direction = Input.get_vector(move_left_action, move_right_action, move_up_action, move_down_action).normalized()
		velocity.x = velocity.x * 0.92 + direction.x * speed + force.x
		velocity.z = velocity.z * 0.92 + direction.y * speed + force.y
		
		if direction != Vector2.ZERO:
			$AnimationPlayer.speed_scale = 4
		else:
			$AnimationPlayer.speed_scale = 1
		
		if direction.x > 0:
			var tween = create_tween()
			tween.tween_property($Eyes/LeftPupil, "position:x", -0.335, 0.5)
			tween.parallel().tween_property($Eyes/RightPupil, "position:x", 0.505, 0.5)
		elif direction.x < 0:
			var tween = create_tween()
			tween.tween_property($Eyes/LeftPupil, "position:x", -0.505, 0.5)
			tween.parallel().tween_property($Eyes/RightPupil, "position:x", 0.335, 0.5)
		elif direction.x == 0:
			var tween = create_tween()
			tween.tween_property($Eyes/LeftPupil, "position:x", -0.42, 0.5)
			tween.parallel().tween_property($Eyes/RightPupil, "position:x", 0.42, 0.5)
		
		if can_move and can_dash and Input.is_action_just_pressed(dash_action):
			is_dashing = true
			can_dash = false
			dash_direction = direction
			
			$"..".screenshake(0.3)
			$DashParticles.emitting = true
			
			if dash_direction.x < 0:
				var tween = create_tween()
				tween.tween_property($Sprite, "rotation_degrees:z", 15, 0.5)
				tween.parallel().tween_property($Outline, "rotation_degrees:z", 15, 0.2)
				tween.parallel().tween_property($Eyes, "position:x", -0.25, 0.2)
			elif dash_direction.x > 0:
				var tween = create_tween()
				tween.tween_property($Sprite, "rotation_degrees:z", -15, 0.5)
				tween.parallel().tween_property($Outline, "rotation_degrees:z", -15, 0.2)
				tween.parallel().tween_property($Eyes, "position:x", 0.25, 0.2)
			
			get_tree().create_timer(0.3).timeout.connect(func():
				is_dashing = false
				speed /= 2
				
				var tween = create_tween()
				tween.tween_property($Sprite, "rotation_degrees:z", 0, 0.5)
				tween.parallel().tween_property($Outline, "rotation_degrees:z", 0, 0.2)
				tween.parallel().tween_property($Eyes, "position:x", 0, 0.5)
				
				get_tree().create_timer(0.2).timeout.connect(func():
					$DashParticles.emitting = false
				)
				
				get_tree().create_timer(1).timeout.connect(func():
					can_dash = true
					speed *= 2
				)
			)
	elif is_dashing:
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.y * dash_speed
	
	force *= 0.8
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("players"):
			collision.get_collider().apply_force(position, velocity, dash_force_modifier if is_dashing else 1.0)


func apply_force(other_player_position: Vector3, other_player_velocity: Vector3, force_modifier: float) -> void:
	if other_player_velocity.distance_to(Vector3.ZERO) > velocity.distance_to(Vector3.ZERO):
		force += Vector2((position - other_player_position).x, (position - other_player_position).z) * 1.8 * force_modifier
		
		$"..".screenshake(0.15)
		$HurtAudioPlayer.play()
		
		$TouchedParticles.emitting = true
		await get_tree().create_timer(0.5).timeout
		$TouchedParticles.emitting = false


func play_fall_sound() -> void:
	$FallAudioPlayer.play()

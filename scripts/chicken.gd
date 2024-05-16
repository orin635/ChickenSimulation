extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") / 3
var walk_speed = 1
var max_speed = walk_speed
var rotation_speed = 5.0
var acceleration = 5
var alignment_strength = randf_range(0.5,1.5)
var cohesion_strength = randf_range(0.5,1.5)
var separation_strength = randf_range(0.5,1.5)
var perception_radius = 5
var is_scared = false
var hunger = 0

var target_position = Vector3()
var change_target_timer = 0.0
var change_target_interval = 3.0

var hunger_rate = 1000

#Animation Variables
@onready var body = $Body
@onready var head = $Body/head
@onready var l_leg = $Body/L_leg
@onready var r_leg = $Body/R_leg
var default_body_rotation
var default_body_origin
var default_head_rotation
var default_head_origin
var default_l_leg_rotation
var default_l_leg_origin
var default_r_leg_rotation
var default_r_leg_origin

var leg_swing_direction = 1
var leg_swing_speed = 1 
var leg_max_swing_angle = 0.4 


var chicken_scene_path = "res://scenes/chicken.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	default_body_rotation = body.rotation
	default_body_origin = body.transform.origin
	default_head_rotation = head.rotation
	default_head_origin = head.transform.origin
	default_l_leg_rotation = l_leg.rotation
	default_l_leg_origin = l_leg.transform.origin
	default_r_leg_rotation = r_leg.rotation
	default_r_leg_origin = r_leg.transform.origin
	set_new_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	run_animation(delta)
	max_speed = max_speed - (hunger/10)

func _physics_process(delta):
	# Add gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	#flock(delta)
	random_walk(delta)
	process_food(delta)
	move_and_slide()
	mate()
	if velocity.length() > 0:
			var direction = velocity.normalized()
			var target_rotation = atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	
	
	
#func random_walk(delta):
	#if is_on_floor():
		#if randf_range(0, 100) < 5:
			#var random_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
			#velocity.x = lerp(velocity.x,(random_direction.x * max_speed), acceleration * delta)
			#velocity.z = lerp(velocity.z,(random_direction.y * max_speed), acceleration * delta)
func random_walk(delta):
	if is_on_floor():
		change_target_timer -= delta
		if change_target_timer <= 0:
			set_new_target()
			change_target_timer = change_target_interval
			change_target_interval = randf_range(2,3)

		var direction = (target_position - global_transform.origin).normalized()
		velocity.x = lerp(velocity.x, direction.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * max_speed, acceleration * delta)

func set_new_target():
	target_position = global_transform.origin + Vector3(randf_range(-20, 20), 0, randf_range(-20, 20))
	#print("New target position: ", target_position)

func mate():
	if hunger < 8:
		for chicken in get_tree().get_nodes_in_group("chicken"):
			var distance_to_chicken = global_transform.origin.distance_to(chicken.global_transform.origin)
			if distance_to_chicken < 2 and chicken != self:
				spawn_chicken()

func spawn_chicken():
	var chicken_scene = load(chicken_scene_path) as PackedScene
	if chicken_scene:
		var chicken_instance = chicken_scene.instantiate()
		var spawn_position = global_transform.origin
		
		chicken_instance.global_transform.origin = spawn_position
		chicken_instance.global_transform.origin.x = chicken_instance.global_transform.origin.x + 1
		chicken_instance.global_transform.origin.z = chicken_instance.global_transform.origin.z + 1
		chicken_instance.add_to_group("chicken")
		add_child(chicken_instance)
	else:
		print("Error: Unable to load chicken scene")

func flock(delta):
	var alignment = Vector3()
	var cohesion = Vector3()
	var separation = Vector3()
	var total_neighbors = 0
	for neighbor in get_tree().get_nodes_in_group("chickens"):
		if neighbor != self and global_transform.origin.distance_to(neighbor.global_transform.origin) < perception_radius:
			alignment += neighbor.velocity
			cohesion += neighbor.global_transform.origin
			separation += (global_transform.origin - neighbor.global_transform.origin) / global_transform.origin.distance_to(neighbor.global_transform.origin)
			total_neighbors += 1

	if total_neighbors > 0:
		alignment = (alignment / total_neighbors).normalized() * alignment_strength
		cohesion = ((cohesion / total_neighbors) - global_transform.origin).normalized() * cohesion_strength
		separation = (separation / total_neighbors).normalized() * separation_strength

		velocity += alignment + cohesion + separation
		velocity = clamp_velocity(velocity, max_speed)
	
func clamp_velocity(velocity, max_speed):
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	return velocity

func process_food(delta):
	if randf_range(0, hunger_rate) < 1:
		hunger = hunger + 1
	
	if hunger > 0:
		search_for_food(delta)
	
	if hunger > 10:
		self.queue_free()

func search_for_food(delta):
	var nearest_food = null
	var nearest_distance = INF

	for food in get_tree().get_nodes_in_group("food"):
		var distance_to_food = global_transform.origin.distance_to(food.global_transform.origin)
		if distance_to_food < nearest_distance:
			nearest_food = food
			nearest_distance = distance_to_food

	if nearest_food:
		move_towards(nearest_food.global_transform.origin, delta)

func move_towards(target, delta):
	var direction = (target - global_transform.origin).normalized()
	print(direction)
	velocity.x = lerp(velocity.x,direction.x * max_speed,  acceleration * delta)
	velocity.z = lerp(velocity.z,(direction.z * max_speed), acceleration * delta)
	velocity.y = 0



func _on_area_3d_body_entered(body):
	if body.is_in_group("chickens"):
		hunger = hunger - 1


func run_animation(delta):
	if velocity.length() > 0 and is_on_floor():
		# Swing the legs based on the velocity
		l_leg.rotation.x += leg_swing_speed * leg_swing_direction * delta
		r_leg.rotation.x -= leg_swing_speed * leg_swing_direction * delta
		
		# Check if the legs have reached their max swing angle and reverse direction
		if l_leg.rotation.x >= default_l_leg_rotation.x + leg_max_swing_angle:
			leg_swing_direction = -1
		elif l_leg.rotation.x <= default_l_leg_rotation.x - leg_max_swing_angle:
			leg_swing_direction = 1
	else:
		# Reset to default positions
		body.rotation = default_body_rotation
		l_leg.rotation = default_l_leg_rotation
		r_leg.rotation = default_r_leg_rotation



func _on_hunger_rate_value_changed(value):
	hunger_rate = 1300 - (value * 100)


func _on_move_speed_value_changed(value):
	max_speed = value

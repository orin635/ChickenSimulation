extends Node3D


var food_scene_path = "res://scenes/food.tscn"
var spawn_interval = 15
var spawn_timer = 0.0
var min_spawn_bounds = Vector3(-20, 4, -20) 
var max_spawn_bounds = Vector3(20, 4, 20) 

func _ready():
	# Load the Food scene
	if not ResourceLoader.exists(food_scene_path):
		print("Error: Food scene path does not exist")
		return
	
	set_process(true)

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_food()

func spawn_food():
	var food_scene = load(food_scene_path) as PackedScene
	if food_scene:
		var food_instance = food_scene.instantiate()
		var random_x = randf_range(min_spawn_bounds.x, max_spawn_bounds.x)
		var random_z = randf_range(min_spawn_bounds.z, max_spawn_bounds.z)
		var spawn_position = Vector3(random_x, min_spawn_bounds.y, random_z)
		
		food_instance.global_transform.origin = spawn_position
		food_instance.add_to_group("food") 
		add_child(food_instance)
	else:
		print("Error: Unable to load food scene")





func _on_food_spawn_time_value_changed(value):
	spawn_interval = value

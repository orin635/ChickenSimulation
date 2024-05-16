
extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.is_in_group("chickens"):
		self.queue_free()

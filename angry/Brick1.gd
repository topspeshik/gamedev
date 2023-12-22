extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health = 150
func _ready():
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	contact_monitor = true

func _on_RigidBody2D_body_entered(body):
	if is_instance_valid(body):
		if body is RigidBody2D:
			body = body as RigidBody2D
			var damage = body.linear_velocity.length() * .1
			health -= damage
			GameManager.score +=damage
			if(health <= 0):
				queue_free()


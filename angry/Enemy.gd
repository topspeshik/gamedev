extends RigidBody2D



var health = 500

func _ready():
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Enemy_body_entered(body):
	if is_instance_valid(body):
		if body is RigidBody2D:
			if body.is_in_group("Player"):
				queue_free()
			else:
				var damage = body.linear_velocity.length() * 5
				health -= damage
				GameManager.score +=damage
				if health <= 0:
					queue_free()

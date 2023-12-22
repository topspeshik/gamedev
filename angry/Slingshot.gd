extends Node2D

enum SlingState{
	start,
	pulling,
	thrown,
	reset
}

var slingShotState
var leftLine
var rightLine
var centerOfSlingshot
var pulling = false

var bird



# Called when the node enters the scene tree for the first time.
func _ready():
	slingShotState = SlingState.start
	leftLine = $LeftLine
	rightLine = $RightLine
	centerOfSlingshot =  $CenterOfSlingshot.position
	leftLine.points[1] = centerOfSlingshot
	rightLine.points[1] = centerOfSlingshot
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.position = centerOfSlingshot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match slingShotState:
		SlingState.start:
			pass
		SlingState.pulling:
			on_pulling_event(delta)
		SlingState.reset:
			var birds = get_tree().get_nodes_in_group("Player")
			if birds.size() > 0:
				bird = birds[0] as RigidBody2D
				$Tween.interpolate_property(bird,"position",bird.position, centerOfSlingshot, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				if (bird.global_position - centerOfSlingshot).length() < 0.2:
					slingShotState = SlingState.start

			

func _on_TouchArea_input_event(viewport, event, shape_idx):
	if slingShotState == SlingState.start:
		if((event is InputEventMouseButton || event is InputEventScreenTouch) && event.pressed):
			slingShotState = SlingState.pulling
			pulling = true


func on_pulling_event(delta):
	var player = get_tree().get_nodes_in_group("Player")[0]
	
	var location = get_global_mouse_position()
	if location.distance_to($CenterOfSlingshot.position) > 100:
		location = (location - $CenterOfSlingshot.position).normalized() * 100 + $CenterOfSlingshot.position
	var velocity = centerOfSlingshot - location
	if Input.is_action_pressed("left_mouse"):
		player.position = location
		leftLine.points[1] = location
		rightLine.points[1] = location
		trajectory(location, delta)
	else:
		$Trajectory.clear_points()
		var distance = location.distance_to(centerOfSlingshot)
		player.ThrowBird()
		player = player as RigidBody2D
		player.apply_impulse(Vector2(),  velocity/15 * distance)
		slingShotState = SlingState.thrown
		leftLine.points[1] = centerOfSlingshot
		rightLine.points[1] = centerOfSlingshot
		GameManager.CurrentGameState = GameManager.GameState.Play
		get_tree().get_nodes_in_group("Camera")[0].followingPlayer = true
		
		

func trajectory(location, delta):
	var velocity = centerOfSlingshot - location
	var distance = location.distance_to(centerOfSlingshot)
	var actVelocity = velocity/15 * distance
	var pointPosition = centerOfSlingshot
	$Trajectory.clear_points()
	for i in 5000:
		$Trajectory.add_point(pointPosition)
		actVelocity.y += 150 * delta 
		pointPosition += actVelocity * delta 
		if pointPosition.y > $Trajectory.position.y:
			break		
	
func _input(event):
	if(event is InputEventScreenTouch && !event.is_pressed()):
		pulling = false

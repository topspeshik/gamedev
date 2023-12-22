extends Camera2D


var startingPos
var player
var followingPlayer
var clicking = false
var slingshot
# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = global_position
	player = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if followingPlayer:
		if is_instance_valid(player):
			if player.position.x > position.x:
				var playerpos = clamp(player.position.x, 0, 5000)
				global_position = Vector2(playerpos,startingPos.y)
		else:
			followingPlayer = false
			$Tween.interpolate_property(self,"position",position,startingPos,2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			$Tween.start()

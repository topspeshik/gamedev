extends Node2D


enum GameState {
	Start,
	Play,
	End
}

var CurrentGameState = GameState.Start

var score = 0

var deleteWood = false

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match CurrentGameState:
		GameState.Start:
			pass
		GameState.Play:
			var birds = get_tree().get_nodes_in_group("Bird")
			var pigs = get_tree().get_nodes_in_group("Enemy")
			if pigs.size() <= 0:
				CurrentGameState = GameState.End
			elif birds.size() <= 0:
				CurrentGameState = GameState.End
			pass
		GameState.End:
			get_tree().get_nodes_in_group("ControlScore")[0].PopupLevelCompleted(score)
			CurrentGameState = GameState.Start

func RestartLevel():
	get_tree().change_scene("res://Gameloop.tscn")
	CurrentGameState = GameState.Start
	score = 0

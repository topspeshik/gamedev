extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func PopupLevelCompleted(score):
	$Popup/ScoreEditText.text = str(int(score))
	
	$Popup.show()


func _on_AgainButton_button_down():
	GameManager.RestartLevel()


func _on_ExitButton_button_down():
	get_tree().quit()

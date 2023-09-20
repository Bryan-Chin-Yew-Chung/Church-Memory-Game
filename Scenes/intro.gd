extends Control

var playButton

func _ready():
	
	playButton = get_node('CenterContainer/Panel/VBoxContainer/Label')
	playButton.pressed.connect(self.newGame)
	get_tree().set_pause(true)

func newGame():
	get_tree().set_pause(false)
	GameManager.resetGame()
	queue_free()

func win():
	$CenterContainer/Panel.set_texture(load("res://Assets/win.png"))
	$CenterContainer/Panel/VBoxContainer/Label2.text = "You won the game in " + str(GameManager.seconds) + " seconds in " + str(GameManager.moves) + " flips!"
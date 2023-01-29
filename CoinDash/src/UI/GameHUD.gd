extends CanvasLayer

signal start_game
signal wait_game

func _ready():
	var _temp = $StartButton.connect("pressed",self,"_on_startButton_pressed")


func update_score(value):
	$MarginContainer/ScoreLabel.text = "s " + str(value)

func update_level(value):
	$MarginContainer/LevelLabel.text = "l " + str(value)

func update_time(value):
	$MarginContainer/TimeLabel.text = "t " + str(value)
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func _on_messageTime_timeout():
	$MessageLabel.hide()
	
func _on_startButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer,"timeout")
	emit_signal("wait_game")
	$StartButton.show()
	$MessageLabel.text = "Coin Dash"
	$MessageLabel.show()				

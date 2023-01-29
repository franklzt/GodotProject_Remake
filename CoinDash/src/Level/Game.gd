extends Node2D

export(PackedScene) var Coin
export(PackedScene) var PowerUp
export(int) var playTime = 30

var level = 1
var score = 0
var timeLeft = 30
var screenSize = Vector2.ZERO
var playing = false


func _ready():
	randomize()
	screenSize = get_viewport().get_visible_rect().size
	$Player.screenSize = screenSize
	_on_wait_game()
	var _temp = $HUD.connect("start_game",self,"new_game")
	_temp = $HUD.connect("wait_game",self,"_on_wait_game")
	_temp = $GameTimer.connect("timeout",self,"_on_GameTimer_timeout")
	_temp = $Player.connect("pickup",self,"_on_player_pickup")
	_temp = $Player.connect("hurt",self,"_on_player_hurt")
	_temp = $Player.connect("powerup",self,"_on_player_powerup")
	_temp = $PowerUpTimer.connect("timeout",self,"spawn_powerups")
	$Cactus.hide()
	
	
func _on_GameTimer_timeout():
	timeLeft -=1
	$HUD.update_time(timeLeft)
	if timeLeft <=0:
		gameover()

func _on_player_pickup():
	$CoinSound.play()
	score += 1
	$HUD.update_score(score)
	
func _on_player_hurt():
	gameover()	
	
func _on_player_powerup():
	$PowerUpSound.play()
	score += 5
	timeLeft += 2
	$HUD.update_score(score)
	$HUD.update_time(timeLeft)

func _on_wait_game():
	$Player.hide()
	level = 0
	score = 0
	timeLeft = 0
	$HUD.update_score(score)
	$HUD.update_time(timeLeft)
	$HUD.update_level(level)	
	
func new_game():
	playing = true
	level = 1
	score = 0
	timeLeft = playTime	
	$HUD.update_score(score)
	$HUD.update_time(timeLeft)
	$HUD.update_level(level)
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$Cactus.show()
	spawn_cons()
	
	
func spawn_cons():
	$LevelSound.play()
	for _i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screenSize = screenSize
		c.position = Vector2(rand_range(50,screenSize.x),rand_range(200,screenSize.y))
	$PowerUpTimer.wait_time = rand_range(5,10)
	$PowerUpTimer.start()	
		
func spawn_powerups():
	$PowerUpSound.play()
	var p = PowerUp.instance()
	$CoinContainer.add_child(p)
	p.screenSize = screenSize
	p.position = Vector2(rand_range(50,screenSize.x),rand_range(200,screenSize.y))

func _process(_delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level+=1
		timeLeft += 5
		$HUD.update_level(level)
		spawn_cons()

func gameover():
	playing = false
	$EndSound.play()
	$GameTimer.stop()
	$PowerUpTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$Cactus.hide()	
	$HUD.show_game_over()
	$Player.end()

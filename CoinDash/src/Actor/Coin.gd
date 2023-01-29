extends Area2D

var screenSize = Vector2.ZERO


func _ready():
	var _temp = $Tween.connect("tween_completed",self,"_on_tween_completed")
	$Tween.interpolate_property($AnimatedSprite,'scale',
	$AnimatedSprite.scale,$AnimatedSprite.scale * 3,0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)

	$Tween.interpolate_property($AnimatedSprite,'modulate',
	Color(1,1,1,1),Color(1,1,1,0),0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
	_temp = $AnimTimer.connect("timeout",self,"_on_AnimTimer_timeout");
	$AnimTimer.wait_time = rand_range(3,8)
	$AnimTimer.start()
	
func _on_AnimTimer_timeout():
	$AnimatedSprite.frame = 0;
	$AnimatedSprite.play("default")
	
func _on_tween_completed(_object,_key):
	queue_free()

func pickup():
	monitoring = false
	$Tween.start()


func randomPos():
	 position = Vector2(rand_range(0,screenSize.x),rand_range(0,screenSize.y))

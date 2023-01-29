extends Area2D
class_name Player

export(int) var speed = 350
var velocity = Vector2.ZERO
var screenSize = Vector2(480,720)

signal pickup
signal hurt
signal powerup

func _ready():
	var _temp = self.connect("area_entered",self,"_on_area_enter")

func Idle():
	position = Vector2(16,16)
	$AnimatedSprite.animation = "idle"
		
func _on_area_enter(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("powerup")	
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()
	pass	

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x,0,screenSize.x)
	position.y = clamp(position.y,0,screenSize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"
	
func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
		

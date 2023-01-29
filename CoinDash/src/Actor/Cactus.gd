extends Area2D


func _ready():
	var _temp = connect("area_entered",self,"_on_area_entered")


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.randomPos()


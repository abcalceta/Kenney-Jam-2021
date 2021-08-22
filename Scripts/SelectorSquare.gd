extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal clockwiseTurn
signal counterClockwiseTurn
var closestGem = null
# Called when the node enters the scene tree for the first time.
func _ready():
	posTween()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouse:
		$PosTween.start()
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				emit_signal("clockwiseTurn", closestGem)
			if event.button_index == BUTTON_RIGHT:
				emit_signal("counterClockwiseTurn", closestGem)

func posTween():
	var closestToMouse = getClosestToMouse()
	closestGem = closestToMouse[0]
	var snapPosition = closestToMouse[1]
	$PosTween.interpolate_property(self, "position", position, snapPosition, 0.05, Tween.TRANS_SINE, Tween.EASE_IN, 0.0)

func getClosestToMouse():
	var pos = Vector2.ZERO
	var mousePos = get_global_mouse_position()
	var smallestDistance = Vector2.INF
	if get_tree().get_nodes_in_group("GemSelectorAreas").size()>0:
		var smallestDistanceGem = get_tree().get_nodes_in_group("GemSelectorAreas")[0]
		for gem in get_tree().get_nodes_in_group("GemSelectorAreas"):
			if mousePos.distance_to(smallestDistanceGem.global_position) > mousePos.distance_to(gem.global_position):
				smallestDistanceGem = gem
				smallestDistance = mousePos.distance_to(gem.global_position)
				
		pos = smallestDistanceGem.position
		return [smallestDistanceGem, pos]
	else:
		return [null, Vector2.ZERO]



func _on_PosTween_tween_completed(object, key):
	if object == self:
		posTween()
	pass # Replace with function body.

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var positionOnBoard = Vector2.ZERO
var id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label2.text = str(positionOnBoard)
	$Label.text = str(id)
	pass

func moveTo(finalPos):
	if not $Tween.is_active():
		$Tween.interpolate_property(self, "position", position, finalPos, 0.25, Tween.TRANS_SINE, Tween.EASE_IN, 0.0)
		$Tween.start()

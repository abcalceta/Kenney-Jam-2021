extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0.25
var rot = 90
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and false: # let's not rotate it makes me dizzy
			if event.button_index == BUTTON_LEFT:
				rotateClockwise()
			if event.button_index == BUTTON_RIGHT:
				rotateCounterClockwise()
			$Tween.start()

func rotateClockwise():
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees-rot, speed, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)

func rotateCounterClockwise():
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees+rot, speed, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)

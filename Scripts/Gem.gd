extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var positionOnBoard = Vector2.ZERO
var id = -1
var speed = 0.1
export var type = -1
var finalPos = null
signal showGems
# Called when the node enters the scene tree for the first time.
func _ready():
	showSelf()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label2.text = str(positionOnBoard)
	$ID.text = str(id)
	pass

func moveTo(fp):
	if not $Tween.is_active():
		finalPos = fp
		$Tween.interpolate_property(self, "position", position, finalPos, speed, Tween.TRANS_SINE, Tween.EASE_IN, 0.0)
		$AnimationPlayer.play("makeBig")
		$Tween.start()

func hideSelf():
	$AnimationPlayer.play("hide")
	
func showSelf():
	$AnimationPlayer.playback_speed = rand_range(0.9, 1.1)
	$AnimationPlayer.play("show")

func makeBigAnimation():
	$AnimationPlayer.play("makeBig")

func centerAnimation():
	$AnimationPlayer.play("center")

func _on_Tween_tween_completed(object, key):
	position = finalPos
	$Sprite.rotation_degrees = 0
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "center":
		$Sprite.rotation_degrees = 0
	pass # Replace with function body.

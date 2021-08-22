extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, PackedScene) var gemTypes
export(PackedScene) var validSpaceScene
var gemArray = []
var cols = 3
var rows = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	spawnGems(cols,rows)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for gem in get_tree().get_nodes_in_group("Gems"):
		gem.position = gem.positionOnBoard*50
		
	if Input.is_action_just_pressed("ui_accept"):
		printArray()
	pass

func spawnGems(cols, rows):
	var gemSize = 50
	var idNum = 0
	for y in range(rows):
		gemArray.append([])
		for x in range(cols):
			var tempGem = gemTypes[randi()%gemTypes.size()].instance()
			add_child(tempGem)
			tempGem.position = Vector2(y*gemSize, x*gemSize)
			gemArray[y].append(tempGem)
			tempGem.add_to_group("Gems")
			tempGem.positionOnBoard = Vector2(y, x)
			tempGem.id = idNum
			idNum += 1
			if (x < cols - 1 and y < rows - 1) and (x > 0 and y > 0):
				var validSpace = validSpaceScene.instance()
				add_child(validSpace)
				validSpace.position = Vector2(y*gemSize, x*gemSize)
				validSpace.positionOnBoard = Vector2(y, x)


func _on_SelectorSquare_clockwiseTurn(gem):
	var center = gem.positionOnBoard 
	print(center)
	gemArray[center.x][center.y].get_node("Sprite").modulate = Color("#000000")
	
	#animateGemMovementClockwise(center)
	
	var firstGem = gemArray[center.x+1][center.y+1]
	var firstPos = gemArray[center.x+1][center.y+1].positionOnBoard
	firstGem.modulate = Color("#00FF00")
	
	var posHolder = gemMoveBoardPos([center.x+1, center.y+1], [center.x, center.y+1], firstPos)
	print("pos", posHolder)
	print("fpos", firstPos)
	posHolder = gemMoveBoardPos([center.x, center.y+1], [center.x-1, center.y+1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y+1], [center.x-1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y], [center.x-1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y-1], [center.x, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x, center.y-1], [center.x+1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y-1], [center.x+1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y], [center.x+1, center.y+1], posHolder, firstGem)
	
	
	#gemArray[center.x-1][center.y+1].positionOnBoard = firstPos
	
	####
	
	
	pass # Replace with function body.

func gemMoveBoardPos(aGem, bGem, newPosition = null, altB = null):
	#gemArray[aGem[0]][aGem[1]].modulate = Color("#FF0000")
	# aGem and bGem are arrays
	# aGem is destination, bGem is source
	var pos = gemArray[bGem[0]][bGem[1]].positionOnBoard
	if altB == null:
		gemArray[aGem[0]][aGem[1]] = gemArray[bGem[0]][bGem[1]]
	else:
		gemArray[aGem[0]][aGem[1]] = altB
	gemArray[aGem[0]][aGem[1]].positionOnBoard = newPosition
	return pos

func animateGemMovementClockwise(center):
	gemArray[center.x-1][center.y].moveTo(gemArray[center.x-1][center.y-1].position)
	gemArray[center.x-1][center.y+1].moveTo(gemArray[center.x-1][center.y].position)
	gemArray[center.x][center.y+1].moveTo(gemArray[center.x-1][center.y+1].position) 
	gemArray[center.x+1][center.y+1].moveTo(gemArray[center.x][center.y+1].position) 
	gemArray[center.x+1][center.y].moveTo(gemArray[center.x+1][center.y+1].position)
	gemArray[center.x+1][center.y-1].moveTo(gemArray[center.x+1][center.y].position)
	gemArray[center.x][center.y-1].moveTo(gemArray[center.x+1][center.y-1].position)
	gemArray[center.x-1][center.y-1].moveTo(gemArray[center.x][center.y-1].position) 
	return
	
func animateGemMovementCounterClockwise(center):
	gemArray[center.x-1][center.y-1].moveTo(gemArray[center.x][center.y-1].position)
	gemArray[center.x+1][center.y-1].moveTo(gemArray[center.x][center.y-1].position)
	gemArray[center.x+1][center.y].moveTo(gemArray[center.x+1][center.y-1].position)
	gemArray[center.x+1][center.y+1].moveTo(gemArray[center.x+1][center.y].position)
	gemArray[center.x][center.y+1].moveTo(gemArray[center.x+1][center.y+1].position)
	gemArray[center.x-1][center.y+1].moveTo(gemArray[center.x][center.y+1].position)
	gemArray[center.x-1][center.y].moveTo(gemArray[center.x-1][center.y+1].position)
	return

func printArray():
	for i in gemArray:
		var row = []
		for gem in i:
			row.append(gem.positionOnBoard)
		print(row)


func _on_SelectorSquare_counterClockwiseTurn(gem):
	pass # Replace with function body.

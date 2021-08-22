extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, PackedScene) var gemTypes
export(PackedScene) var validSpaceScene
var gemArray = []
var cols = 10
var rows = 8
var matchSize = 2
var gemSize = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	spawnGems(rows, cols)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		findMatches()
	pass

func spawnGems(rows, cols):
	var idNum = 0
	for y in range(cols):
		gemArray.append([])
		for x in range(rows):
			var gem = spawnGem(x, y, idNum)
			gemArray[y].append(gem)
			idNum += 1
			if (y < cols - 1 and x < rows - 1) and (x > 0 and y > 0):
				var validSpace = validSpaceScene.instance()
				add_child(validSpace)
				validSpace.position = Vector2(y*gemSize, x*gemSize)
				validSpace.positionOnBoard = Vector2(y, x)

func spawnGem(x, y, idNum):
	var tempGem = gemTypes[randi()%gemTypes.size()].instance()
	add_child(tempGem)
	tempGem.position = Vector2(y*gemSize, x*gemSize)
	tempGem.add_to_group("Gems")
	tempGem.positionOnBoard = Vector2(y, x)
	tempGem.id = idNum
	return tempGem


func findMatches():
	var verticalMatches = findVerticalMatches()
	clearMatches(verticalMatches)
	var horizontalMatches = findHorizontalMatches()
	clearMatches(horizontalMatches)
	
func findVerticalMatches():
	var currentType = -1
	var count = 0
	var confirmedMatches = []
	var possibleMatch = []
	for x in range(cols):
		#in case there's a match at the bottom
		if count >= matchSize:
			confirmedMatches.append(possibleMatch.duplicate(true))
		count = 0
		currentType = -1
		possibleMatch.clear()
		
		for y in range(rows):
			#gemArray[x][y].modulate = Color("#00FFFF")
			#yield(get_tree().create_timer(0.25), "timeout")
			
			if currentType == gemArray[x][y].type:
				possibleMatch.append(gemArray[x][y])
				count += 1
				#gemArray[x][y].modulate = Color("#FF0000")
			else:
				if count >= matchSize:
					confirmedMatches.append(possibleMatch.duplicate(true))
				count = 0
				currentType = gemArray[x][y].type
				possibleMatch.clear()
				possibleMatch.append(gemArray[x][y])

	return confirmedMatches

func findHorizontalMatches():
	var currentType = -1
	var count = 0
	var confirmedMatches = []
	var possibleMatch = []
	for y in range(rows):
		#in case there's a match at the bottom
		if count >= matchSize:
			confirmedMatches.append(possibleMatch.duplicate(true))
		count = 0
		currentType = -1
		possibleMatch.clear()
		
		for x in range(cols):
			#gemArray[x][y].modulate = Color("#00FFFF")
			#yield(get_tree().create_timer(0.25), "timeout")
			
			if currentType == gemArray[x][y].type:
				possibleMatch.append(gemArray[x][y])
				count += 1
				#gemArray[x][y].modulate = Color("#FF0000")
			else:
				if count >= matchSize:
					confirmedMatches.append(possibleMatch.duplicate(true))
				count = 0
				currentType = gemArray[x][y].type
				possibleMatch.clear()
				possibleMatch.append(gemArray[x][y])

	return confirmedMatches

func clearMatches(matches):
	for mat in matches:
		for m in mat:
			m.hide()
			var gem = spawnGem(m.positionOnBoard.y,m.positionOnBoard.x,m.id)
			gemArray[m.positionOnBoard.x][m.positionOnBoard.y] = gem
			m.queue_free()
	return



func _on_SelectorSquare_clockwiseTurn(gem):
	var center = gem.positionOnBoard 
	#print(center)
	#gemArray[center.x][center.y].get_node("Sprite").modulate = Color("#000000")
	
	animateGemMovementClockwise(center)
	
	var firstGem = gemArray[center.x][center.y+1]
	var firstPos = gemArray[center.x][center.y+1].positionOnBoard
	#firstGem.modulate = Color("#00FF00")
	
	var posHolder = gemMoveBoardPos([center.x, center.y+1], [center.x+1, center.y+1], firstPos)
	#print("pos", posHolder)
	#print("fpos", firstPos)
	posHolder = gemMoveBoardPos([center.x+1, center.y+1], [center.x+1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y], [center.x+1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y-1], [center.x, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x, center.y-1], [center.x-1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y-1], [center.x-1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y], [center.x-1, center.y+1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y+1], [center.x, center.y+1], posHolder, firstGem)
	
	
	
	pass # Replace with function body.


func _on_SelectorSquare_counterClockwiseTurn(gem):
	var center = gem.positionOnBoard 
	#print(center)
	#gemArray[center.x][center.y].get_node("Sprite").modulate = Color("#000000")
	
	animateGemMovementCounterClockwise(center)
	
	var firstGem = gemArray[center.x+1][center.y+1]
	var firstPos = gemArray[center.x+1][center.y+1].positionOnBoard
	#firstGem.modulate = Color("#00FF00")
	
	var posHolder = gemMoveBoardPos([center.x+1, center.y+1], [center.x, center.y+1], firstPos)
	#print("pos", posHolder)
	#print("fpos", firstPos)
	posHolder = gemMoveBoardPos([center.x, center.y+1], [center.x-1, center.y+1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y+1], [center.x-1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y], [center.x-1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x-1, center.y-1], [center.x, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x, center.y-1], [center.x+1, center.y-1], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y-1], [center.x+1, center.y], posHolder)
	posHolder = gemMoveBoardPos([center.x+1, center.y], [center.x+1, center.y+1], posHolder, firstGem)
	
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
	gemArray[center.x][center.y+1].moveTo(gemArray[center.x+1][center.y+1].position)
	gemArray[center.x-1][center.y+1].moveTo(gemArray[center.x][center.y+1].position)
	gemArray[center.x-1][center.y].moveTo(gemArray[center.x-1][center.y+1].position) 
	gemArray[center.x-1][center.y-1].moveTo(gemArray[center.x-1][center.y].position) 
	gemArray[center.x][center.y-1].moveTo(gemArray[center.x-1][center.y-1].position)
	gemArray[center.x+1][center.y-1].moveTo(gemArray[center.x][center.y-1].position)
	gemArray[center.x+1][center.y].moveTo(gemArray[center.x+1][center.y-1].position)
	gemArray[center.x+1][center.y+1].moveTo(gemArray[center.x+1][center.y].position) 
	return

func printArray():
	for i in gemArray:
		var row = []
		for gem in i:
			row.append(gem.positionOnBoard)
		print(row)


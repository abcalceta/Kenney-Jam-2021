extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, PackedScene) var gemTypes
var gemArray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	spawnGems(5,10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnGems(cols, rows):
	var gemSize = 50
	for y in range(rows):
		gemArray.append([])
		for x in range(cols):
			var tempGem = gemTypes[randi()%gemTypes.size()].instance()
			add_child(tempGem)
			tempGem.position = Vector2(y*gemSize, x*gemSize)
			gemArray[y].append(tempGem)
			tempGem.add_to_group("Gems")
			tempGem.positionOnBoard = Vector2(y, x)
			if (x < cols - 1 and y < rows - 1) and (x > 0 and y > 0):
				tempGem.add_to_group("GemSelectorAreas")


func _on_SelectorSquare_clockwiseTurn(gem):
	var center = gem.positionOnBoard 
	gemArray[center.x][center.y].modulate = Color("#000000")
	
	gemArray[center.x-1][center.y].moveTo(gemArray[center.x-1][center.y-1].position)
	gemArray[center.x-1][center.y+1].moveTo(gemArray[center.x-1][center.y].position)
	gemArray[center.x][center.y+1].moveTo(gemArray[center.x-1][center.y+1].position) 
	gemArray[center.x+1][center.y+1].moveTo(gemArray[center.x][center.y+1].position) 
	gemArray[center.x+1][center.y].moveTo(gemArray[center.x+1][center.y+1].position)
	gemArray[center.x+1][center.y-1].moveTo(gemArray[center.x+1][center.y].position)
	gemArray[center.x][center.y-1].moveTo(gemArray[center.x+1][center.y-1].position)
	gemArray[center.x-1][center.y-1].moveTo(gemArray[center.x][center.y-1].position) 
	
	var firstGem = gemArray[center.x-1][center.y-1]
	var firstPos = gemArray[center.x-1][center.y-1].positionOnBoard
	gemMoveBoardPos([center.x-1, center.y-1], [center.x, center.y-1])
	gemMoveBoardPos([center.x, center.y-1], [center.x+1, center.y-1])
	gemMoveBoardPos([center.x+1, center.y-1], [center.x+1, center.y])
	gemMoveBoardPos([center.x+1, center.y], [center.x+1, center.y+1])
	gemMoveBoardPos([center.x+1, center.y+1], [center.x, center.y+1])
	gemMoveBoardPos([center.x, center.y+1], [center.x-1, center.y+1])
	gemMoveBoardPos([center.x-1, center.y+1], [center.x-1, center.y])
	#gemMoveBoardPos([center.x-1, center.y], [center.x-1, center.y-1])
	####
	gemMoveBoardPos([center.x-1, center.y], null, firstGem, firstPos)
	
	
	
	
	
	
	
	pass # Replace with function body.

func gemMoveBoardPos(aGem, bGem, lastGem = null, lastPos = null):
	#aGem and bGem are arrays
	if lastGem == null:
		gemArray[ aGem[0] ][ aGem[1] ].positionOnBoard = gemArray[ bGem[0] ][ bGem[1] ].positionOnBoard
		gemArray[aGem[0]][aGem[1]] = gemArray[bGem[0]][bGem[1]]
		return
	else:
		gemArray[ aGem[0] ][ aGem[1] ].positionOnBoard = lastPos
		gemArray[aGem[0]][aGem[1]] = lastGem
		return





func _on_SelectorSquare_counterClockwiseTurn(gem):
	pass # Replace with function body.

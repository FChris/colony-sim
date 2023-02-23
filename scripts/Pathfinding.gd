class_name Pathfinder
extends Node

var aStar = AStar2D.new()

@onready var main = get_tree().root.get_node("Main")
@onready var grid: Grid = main.get_node("Grid")

# currently no diagonal movement
# array contains directions allowed for units
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT] 

func initialize():
	addPoints()
	connectAllPoints()

func getPath(_pointA: Vector2, _pointB: Vector2):
	var aID = getPointID(_pointA)
	var bID = getPointID(_pointB)
	print(aID)
	print(bID)
	var p = aStar.get_point_path(aID, bID)
	print(p)
	return p

func addPoints():
	var curID = 0 
	for point in grid.grid:
		aStar.add_point(curID, grid.gridToWorld(point))
		curID += 1 
	
func getPointID(gridPoint: Vector2) -> int:
	return aStar.get_closest_point(grid.gridToWorld(gridPoint))
	
func getWorldID(worldPoint: Vector2) -> int:
	return aStar.get_closest_point(worldPoint)
	
func getIDWorldPos(_id: int) -> Vector2:
	return aStar.get_point_position(_id)
	
func getIDGridPos(_id: int) -> Vector2:
	return grid.worldToGrid(getIDWorldPos(_id))
	
func connectAllPoints():
	for point in grid.grid:
		connectPoint(point)

func connectPoint(_point: Vector2):
	var _pointID = getPointID(_point)
	for direction in DIRECTIONS:
		var neighbour = _point + direction
		var neighbourID = getPointID(neighbour)
		if grid.grid.has(neighbour) and grid.grid[neighbour].navigable: # change later to see if navigable
			aStar.connect_points(_pointID, neighbourID)
			print(_pointID, neighbourID)

func disconnectPoint(_point: Vector2):
	var _pointID = getPointID(_point)
	for direction in DIRECTIONS:
		var neighbour = _point + direction
		var neighbourID = getPointID(neighbour)
		aStar.disconnect_points(_pointID, neighbourID)

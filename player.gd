extends CharacterBody2D
@onready var ice_layer: TileMapLayer = get_node("../../TileMapLayer")
@export var speed = 200.0
var direction:Vector2
enum Facing {LEFT, RIGHT, UP, DOWN}
var facing_direction: Facing = Facing.DOWN
var is_blowing = false

func _physics_process(delta: float) -> void:
	var h = Input.get_axis("goLeft", "goRight")
	var v = Input.get_axis("goUp", "goDown")

	direction = Vector2.ZERO
	
	if h != 0 and h>0:
		direction.x = h
		$player_sprite.animation="walk_right"
		facing_direction = Facing.RIGHT
	elif h != 0 and h<0:
		direction.x = h
		$player_sprite.animation="walk_left"
		facing_direction = Facing.LEFT	
	elif v != 0 and v<0:
		direction.y = v
		$player_sprite.animation="walk_up"
		facing_direction = Facing.UP	
	elif v != 0 and v>0:
		direction.y = v
		$player_sprite.animation="walk_down"
		facing_direction = Facing.DOWN
	
	if h==0 and v==0:
		if facing_direction == Facing.DOWN:
			$player_sprite.animation="idle_down"
		if facing_direction == Facing.UP:
			$player_sprite.animation="idle_up"
		if facing_direction == Facing.RIGHT:
			$player_sprite.animation="idle_right"
		if facing_direction == Facing.LEFT:
			$player_sprite.animation="idle_left"

	velocity = direction * speed
	move_and_slide()	
	fireIceDown()
"""
func debugfunction():
	var blocks_container=[]
	if Input.is_action_just_pressed("debug") and facing_direction == Facing.DOWN:
		print("x=", position.x)
		print("y=", position.y)
		print("")
		for i in range(position.y, 253):
			if i % 16 ==0:
				blocks_container.append([int(position.x / 16) * 16,i])
		print(blocks_container)
		#ice_layer.set_cell(Vector2i(5,5),0, Vector2i(0,0))
		for p in blocks_container:
			var world_pos = Vector2(p[0], p[1])
			var cell = ice_layer.local_to_map(ice_layer.to_local(world_pos))
			print(cell)
			ice_layer.set_cell(cell, 0, Vector2i(0, 0))
"""	

func fireIceDown(): # still need some work
	if not Input.is_action_just_pressed("debug"):
		return

	if facing_direction != Facing.DOWN:
		return
		
	var start_cell: Vector2i = ice_layer.local_to_map(ice_layer.to_local(global_position))
	print("Player cell:", start_cell)

	# go DOWN cell by cell
	var current_cell = start_cell + Vector2i(0, 1)

	while true:
		
		if not ice_layer.get_used_rect().has_point(current_cell):
			break
		if ice_layer.get_cell_source_id(current_cell) != -1:
			break
			
		ice_layer.set_cell(current_cell, 0, Vector2i(0, 0))

		print("Placed ice at cell:", current_cell)
		
		current_cell += Vector2i(0, 1)

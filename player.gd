extends CharacterBody2D
@onready var ice_layer: TileMapLayer = get_node("../../TileMapLayer")
var iceBlock0 = preload("res://ice_block.tscn")
@export var speed = 200.0
var direction:Vector2
enum Facing {LEFT, RIGHT, UP, DOWN}
var facing_direction: Facing = Facing.DOWN
var is_blowing = false
var is_firing_ice = false
@onready var iceBlock: Sprite2D =$"../../ice_block/Sprite2D"

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
	if Input.is_action_just_pressed("fireSnow") and not is_firing_ice:
		is_firing_ice = true
		fireIceDown()
		

	
	
	


func fireIceDown(): # yes, it still need some work...
	
	if facing_direction != Facing.DOWN:
		return
		
	var start_cell: Vector2i = ice_layer.local_to_map(ice_layer.to_local(global_position))
	print("Player cell:", start_cell)

	# go DOWN cell by cell
	var current_cell = start_cell + Vector2i(0, 2)
	while true:
		
		if not ice_layer.get_used_rect().has_point(current_cell):
			break
		if ice_layer.get_cell_source_id(current_cell) != -1:
			break
		$player_sprite.animation="blowing_down"
		var fakeIce = iceBlock0.instantiate()
		var world_pos = ice_layer.map_to_local(current_cell)
		fakeIce.global_position = ice_layer.to_global(world_pos)
		get_tree().current_scene.add_child(fakeIce)
		#ice_layer.set_cell(current_cell, 0, Vector2i(0, 0))
		
		print("Placed ice at cell:", current_cell)
		await get_tree().create_timer(0.1).timeout
		current_cell += Vector2i(0, 1)
	is_firing_ice = false


func lop():
	for i in range(10):
		print(i)
		await get_tree().create_timer(1).timeout

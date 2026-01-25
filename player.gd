extends CharacterBody2D
@onready var ice_layer: TileMapLayer = get_node("../../TileMapLayer")
var iceBlock0 = preload("res://ice_block.tscn")
@export var speed = 200.0
var direction: Vector2
enum Facing { LEFT, RIGHT, UP, DOWN }
var facing_direction: Facing = Facing.DOWN
enum PlayerState { IDLE, MOVE, BLOW }
var state: PlayerState = PlayerState.IDLE
var is_firing_ice := false  

func _physics_process(delta: float) -> void:
	var h = Input.get_axis("goLeft", "goRight")
	var v = Input.get_axis("goUp", "goDown")


	if Input.is_action_just_pressed("fireSnow") and state != PlayerState.BLOW:
		state = PlayerState.BLOW                    
		is_firing_ice = true                       
		fireIceDown()                              
		update_animation()                         
		return                                    
		
	if state == PlayerState.BLOW:
		velocity = Vector2.ZERO
		move_and_slide()
		return                                   
		
	direction = Vector2.ZERO

	if h > 0:
		direction.x = h
		facing_direction = Facing.RIGHT
		state = PlayerState.MOVE                   
	elif h < 0:
		direction.x = h
		facing_direction = Facing.LEFT
		state = PlayerState.MOVE                   
	elif v < 0:
		direction.y = v
		facing_direction = Facing.UP
		state = PlayerState.MOVE                  
	elif v > 0:
		direction.y = v
		facing_direction = Facing.DOWN
		state = PlayerState.MOVE                   
	else:
		state = PlayerState.IDLE                   

	velocity = direction * speed
	move_and_slide()
	update_animation()                             
	
#animations depend on state 	
func update_animation():  
	match state:
		PlayerState.IDLE:
			match facing_direction:
				Facing.DOWN:  $player_sprite.play("idle_down")   
				Facing.UP:    $player_sprite.play("idle_up")     
				Facing.LEFT:  $player_sprite.play("idle_left")   
				Facing.RIGHT: $player_sprite.play("idle_right")  

		PlayerState.MOVE:
			match facing_direction:
				Facing.DOWN:  $player_sprite.play("walk_down")   
				Facing.UP:    $player_sprite.play("walk_up")     
				Facing.LEFT:  $player_sprite.play("walk_left")   
				Facing.RIGHT: $player_sprite.play("walk_right")  

		PlayerState.BLOW:
				$player_sprite.play("blowing_down")                 


func fireIceDown():  
	if facing_direction != Facing.DOWN:
		state = PlayerState.IDLE                  
		return

	var start_cell: Vector2i = ice_layer.local_to_map(ice_layer.to_local(global_position))

	var current_cell = start_cell + Vector2i(0, 2)

	while true:
		if not ice_layer.get_used_rect().has_point(current_cell):
			break
		if ice_layer.get_cell_source_id(current_cell) != -1:
			break

		var fakeIce = iceBlock0.instantiate()
		var world_pos = ice_layer.map_to_local(current_cell)
		fakeIce.global_position = ice_layer.to_global(world_pos)
		get_tree().current_scene.add_child(fakeIce)

		await get_tree().create_timer(0.1).timeout
		current_cell += Vector2i(0, 1)

	is_firing_ice = false
	state = PlayerState.IDLE                      
	update_animation()                            
	
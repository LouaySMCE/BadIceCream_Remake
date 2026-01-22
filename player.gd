extends CharacterBody2D

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
	debugshit()
	
func debugshit():
	if Input.is_action_just_pressed("debug") and facing_direction == Facing.DOWN:
		print("x=", position.x)
		print("y=", position.y)
		print("")
		for i in range(position.y, 253):
			if i % 16 ==0:
				print(i)
				

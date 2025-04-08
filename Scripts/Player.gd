extends CharacterBody2D

@export var gravity = 200
@export var jump_height = -100
@export var speed = 100

var attacking = false
var climbing = false

# input actions
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_attack"):
		attacking = true
		$AnimatedSprite2D.play("attack")
		
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
	
	if climbing:
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			velocity.y = -200
		else:
			gravity = 200
			climbing = false
		
# movement and physics
func _physics_process(delta):
	velocity.y += gravity * delta
	walk()
	
	move_and_slide()

	if !(attacking || climbing):	
		animate_movement()

func animate_movement():
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
		
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
		
	if Input.is_anything_pressed():
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
func walk():
	var walk_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = walk_direction * speed

func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
	climbing = false

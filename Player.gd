extends KinematicBody2D


class_name Player

export(int) var WALK_SPEED = 350

var linear_vel = Vector2()

export(String, "left", "right") var facing = "right"

var anim = ""
var new_anim = ""

enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING }

var state = STATE_IDLE

var body_state_machine
var sword_state_machine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	body_state_machine = $body_anim_tree.get("parameters/playback")
	sword_state_machine = $sword_anim_tree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	match state:
		STATE_BLOCKED:
			new_anim = "idle_" + facing
			pass
		STATE_IDLE:
			if (
				Input.is_action_pressed("move_down") or
				Input.is_action_pressed("move_left") or
				Input.is_action_pressed("move_right") or
				Input.is_action_pressed("move_up")
			):
				state = STATE_WALKING
			new_anim = "idle_" + facing
			pass
		STATE_WALKING:
			linear_vel = move_and_slide(linear_vel)
			
			var target_speed = Vector2()
			
			if Input.is_action_pressed("move_down"):
				target_speed += Vector2.DOWN
			if Input.is_action_pressed("move_left"):
				target_speed += Vector2.LEFT
			if Input.is_action_pressed("move_right"):
				target_speed += Vector2.RIGHT
			if Input.is_action_pressed("move_up"):
				target_speed += Vector2.UP
			
			target_speed *= WALK_SPEED
			linear_vel = target_speed
			
			_update_facing()
			
			if linear_vel.length() > 5:
				new_anim = "walk_" + facing
			else:
				goto_idle()
			pass
			
	if new_anim != anim:
		anim = new_anim
		body_state_machine.travel(anim)
	
	if (
		Input.is_action_just_pressed("attack")
	):
		sword_state_machine.travel("swing")
		$AnimatedSprite/sword/player_sword_area/sword_shape.disabled = false
	
	if not sword_state_machine.get_current_node() != "swing":
		$AnimatedSprite/sword/player_sword_area/sword_shape.disabled = true

func goto_idle():
	linear_vel = Vector2.ZERO
	new_anim = "idle_" + facing
	state = STATE_IDLE

func _update_facing():
	if Input.is_action_pressed("move_left"):
		facing = "left"
	if Input.is_action_pressed("move_right"):
		facing = "right"

extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int) var hitpoints = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hurtbox_area_entered(area):
	if area.name == "player_sword_area":
		print(area.name)
		hitpoints -= 1
		if hitpoints <= 0:
			despawn()

func despawn():
	queue_free()

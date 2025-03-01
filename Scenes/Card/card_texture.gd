extends Sprite2D

var dragging = false
var diff = Vector2.ZERO

@onready var card: Card = $".."

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			dragging = true
			card.is_held = true
			diff = get_global_mouse_position() - get_parent().global_position
		elif not event.pressed:
			dragging = false
			card.is_held = false

	if event is InputEventMouseMotion and dragging:
		get_parent().global_position = get_global_mouse_position() - diff

extends Node2D
class_name Game

@export var card_scene: PackedScene

@onready var card_holder: CardHolder = $CardHolder


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_card"):
		var card = card_scene.instantiate()
	
		card.set_value('hearts', 'K')
		
		card_holder.card = card

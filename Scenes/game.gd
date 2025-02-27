extends Node2D
class_name Game

@export var card_scene: PackedScene

@onready var card_holder: CardHolder = $CardHolder

func _ready() -> void:
	var card: Card = card_scene.instantiate()
	card_holder.set_card(card)
	
	card.set_value('hearts', 'J')

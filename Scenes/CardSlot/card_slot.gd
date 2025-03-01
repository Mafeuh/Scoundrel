extends Node2D
class_name CardSlot

var card: Card
@export var button_hidden = false


func set_card(card: Card):
	self.card = card
	card.holder = self


func remove_card() -> Card:
	var _card = self.card
	
	self.card = null
	for child in get_children().filter(func(child): return child is Card):
		remove_child(child)
	
	return _card


func has_card() -> bool:
	return card != null

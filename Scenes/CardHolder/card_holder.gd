extends Node2D
class_name CardHolder

var card: Card

func set_card(card: Card):
	self.card = card
	for i in range(get_children().size()):
		remove_child(get_children()[i])
	add_child(card)
	card.holder = self

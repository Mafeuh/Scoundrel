extends Node2D
class_name CardHolder


var card: Card:
	get:
		return card
	set(value):
		remove_child(card)
		card = value
		value.holder = self
		add_child(value)


func remove_card():
	self.card.holder = null
	self.card = null

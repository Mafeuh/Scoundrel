extends Node2D
class_name ButtonCardSlot

@onready var card_slot: CardSlot = $CardSlot
@onready var button: Button = $Button

signal card_used(slot: ButtonCardSlot, card: Card)


func get_card() -> Card:
	return card_slot.card


func remove_card() -> Card:
	return card_slot.remove_card()


func set_card(card: Card):
	card_slot.set_card(card)


func _on_button_pressed() -> void:
	card_used.emit(self, get_card())


func has_card() -> bool:
	return card_slot.card != null

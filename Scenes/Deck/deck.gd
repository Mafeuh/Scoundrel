extends Node2D
class_name Deck

@export var card_texture: Texture2D
@export var cards_count: int = 5
@export var offset: Vector2 = Vector2(0, 6)

const CARD_SCENE = preload("res://Scenes/Card/Card.tscn")

var remaining_cards = [
	'hearts:2', 'hearts:3', 'hearts:4', 'hearts:5', 'hearts:6', 'hearts:7', 'hearts:8', 'hearts:9', 'hearts:10', # 'hearts:J', 'hearts:Q', 'hearts:K', 'hearts:A',
	'clubs:A', 'clubs:2', 'clubs:3', 'clubs:4', 'clubs:5', 'clubs:6', 'clubs:7', 'clubs:8', 'clubs:9', 'clubs:10', 'clubs:J', 'clubs:Q', 'clubs:K',
	'diamonds:A', 'diamonds:2', 'diamonds:3', 'diamonds:4', 'diamonds:5', 'diamonds:6', 'diamonds:7', 'diamonds:8', 'diamonds:9', 'diamonds:10', 'diamonds:J', 'diamonds:Q', 'diamonds:K',
	'spades:A', 'spades:2', 'spades:3', 'spades:4', 'spades:5', 'spades:6', 'spades:7', 'spades:8', 'spades:9', 'spades:10', 'spades:J', 'spades:Q', 'spades:K',
]

var total_cards: int = remaining_cards.size()


func pick_card() -> String:
	if remaining_cards.size() > 0:
		var card = remaining_cards.pick_random()
		remaining_cards.pop_at(remaining_cards.find(card))
		return card
	else:
		return ":"


func send_card_to_holder(holder: CardSlot) -> Card:
	var card_values = pick_card().split(':')
	var color = card_values[0]
	var value = card_values[1]
	
	var card: Card = CARD_SCENE.instantiate()
	
	card.set_value(color, value)
	card.holder = holder
	holder.card = card
		
	return card

func _ready() -> void:
	for i in range(cards_count):
		var card = Sprite2D.new()
		card.texture = card_texture
		card.position = Vector2(0, - i * offset.y)
		add_child(card)

extends Node2D
class_name Deck

@export var card_texture: Texture2D
@export var cards_count: int = 5
@export var offset: Vector2 = Vector2(0, 6)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const CARD_SCENE = preload("res://Scenes/Card/Card.tscn")

var DECKS: Dictionary = {
	'normal': {
		'name': 'Normal',
		'cards': [
			'hearts:2', 'hearts:3', 'hearts:4', 'hearts:5', 'hearts:6', 'hearts:7', 'hearts:8', 'hearts:9', 'hearts:10', # 'hearts:J', 'hearts:Q', 'hearts:K', 'hearts:A',
			'clubs:A', 'clubs:2', 'clubs:3', 'clubs:4', 'clubs:5', 'clubs:6', 'clubs:7', 'clubs:8', 'clubs:9', 'clubs:10', 'clubs:J', 'clubs:Q', 'clubs:K',
			'diamonds:A', 'diamonds:2', 'diamonds:3', 'diamonds:4', 'diamonds:5', 'diamonds:6', 'diamonds:7', 'diamonds:8', 'diamonds:9', 'diamonds:10', 'diamonds:J', 'diamonds:Q', 'diamonds:K',
			'spades:A', 'spades:2', 'spades:3', 'spades:4', 'spades:5', 'spades:6', 'spades:7', 'spades:8', 'spades:9', 'spades:10', 'spades:J', 'spades:Q', 'spades:K',
		]
	}
}

var remaining_cards = []

var total_cards: int


func pick_card() -> Card:
	if remaining_cards.size() > 0:
		var card_values = remaining_cards.pop_at(0)
		
		var card_instance = CARD_SCENE.instantiate()
		
		var split = card_values.split(':')
		card_instance.set_value(split[0], split[1])
		
		return card_instance
	else:
		return null


func setup_deck(deck_name: String):
	if deck_name not in DECKS.keys():
		deck_name = 'normal'
	remaining_cards = DECKS.get(deck_name).get('cards')
	total_cards = remaining_cards.size()
	shuffle(rng)


func send_card_to_holder(holder: CardSlot) -> Card:
	var card: Card = pick_card()
	
	if card:
		card.holder = holder
		holder.card = card
			
		return card
	else:
		return null


func _init() -> void:
	setup_deck('normal')


func set_rng(rng: RandomNumberGenerator):
	self.rng = rng


func _ready() -> void:
	for i in range(cards_count):
		var card = Sprite2D.new()
		card.texture = card_texture
		card.position = Vector2(0, - i * offset.y)
		add_child(card)


func shuffle(rng: RandomNumberGenerator):
	if rng == null:
		rng = RandomNumberGenerator.new()
	var n = remaining_cards.size()
	# Algorithme de Fisher-Yates
	for i in range(n - 1, 0,-1):
		var j = rng.randi_range(0, i)
		var tmp = remaining_cards[i]
		remaining_cards[i] = remaining_cards[j]
		remaining_cards[j] = tmp

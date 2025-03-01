extends Node2D
class_name Game

@export var card_scene: PackedScene

@onready var deck: Deck = $Deck
@onready var health_label: Label = $HealthLabel
@onready var weapon_area: Node2D = $WeaponArea

@onready var drawing_slot: ButtonCardSlot = $DrawingSlots/DrawingSlot
@onready var drawing_slot_2: ButtonCardSlot = $DrawingSlots/DrawingSlot2
@onready var drawing_slot_3: ButtonCardSlot = $DrawingSlots/DrawingSlot3
@onready var drawing_slot_4: ButtonCardSlot = $DrawingSlots/DrawingSlot4
@onready var cards: Node2D = $Cards
@onready var bin: Node2D = $Bin

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var weapon_slots: Array[CardSlot] = []


var drawing_slots: Array[ButtonCardSlot] = []

@export var base_health: int = 20

var health: int:
	get():
		return health
	set(value):
		health = value
		health_label.text = str("Vie: ", health, ' / ', base_health)


func new_weapon(new_weapon: Card):
	if weapon_slots.size() > 0:
		cards.remove_child(get_weapon_slot().remove_card())
	
	weapon_slots.clear()
	for child: CardSlot in weapon_area.get_children():
		trash_card(child.card)
		weapon_area.remove_child(child)
	
	var new_slot = CardSlot.new()
	weapon_slots.append(new_slot)
	weapon_area.add_child(new_slot)
	
	get_weapon_slot().set_card(new_weapon)
	var next_slot = CardSlot.new()
	next_slot.position = get_weapon_slot().position + Vector2(70, 10)
	weapon_slots.append(next_slot)
	weapon_area.add_child(next_slot)
	

func _ready() -> void:
	health = base_health
	
	drawing_slots.append_array([
		drawing_slot, drawing_slot_2, drawing_slot_3, drawing_slot_4
	])


func start_game() -> void:
	deck = Deck.new()
	
	health = base_health
	
	for card in cards.get_children():
		cards.remove_child(card)
	
	for slot in drawing_slots:
		var card: Card = deck.send_card_to_holder(slot.card_slot)
		cards.add_child(card)
		card.flip()
		card.update_scene()


func use_card_from_slot_index(index: int):
	var slot = drawing_slots[index]
	if slot.has_card():
		var used_card = drawing_slots[index].remove_card()
		use_card(used_card)


func switch_cards(slot1: CardSlot, slot2: CardSlot):
	var tmp: Card = slot1.remove_card()
	slot1.set_card(slot2.remove_card())
	slot2.set_card(tmp)


func use_card(card: Card):
	card.move_to_front()
	
	if card.color == 'diamonds':
		new_weapon(card)
	
	if card.color in ['spades', 'clubs']:
		var true_card_value: int = card.get_true_value()
		var damage_taken: int 
		if card.get_true_value() < get_last_enemy_value():
			damage_taken = max(0, true_card_value - get_weapon_strength())
		else:
			damage_taken = true_card_value
		health = max(0, health - damage_taken)
		
		var weapon_slot = weapon_slots[0]
		if weapon_slot.has_card() and card.get_true_value() < get_last_enemy_value():
			add_card_to_weapon_queue(card)
		else:
			cards.remove_child(card)
	
	if card.color == 'hearts':
		var true_card_value: int = card.get_true_value()
		health = min(base_health, health + true_card_value)
		cards.remove_child(card)
	
	if drawing_slots.filter(func(slot): return slot.has_card()).size() == 1:
		refill()


func add_card_to_weapon_queue(card: Card):
	var slot = weapon_slots[weapon_slots.size() - 1]
	slot.set_card(card)
	card.holder = slot
	
	var next_slot = CardSlot.new()
	next_slot.position = slot.position + Vector2(10, 10)
	weapon_slots.append(next_slot)
	weapon_area.add_child(next_slot)


func refill():
	for slot in drawing_slots:
		if not slot.has_card():
			var card = deck.send_card_to_holder(slot.card_slot)
			cards.add_child(card)
			card.flip()
			card.update_scene()


func get_weapon_strength() -> int:
	if get_weapon_slot().card == null:
		return 0
	else:
		return get_weapon_slot().card.get_true_value()


func get_last_enemy_value() -> int:
	if weapon_slots.size() - 1 <= 1:
		return 15
	else:
		return weapon_slots[weapon_slots.size() - 2].card.get_true_value()


func _on_start_game_pressed() -> void:
	start_game()


func _on_drawing_slot_card_used(slot: ButtonCardSlot, card: Card) -> void:
	use_card_from_slot_index(0)


func _on_drawing_slot_2_card_used(slot: ButtonCardSlot, card: Card) -> void:
	use_card_from_slot_index(1)


func _on_drawing_slot_3_card_used(slot: ButtonCardSlot, card: Card) -> void:
	use_card_from_slot_index(2)


func _on_drawing_slot_4_card_used(slot: ButtonCardSlot, card: Card) -> void:
	use_card_from_slot_index(3)


func get_weapon_slot():
	return weapon_slots[0] if weapon_slots.size() > 0 else null


func trash_card(card: Card):
	if card != null:
		card.unflip()
		var slot = CardSlot.new()
		bin.add_child(slot)
		slot.position.x = rng.randi_range(-10, 10)
		slot.position.y = rng.randi_range(-10, 10)
		card.holder = slot
		slot.set_card(card)

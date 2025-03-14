extends Node2D
class_name Game

@export var card_scene: PackedScene
@export var deck_scene: PackedScene
@onready var message: Label = $Message
@onready var nb_cartes: Label = $Remaining/NBCartes
@onready var confrontation: Node2D = $Confrontation

@onready var deck: Deck = $Deck
@onready var health_label: Label = $HealthLabel
@onready var back_to_deck_slot: CardSlot = $Deck/BackToDeckSlot
@onready var run_away_button: Button = $RunAway

@onready var seed_input: SpinBox = $SeedArea/HBoxContainer/SeedInput

@onready var drawing_slot: ButtonCardSlot = $DrawingSlots/DrawingSlot
@onready var drawing_slot_2: ButtonCardSlot = $DrawingSlots/DrawingSlot2
@onready var drawing_slot_3: ButtonCardSlot = $DrawingSlots/DrawingSlot3
@onready var drawing_slot_4: ButtonCardSlot = $DrawingSlots/DrawingSlot4
@onready var cards: Node2D = $Cards
@onready var bin: Node2D = $Bin

@onready var rules_area: Control = $RulesArea
@onready var intro: Control = $RulesArea/ColorRect/Intro
@onready var colors: Control = $RulesArea/ColorRect/Colors

var show_rules: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_rules"):
		show_rules = !show_rules
		
		if show_rules:
			rules_area.show()
			colors.hide()
			intro.show()
		else:
			rules_area.hide()


var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var used_cards_amount: int

var drawing_slots: Array[ButtonCardSlot] = []

@export var base_health: int = 20

var health: int:
	get():
		return health
	set(value):
		health = value
		health_label.text = str("Vie: ", health, ' / ', base_health)	
	

func _ready() -> void:
	health = base_health
	
	drawing_slots.append_array([
		drawing_slot, drawing_slot_2, drawing_slot_3, drawing_slot_4
	])


func start_game() -> void:
	lock_run_away()
	lock_slots()
	
	message.text = ''
	
	deck = deck_scene.instantiate()
	rng = RandomNumberGenerator.new()
	deck.set_rng(self.rng)
	
	health = base_health
		
	for card in cards.get_children():
		cards.remove_child(card)
	
	for slot in drawing_slots:
		slot.remove_card()
	
	used_cards_amount = 0
	nb_cartes.text = str(deck.total_cards - used_cards_amount, ' / ', deck.total_cards)

	refill()
	unlock_run_away()


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
	used_cards_amount += 1
	nb_cartes.text = str(deck.total_cards - used_cards_amount, ' / ', deck.total_cards)
	card.move_to_front()
	
	if card.color == 'diamonds':
		new_weapon(card)
	
	if card.color in ['spades', 'clubs']:
		var result = await confrontation.fight_enemy(card)
		health = max(0, health - result)
	
	if card.color == 'hearts':
		var true_card_value: int = card.get_true_value()
		health = min(base_health, health + true_card_value)
		trash_card(card)
	
	if health == 0:
		lose()
	
	if drawing_slots.filter(func(slot): return slot.has_card()).size() == 0:
		win()
	
	if drawing_slots.filter(func(slot): return slot.has_card()).size() == 1:
		refill()
		unlock_run_away()


func refill():
	lock_slots()
	for slot in drawing_slots:
		if not slot.has_card():
			var card = deck.send_card_to_holder(slot.card_slot)
			if card:
				cards.add_child(card)
				card.flip()
				card.update_scene()
				
				await get_tree().create_timer(0.2).timeout
	unlock_slots()


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


func lock_slots():
	for slot in drawing_slots:
		slot.button.disabled = true


func unlock_slots():
	for slot in drawing_slots:
		slot.button.disabled = false


func trash_card(card: Card):
	if card != null:
		card.holder.card = null
		card.unflip()
		var slot = CardSlot.new()
		bin.add_child(slot)
		slot.position.x = rng.randi_range(-10, 10)
		slot.position.y = rng.randi_range(-10, 10)
		card.holder = slot
		slot.set_card(card)


func run_away():
	lock_slots()
	lock_run_away()
	var cards: Array[Card] = []
	for slot in drawing_slots:
		cards.append(slot.remove_card())
	
	cards.shuffle()
	for card in cards:
		if card != null:
			card.unflip()
			await get_tree().create_timer(0.2).timeout
			card.holder = back_to_deck_slot
			await get_tree().create_timer(0.2).timeout
			self.cards.remove_child(card)
	
	cards.shuffle()
	for card in cards:
		if card:
			deck.remaining_cards.append(card.get_values())
	refill()


func lock_run_away():
	self.run_away_button.disabled = true


func unlock_run_away():
	self.run_away_button.disabled = false


func _on_run_away_pressed() -> void:
	run_away()


func win():
	lock_slots()
	lock_run_away()
	message.text = "BRavo! c'erst gagneé!!!!"

func lose():
	lock_slots()
	lock_run_away()
	message.text = "Trrop nul cest rater 😁"


func _on_page_2_pressed() -> void:
	intro.hide()
	colors.show()


func _on_page_1_pressed() -> void:
	intro.show()
	colors.hide()


func new_weapon(card: Card):
	trash_card(confrontation.get_weapon())
	
	var slayed_enemies = confrontation.get_slayed_enemies()
	
	for enemy in slayed_enemies:
		trash_card(enemy)
		await get_tree().create_timer(0.1).timeout
		
	confrontation.new_weapon(card)


func _on_confrontation_card_trashed(card: Card) -> void:
	trash_card(card)


func _on_confrontation_fight_started() -> void:
	lock_slots()
	lock_run_away()


func _on_confrontation_fight_ended() -> void:
	unlock_slots()
	unlock_run_away()

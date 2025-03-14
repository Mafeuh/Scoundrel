extends Node2D
class_name Confrontation

signal weapon_changed
signal card_trashed(card: Card)
signal fight_started
signal fight_ended

@onready var weapon_slot: CardSlot = $WeaponPanel/Weapon
@onready var enemy_slot: CardSlot = $EnemyPanel/Enemy
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_defence: Label = $WeaponPanel/WeaponDefence
@onready var enemy_attack: Label = $EnemyPanel/EnemyAttack
@onready var attack_result: Label = $AttackResult
@onready var slayed_enemies: Panel = $SlayedEnemies

@export var CARD_SLOT_SCENE: PackedScene

var slayed_slots: Array[CardSlot] = []

func has_weapon() -> bool:
	return weapon_slot.has_card()


func get_slayed_enemies() -> Array:
	return slayed_slots.map(func(slot): return slot.card)


func clean_slots():
	for slot in slayed_slots:
		slayed_enemies.remove_child(slot)
	slayed_slots.clear()

func get_slayed_slots() -> Array[CardSlot]:
	return slayed_slots


func new_weapon(weapon: Card):
	weapon_slot.card = weapon
	weapon.holder = weapon_slot
	weapon_defence.text = str(weapon.get_true_value())
	
	clean_slots()


func fight_enemy(enemy: Card) -> int:
	fight_started.emit()
	enemy_attack.text = str(enemy.get_true_value())
	enemy_slot.card = enemy
	enemy.holder = enemy_slot
	
	# Determine damage taken
	var enemy_value = enemy.get_true_value()
	
	var damage_taken = 0
	
	if has_weapon():
		# We have a weapon
		if enemy_value < get_last_enemy_value() or get_last_enemy_value() == -1:
			# Weapon can be used
			damage_taken = max(0, enemy_value - get_weapon().get_true_value())
			attack_result.text = str('- ', damage_taken, ' HP')
			
			animation_player.play("fight_with_weapon")
		else:
			# Weapon cannot be used, enemy too powerful
			damage_taken = enemy_value
			attack_result.text = str('- ', damage_taken, ' HP')

			animation_player.play("cancel_weapon")
	else:
		damage_taken = enemy_value
		attack_result.text = str('-', damage_taken, ' HP')
		animation_player.play("fight_without_weapon")
	return damage_taken


func get_weapon() -> Card:
	return weapon_slot.card


func get_last_enemy_value() -> int:
	if slayed_slots.size() > 1:
		return slayed_slots[slayed_slots.size() - 1].card.get_true_value()
	else:
		return -1


func store_enemy(card: Card):
	var slot = CardSlot.new()
	slayed_enemies.add_child(slot)
	slot.position.x = 65 + 10 * slayed_slots.size()
	slot.position.y = 85
	card.holder = slot
	slot.set_card(card)
	slayed_slots.append(slot)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fight_with_weapon':
		store_enemy(enemy_slot.remove_card())
		animation_player.play('RESET')
		fight_ended.emit()
	if anim_name == 'fight_without_weapon':
		animation_player.play('RESET')
		fight_ended.emit()
		card_trashed.emit(enemy_slot.remove_card())
	if anim_name == 'cancel_weapon':
		card_trashed.emit(enemy_slot.remove_card())
		animation_player.play('RESET')
		fight_ended.emit()

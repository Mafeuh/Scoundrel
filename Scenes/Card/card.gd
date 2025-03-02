extends Node2D
class_name Card

const COLOR_TEXTURES: Dictionary = {
	'hearts': 	preload('res://Assets/Textures/Cards/Colors/Hearts.png'),
	'spades': 	preload("res://Assets/Textures/Cards/Colors/Spades.png"),
	'clubs': 	preload("res://Assets/Textures/Cards/Colors/Clubs.png"),
	'diamonds': preload("res://Assets/Textures/Cards/Colors/Diamonds.png")
}


const VALUE_TEXTURES: Dictionary = {
	'A': 	preload("res://Assets/Textures/Cards/Numbers/Ace.png"),
	'2': 	preload("res://Assets/Textures/Cards/Numbers/2.png"),
	'3': 	preload("res://Assets/Textures/Cards/Numbers/3.png"),
	'4': 	preload("res://Assets/Textures/Cards/Numbers/4.png"),
	'5': 	preload("res://Assets/Textures/Cards/Numbers/5.png"),
	'6': 	preload("res://Assets/Textures/Cards/Numbers/6.png"),
	'7': 	preload("res://Assets/Textures/Cards/Numbers/7.png"),
	'8': 	preload("res://Assets/Textures/Cards/Numbers/8.png"),
	'9': 	preload("res://Assets/Textures/Cards/Numbers/9.png"),
	'10': 	preload("res://Assets/Textures/Cards/Numbers/10.png"),
	'J': 	preload("res://Assets/Textures/Cards/Numbers/J.png"),
	'Q': 	preload("res://Assets/Textures/Cards/Numbers/Q.png"),
	'K': 	preload("res://Assets/Textures/Cards/Numbers/K.png")
}

const TRUE_VALUES: Dictionary = {
	'A': 14, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10, 'J': 11, 'Q': 12, 'K': 13
}

const FLIP_SOUND = preload("res://Assets/Audio/SFX/card_flip.wav")

const CARD_MOVEMENT_SPEED: int = 10

@onready var card_texture: Sprite2D = $CardTexture
@onready var hitbox: Control = $CardTexture/Hitbox
@onready var color_texture: TextureRect = $CardTexture/Control/Color
@onready var value_texture: TextureRect = $CardTexture/Control/Value
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flip_card_sound: AudioStreamPlayer = $AudioStreamPlayer


var color: String
var value: String

var holder: CardSlot

var velocity = Vector2.ZERO

var is_held: bool = false


func _ready() -> void:
	flip_card_sound = AudioStreamPlayer.new()
	flip_card_sound.stream = FLIP_SOUND
	update_scene()


func set_value(color: String, value: String):
	self.color = color
	self.value = value


func _process(delta: float) -> void:
	if not is_held:
		var distance_to_holder = sqrt((holder.global_position.x - global_position.x)**2 + (holder.global_position.y - global_position.y)**2)
		
		velocity /= 1.5
		velocity += Vector2(cos(get_angle_to(holder.global_position)) * distance_to_holder / 25, sin(get_angle_to(holder.global_position)) * distance_to_holder / 50)
		position += velocity


func update_scene():
	if color in COLOR_TEXTURES.keys():
		self.color_texture.texture = COLOR_TEXTURES.get(color)
	if value in VALUE_TEXTURES.keys():
		self.value_texture.texture = VALUE_TEXTURES.get(value)


func get_true_value() -> int:
	return TRUE_VALUES.get(value)


func get_values():
	return str(color, ':', value)


func flip():
	animation_player.play('card_flip')
	flip_card_sound.play()


func unflip():
	animation_player.play('card_unflip')
	flip_card_sound.play()

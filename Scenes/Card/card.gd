extends Node2D
class_name Card

const CARDS_TEXTURES: Dictionary = {
	'hearts': {
		'2': preload("res://Assets/Textures/Cards/h2.png"),
		'3': preload("res://Assets/Textures/Cards/h3.png"),
		'4': preload("res://Assets/Textures/Cards/h4.png"),
		'5': preload("res://Assets/Textures/Cards/h5.png"),
		'6': preload("res://Assets/Textures/Cards/h6.png"),
		'7': preload("res://Assets/Textures/Cards/h7.png"),
		'8': preload("res://Assets/Textures/Cards/h8.png"),
		'9': preload("res://Assets/Textures/Cards/h9.png"),
		'10': preload("res://Assets/Textures/Cards/h10.png"),
		'J': preload("res://Assets/Textures/Cards/hJ.png"),
		'Q': preload("res://Assets/Textures/Cards/hQ.png"),
		'K': preload("res://Assets/Textures/Cards/hK.png"),
	},
	'spades': {
		'2': preload("res://Assets/Textures/Cards/s2.png"),
		'3': preload("res://Assets/Textures/Cards/s3.png"),
		'4': preload("res://Assets/Textures/Cards/s4.png"),
		'5': preload("res://Assets/Textures/Cards/s5.png"),
		'6': preload("res://Assets/Textures/Cards/s6.png"),
		'7': preload("res://Assets/Textures/Cards/s7.png"),
		'8': preload("res://Assets/Textures/Cards/s8.png"),
		'9': preload("res://Assets/Textures/Cards/s9.png"),
		'10': preload("res://Assets/Textures/Cards/s10.png"),
		'J': preload("res://Assets/Textures/Cards/sJ.png"),
		'Q': preload("res://Assets/Textures/Cards/sQ.png"),
		'K': preload("res://Assets/Textures/Cards/sK.png"),		
	},
	'diamond': {
		'2': preload("res://Assets/Textures/Cards/d2.png"),
		'3': preload("res://Assets/Textures/Cards/d3.png"),
		'4': preload("res://Assets/Textures/Cards/d4.png"),
		'5': preload("res://Assets/Textures/Cards/d5.png"),
		'6': preload("res://Assets/Textures/Cards/d6.png"),
		'7': preload("res://Assets/Textures/Cards/d7.png"),
		'8': preload("res://Assets/Textures/Cards/d8.png"),
		'9': preload("res://Assets/Textures/Cards/d9.png"),
		'10': preload("res://Assets/Textures/Cards/d10.png"),
		'J': preload("res://Assets/Textures/Cards/dJ.png"),
		'Q': preload("res://Assets/Textures/Cards/dQ.png"),
		'K': preload("res://Assets/Textures/Cards/dK.png"),
	},
	'club': {
		'2': preload("res://Assets/Textures/Cards/c2.png"),
		'3': preload("res://Assets/Textures/Cards/c3.png"),
		'4': preload("res://Assets/Textures/Cards/c4.png"),
		'5': preload("res://Assets/Textures/Cards/c5.png"),
		'6': preload("res://Assets/Textures/Cards/c6.png"),
		'7': preload("res://Assets/Textures/Cards/c7.png"),
		'8': preload("res://Assets/Textures/Cards/c8.png"),
		'9': preload("res://Assets/Textures/Cards/c9.png"),
		'10': preload("res://Assets/Textures/Cards/c10.png"),
		'J': preload("res://Assets/Textures/Cards/cJ.png"),
		'Q': preload("res://Assets/Textures/Cards/cQ.png"),
		'K': preload("res://Assets/Textures/Cards/cK.png"),		
	}
}

@onready var card_texture: Sprite2D = $CardTexture

var color: String
var value: String

var holder: CardHolder

func set_value(color: String, value: String):
	self.color = color
	self.value = value
	
	# card_texture.texture = CARDS_TEXTURES.get(color).get(value)

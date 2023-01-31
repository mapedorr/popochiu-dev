extends "res://addons/Popochiu/Engine/Interfaces/ICharacter.gd"

# classes ----
const PCGoddiu := preload('res://popochiu/Characters/Goddiu/CharacterGoddiu.gd')
const PCPopsy := preload('res://popochiu/Characters/Popsy/CharacterPopsy.gd')
const PCPaco := preload('res://popochiu/Characters/Paco/CharacterPaco.gd')
# ---- classes

# nodes ----
var Goddiu: PCGoddiu setget , get_Goddiu
var Popsy: PCPopsy setget , get_Popsy
var Paco: PCPaco setget , get_Paco
# ---- nodes

# functions ----
func get_Goddiu(): return .get_runtime_character('Goddiu')
func get_Popsy(): return .get_runtime_character('Popsy')
func get_Paco(): return .get_runtime_character('Paco')
# ---- functions

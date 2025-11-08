## level_root.gd


class_name LevelRoot
extends Node2D
## This node sits at the root of all levels and contains the parameters and methods
## pertaining to the state of the level.

@export var level_name: StringName

signal level_beaten

var current_player: BaseCharacter

var all_characters: Array[BaseCharacter] = []

var exits: Array[Door] = []

func _enter_tree() -> void:
  
  LevelManager.current_level_root = self

func _exit_tree() -> void:
  
  if LevelManager.current_level_root == self:
    LevelManager.current_level_root = null

func _ready() -> void:
  
  pass


func check_level_beaten() -> void:
  
  if exits.all(func(element): return element.exit_condition_satisfied()):
    LevelManager.won_level()

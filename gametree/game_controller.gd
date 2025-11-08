## game_controller.gd

class_name GameController
extends Node
## Node that is meant to sit at the base of the tree as long as the game is on.
## Controls what scenes are loaded in gameplay and UI nodes.


@onready var gameplay: Node2D = $Gameplay
@onready var ui: Control = $UI

var current_gameplay_scene: Node2D
var current_ui_scene: Control

enum SceneChangeType { DELETE, HIDE, REMOVE }


func _ready() -> void:
  Global.game_controller = self
  change_ui_scene("res://menus/level_select/level_select.tscn")


func change_ui_scene(new_scene: String, change_type: SceneChangeType = SceneChangeType.DELETE) -> void:
  
  unload_ui_scene(change_type)
  var new_scene_instance = load(new_scene).instantiate()
  ui.add_child(new_scene_instance)
  current_ui_scene = new_scene_instance


func unload_ui_scene(change_type: SceneChangeType = SceneChangeType.DELETE) -> void:
  if current_ui_scene != null:
    match change_type:
      SceneChangeType.DELETE:
        current_ui_scene.queue_free()
      SceneChangeType.HIDE:
        current_ui_scene.visible = false
      SceneChangeType.REMOVE:
        ui.remove_child(current_ui_scene)
  current_ui_scene = null



func change_gameplay_scene(new_scene: String, change_type: SceneChangeType = SceneChangeType.DELETE, wait_until_freed: bool = false) -> void:
  
  var previous_gameplay_scene = current_gameplay_scene
  unload_gameplay_scene(change_type)
  if wait_until_freed and previous_gameplay_scene != null:
    await previous_gameplay_scene.tree_exited
  var new_scene_instance = load(new_scene).instantiate()
  gameplay.add_child(new_scene_instance)
  current_gameplay_scene = new_scene_instance


func unload_gameplay_scene(change_type: SceneChangeType = SceneChangeType.DELETE) -> void:
  
  if current_gameplay_scene != null:
    match change_type:
      SceneChangeType.DELETE:
        current_gameplay_scene.queue_free()
      SceneChangeType.HIDE:
        current_gameplay_scene.visible = false
      SceneChangeType.REMOVE:
        gameplay.remove_child(current_gameplay_scene)
  current_gameplay_scene = null

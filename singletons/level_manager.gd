## level_manager.gd

extends Node
## singleton that contains a reference to the current LevelRoot. It also has all
## of the level order structure as well as the functions to load and start levels.

var current_level_root: LevelRoot
var current_level_index: int

var level_array: Array[String] = [
  "res://_test_scenes/test_scene_01.tscn",
  "res://_test_scenes/two_halls.tscn"
  
]


func load_level(level_index: int) -> void:
  Global.game_controller.change_gameplay_scene(level_array[level_index])
  Global.game_controller.change_ui_scene(Global.LEVEL_MENU)
  current_level_index = level_index


func restart_level() -> void:
  Global.game_controller.change_gameplay_scene(level_array[current_level_index], GameController.SceneChangeType.DELETE, true)
  Global.game_controller.change_ui_scene(Global.LEVEL_MENU)


func won_level() -> void:
  Global.game_controller.unload_gameplay_scene()
  Global.game_controller.change_ui_scene(Global.WIN_MENU)

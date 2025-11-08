extends Control


func _on_play_again_pressed() -> void:
  LevelManager.restart_level()


func _on_level_select_pressed() -> void:
  Global.game_controller.unload_gameplay_scene()
  Global.game_controller.change_ui_scene(Global.LEVEL_SELECT_MENU)


func _on_exit_pressed() -> void:
  get_tree().quit()

extends Control



func _ready() -> void:
  toggle_menu(false)


func _process(_delta: float) -> void:
  
  if Input.is_action_just_pressed("ui_cancel"):
    toggle_menu()


func toggle_menu(value: bool = not visible) -> void:
  visible = value


func _on_level_select_pressed() -> void:
  Global.game_controller.unload_gameplay_scene()
  Global.game_controller.change_ui_scene(Global.LEVEL_SELECT_MENU)


func _on_exit_pressed() -> void:
  get_tree().quit()


func _on_restart_level_pressed() -> void:
  LevelManager.restart_level()

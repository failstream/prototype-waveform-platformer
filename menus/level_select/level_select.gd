extends Control


@onready var h_box_container: HBoxContainer = $ReferenceRect/VBoxContainer/HBoxContainer


func _ready() -> void:
  
  for child in h_box_container.get_children():
    child.pressed.connect(_button_pressed.bind(child))
  

func _button_pressed(button: Button) -> void:
  
  LevelManager.load_level((button.text as int) - 1)
  self.queue_free()


func _on_exit_pressed() -> void:
  get_tree().quit()

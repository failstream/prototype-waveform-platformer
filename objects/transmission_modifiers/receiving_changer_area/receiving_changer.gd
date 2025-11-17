
@tool
extends Node2D

@export var sprite_2d: Sprite2D
@export var receiving_area: ReceivingArea2D
@export var collision_shape_2d: CollisionShape2D
@export var nine_patch_rect: NinePatchRect

@export var action: ReceivingArea2D.Action = ReceivingArea2D.Action.ON:
  set(value):
    action = value
    receiving_area.effect = action

@export var exit_action: ReceivingArea2D.ExitAction = ReceivingArea2D.ExitAction.DEFAULT:
  set(value):
    exit_action = value
    receiving_area.on_exit = exit_action

const TILE_SIZE: int = 64

## The size of the transmission area in tiles
@export var size_in_tiles: Vector2 = Vector2(2, 2):
  set(value):
    size_in_tiles = value
    set_sprite_2d_size()
    set_collision_shape_size()


func _ready() -> void:
  
  if Engine.is_editor_hint():
    return
  receiving_area.effect = action
  receiving_area.on_exit = exit_action


func get_pixel_size() -> Vector2:
  return size_in_tiles * TILE_SIZE


func set_collision_shape_size() -> void:
  if not collision_shape_2d:
    return
  collision_shape_2d.shape.extents = get_pixel_size() / 2


func set_sprite_2d_size() -> void:
  if not nine_patch_rect:
    return
  nine_patch_rect.size = get_pixel_size()
  nine_patch_rect.position = -get_pixel_size() / 2

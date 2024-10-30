class_name ndTileMapLayer
extends TileMapLayer

# Copies a single cell from coordinates to coordinates.
#
# Properties copied:
# - `source_id`
# - `atlas_coords`
# - `alternative_tile`
#
# NOTE: if `to_tile_map_layer` is not given, copying takes place inside the
# `from_tile_map_layer`.
func copy_cell(
	from_coords: Vector2i,
	to_coords: Vector2i,
	from_tile_map_layer: TileMapLayer = self
) -> void:
	if !from_tile_map_layer:
		from_tile_map_layer = self

	assert(
		from_tile_map_layer.tile_set == tile_set,
		"Tile Sets must match!"
	)

	self.set_cell(
		to_coords,
		from_tile_map_layer.get_cell_source_id(from_coords),
		from_tile_map_layer.get_cell_atlas_coords(from_coords),
		from_tile_map_layer.get_cell_alternative_tile(from_coords),
	)

# Convenience wrapper for `copy_cell` followed by `erase_cell`.
func move_cell(
	from_coords: Vector2i,
	to_coords: Vector2i,
	from_tile_map_layer: TileMapLayer = self
) -> void:
	if !from_tile_map_layer:
		from_tile_map_layer = self

	copy_cell(
		from_coords,
		to_coords,
		from_tile_map_layer
	)
	from_tile_map_layer.erase_cell(from_coords)

# Convenience wrapper for looped `copy_cell`.
#
# FIXME: if `self` is the `null` or same as `from_tile_map_layer`,
# take into account offset direction, so as to not overwrite cells in
# `from_cells` if `to_offset` creates an overlap of both regions!
func copy_cells(
	from_cells: Array[Vector2i],
	to_offset: Vector2i,
	from_tile_map_layer: TileMapLayer = self
) -> void:
	for from_cell in from_cells:
		copy_cell(
			from_cell,
			from_cell + to_offset,
			from_tile_map_layer
		)

# Convenience wrapper for looped `move_cell`.
#
# FIXME: if `self` is the `null` or same as `from_tile_map_layer`,
# take into account offset direction, so as to not overwrite cells in
# `from_cells` if `to_offset` creates an overlap of both regions!
func move_cells(
	from_cells: Array[Vector2i],
	to_offset: Vector2i,
	from_tile_map_layer: TileMapLayer = self
) -> void:
	for from_cell in from_cells:
		move_cell(
			from_cell,
			from_cell + to_offset,
			from_tile_map_layer
		)

# TODO:
# - per-cell data (+ `erase`, `copy_cell` integration)

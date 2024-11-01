class_name BitGrid

var columns: int
var rows: int
var size: int
var bit_data: Array[int] # for multiple 64-bit blocks

# Constructor to set custom grid dimensions
func _init(_columns: int, _rows: int) -> void:
	columns = _columns
	rows = _rows
	size = _columns * _rows
	# Calculate the number of 64-bit integers needed
	var num_ints = int(ceil(float(size) / 64.0))
	bit_data = []
	bit_data.resize(num_ints)

# Helpers to compute int and bit indices; returns a tuple (int_index, bit_index)
func _get_indices(coords: Vector2i) -> Array:
	var index = coords.y * columns + coords.x
	@warning_ignore("integer_division")
	return [
		index / 64, # int index
		index % 64 # bit index
	]

# Checks if a cell is active at specified coordinates
func has_cell(coords: Vector2i) -> bool:
	var indices = _get_indices(coords)
	return (bit_data[indices[0]] & (1 << indices[1])) != 0

# Sets a cell to active (1) at specified coordinates
func set_cell(coords: Vector2i) -> void:
	var indices = _get_indices(coords)
	bit_data[indices[0]] |= (1 << indices[1])

# Erases a cell (sets it to 0) at specified coordinates
func erase_cell(coords: Vector2i) -> void:
	var indices = _get_indices(coords)
	bit_data[indices[0]] &= ~(1 << indices[1])

# Copies a cell's value from one coordinate to another
func copy_cell(from_coords: Vector2i, to_coords: Vector2i, force: bool = false) -> void:
	if force or has_cell(from_coords):
		set_cell(to_coords)
	else:
		erase_cell(to_coords)

# Moves a cell's value from one coordinate to another, erasing the original
func move_cell(from_coords: Vector2i, to_coords: Vector2i, force: bool = false) -> void:
	if force or has_cell(from_coords):
		set_cell(to_coords)
		erase_cell(from_coords)
	else:
		erase_cell(to_coords)

# ---

# Retrieves all active cells as an array of Vector2i coordinates
func get_used_cells() -> Array[Vector2i]:
	var used_cells: Array[Vector2i] = []
	for i in range(size):
		@warning_ignore("integer_division")
		if bit_data[i / 64] & (1 << i % 64) != 0:
			@warning_ignore("integer_division")
			used_cells.append(Vector2i(
				i % columns,
				i / columns
			))
	return used_cells

# Sets multiple active cells based on an array of Vector2i coordinates
func set_used_cells(cells: Array[Vector2i]) -> void:
	clear()
	for cell in cells:
		set_cell(cell)

# Rotates the grid 90 degrees clockwise around its center
func rotate() -> void:
	var new_bit_data: Array[int] = []
	new_bit_data.resize(bit_data.size())
	for i in range(new_bit_data.size()):
		new_bit_data[i] = 0

	# Calculate center coordinates as the rotation pivot
	var center_x = (columns - 1) / 2.0
	var center_y = (rows - 1) / 2.0

	for y in range(rows):
		for x in range(columns):
			var coords = Vector2i(x, y)
			if has_cell(coords):
				# Calculate rotated coordinates around the center
				var new_x = int(round(center_y - (coords.y - center_y)))
				var new_y = int(round(center_x + (coords.x - center_x)))

				# Ensure new coordinates are within bounds before setting
				if new_x >= 0 and new_x < columns and new_y >= 0 and new_y < rows:
					var indices = _get_indices(Vector2i(new_x, new_y))
					new_bit_data[indices[0]] |= (1 << indices[1])

	bit_data = new_bit_data

# Clears the entire grid
func clear() -> void:
	for i in range(bit_data.size()):
		bit_data[i] = 0

enum {DATA = 1}

# Creates and returns a new BitGrid instance with identical dimensions and bit data
func clone(flags: int = DATA) -> BitGrid:
	var _grid = BitGrid.new(columns, rows)
	if flags & DATA:
		_grid.bit_data = bit_data.duplicate()
	return _grid

# Prints the BitGrid as a 2D grid in the console
func print() -> void:
	for y in range(rows):
		var row = ""
		for x in range(columns):
			row += "×" if has_cell(Vector2i(x, y)) else "·"
		print(row)

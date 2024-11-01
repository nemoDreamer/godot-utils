class_name Array2D

var columns: int
var rows: int

var _data: Array[Array]

func _init(_columns: int, _rows: int, skip_data_init: bool = false) -> void:
	columns = _columns
	rows = _rows

	if !skip_data_init:
		_init_data()

func _init_data() -> void:
	_data = _get_blank_data()

func _get_blank_data() -> Array[Array]:
	var out: Array[Array] = []
	out.resize(rows)
	for r in rows:
		out[r] = [] as Array[bool]
		out[r].resize(columns)
	return out

# ---

func has_cell(x: int, y: int) -> bool:
	return _data[y][x]

func set_cell(x: int, y: int, value: bool = true) -> void:
	_data[y][x] = value

func erase_cell(x: int, y: int) -> void:
	set_cell(x, y, false)

func copy_cell(from_x: int, from_y: int, to_x: int, to_y: int) -> void:
	set_cell(to_x, to_y, has_cell(from_x, from_y))

func move_cell(from_x: int, from_y: int, to_x: int, to_y: int) -> void:
	copy_cell(from_x, from_y, to_x, to_y)
	erase_cell(from_x, from_y)

# ---

func get_used_cells() -> Array[Vector2i]:
	var used_cells: Array[Vector2i] = []
	for x in columns:
		for y in rows:
			if has_cell(x, y):
				used_cells.append(Vector2i(x, y))
	return used_cells

func set_used_cells(used_cells: Array[Vector2i]) -> void:
	for cell in used_cells:
		set_cell(cell.x, cell.y)

func for_each_used_cell(fn: Callable) -> void:
	for x in columns:
		for y in rows:
			if has_cell(x, y):
				fn.call(x, y)

# ---

func rotate() -> void:
	var new_data: Array[Array] = _get_blank_data()

	var center_x = (columns - 1) / 2.0
	var center_y = (rows - 1) / 2.0

	for x in columns:
		for y in rows:
			if has_cell(x, y):
				new_data[
					int(round(center_x + (x - center_x)))
				][
					int(round(center_y - (y - center_y)))
				] = true

	_data = new_data

# ---

func clear() -> void:
	_init_data()

enum {DATA = 1}

func clone(flags: int = DATA) -> Array2D:
	var _array_2d = Array2D.new(columns, rows, flags & DATA)

	if flags & DATA:
		_array_2d._data = _data.duplicate(true)

	return _array_2d

# ---

func print() -> void:
	for y in rows:
		var row = ""
		for x in columns:
			row += "×" if has_cell(x, y) else "·"
		print(row)

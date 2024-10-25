class_name ShuffleBag

var inside: Array
var outside: Array

func _init(arr: Array):
	fill(arr)

func fill(arr: Array):
	inside = arr.duplicate()
	inside.shuffle()
	outside = []

func grab():
	var picked = inside.pop_back()

	# after picking, are no more tiles left?
	# NOTE: first, move all outside items back inside. Then, we'll add the
	# picked one to outside. This ensures the picked one can't get chosen twice in a row.
	if inside.size() == 0:
		fill(outside)

	outside.push_back(picked)

	return picked

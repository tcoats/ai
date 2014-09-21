define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'anticlockwise', (vec) =>
		[-vec[1], vec[0]]
	inject.bind 'clockwise', (vec) =>
		[vec[1], -vec[0]]
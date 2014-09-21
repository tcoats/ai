define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'apply force', (entity, f) =>
		p2.vec2.add entity.phys.b.force, entity.phys.b.force, f
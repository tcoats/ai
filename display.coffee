define ['inject', 'colors'], (inject, colors) ->
	class Display
		constructor: ->
			@entities = []
			inject.bind 'step', @step
			inject.bind 'register display', @register
		
		# Integrate
		step: =>
			background colors.bg
			for entity in @entities
				@[entity.n] entity.e() if @[entity.n]?
			target = inject.one 'target'
			if target?
				@target target
		
		unit: (e) =>
			fill colors.bg
			stroke colors.blue
			ellipse e.phys.b.position[0], e.phys.b.position[1], 8, 8
			if e.target?
				line e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]
		
		neo: (e) =>
			fill colors.bg
			if e.targets?
				stroke colors.red
				for t in e.targets
					ellipse t.t[0], t.t[1], 8, 8
			if e.target?
				stroke colors.grey
				ellipse e.target[0], e.target[1], 8, 8
			stroke colors.gold
			ellipse e.phys.b.position[0], e.phys.b.position[1], 8, 8
			if e.target?
				line e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]
		
		target: (t) =>
			line t[0] + 5, t[1], t[0] - 5, t[1]
			line t[0], t[1] + 5, t[0], t[1] - 5
		
		register: (entity, name) =>
			entity.d = n: name, e: -> entity
			@entities.push entity.d
		
	new Display()
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
		
		boid: (e) =>
			fill colors.bg
			color = colors.blue
			if e.stats.iscommunity
				color = colors.red
			if e.stats.timesincetouch < 10
				color = colors.gold
			stroke color
			ellipse e.phys.b.position[0], e.phys.b.position[1], 16, 16
		
		unit: (e) =>
			fill colors.bg
			if e.neo?
				if e.targets?
					stroke colors.red
					for t in e.targets
						ellipse t.t[0], t.t[1], 16, 16
				if e.target?
					stroke colors.grey
					ellipse e.target[0], e.target[1], 16, 16
				stroke colors.gold
				ellipse e.phys.b.position[0], e.phys.b.position[1], 16, 16
				if e.target?
					line e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]
				return
				
			stroke colors.blue
			ellipse e.phys.b.position[0], e.phys.b.position[1], 16, 16
			if e.target?
				line e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]
			
				
		
		register: (entity, name) =>
			entity.d = n: name, e: -> entity
			@entities.push entity.d
		
	new Display()
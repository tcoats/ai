define ['inject'], (inject) ->
	class AI
		constructor: ->
			@entities = []
			inject.bind 'setup', @setup
			inject.bind 'step', @step
			inject.bind 'register ai', @register
		
		setup: =>
			inject.one('stat notify') 'istouched',
				(entity, _, istouched) =>
					return if !entity.ai
					
					if istouched
						inject.one('abs stat') entity, timesincetouch: 0 # reset counter
					else
						inject.one('rel stat') entity, timesincetouch: 1 # count time since touched
		
		step: =>
			entity.step() for entity in @entities
		
		register: (entity, n) =>
			require [n], (type) =>
				entity.ai = new type entity, n
				entity.createdAt = new Date().getTime()
				@entities.push entity.ai
		
	new AI()
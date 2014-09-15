define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			@separate()
			@align()
		
		separate: =>
			averagerepulsion = [0, 0]
			inject.one('each by distance') @e.phys.b.position, 25, (d, e) =>
				return if e is @e or !e.ai?
				diff = [0, 0]
				# proportional to distance from other?
				p2.vec2.sub diff, @e.phys.b.position, e.phys.b.position
				p2.vec2.normalize diff, diff
				p2.vec2.add averagerepulsion, averagerepulsion, diff
			
			istouched = p2.vec2.len(averagerepulsion) isnt 0
			inject.one('abs stat') @e, istouched: istouched
			return if !istouched
			
			inject.one('scale to max velocity') averagerepulsion
			force = inject.one('calculate steering') @e.phys.b.velocity, averagerepulsion
			p2.vec2.scale force, force, 0.6
			inject.one('apply force') @e, force
		
		align: =>
			@e.target = null
			
			distances = []
			
			inject.one('each by distance') @e.phys.b.position, 50, (d, e) =>
				return if e is @e or !e.ai?
				distances.push
					d: d
					e: e
			
			return if distances.length is 0
			
			distances.sort (a, b) => a.d - b.d
			
			if distances.length is 1
				@e.target = p2.vec2.clone distances[0].e.phys.b.position
			else
				@e.target = inject.one('calculate perpendicular') distances[0].e.phys.b.position, distances[1].e.phys.b.position,  @e.phys.b.position
			
			mag = [0, 0]
			p2.vec2.sub mag, @e.target, @e.phys.b.position
			inject.one('scale to max velocity') mag
			force = inject.one('calculate steering') @e.phys.b.velocity, mag
			p2.vec2.scale force, force, 0.5
			inject.one('apply force') @e, force
			
			
			
			
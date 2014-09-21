define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
			
		step: =>
			@separate()
			@align()
			@form()
			@cohere()
		
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
			p2.vec2.scale force, force, 2
			inject.one('apply force') @e, force

		align: =>
			averagedirection = [0, 0]
			count = 0
			inject.one('each by distance') @e.phys.b.position, 100, (d, e) =>
				return if e is @e or !e.ai?
				p2.vec2.add averagedirection, averagedirection, e.phys.b.velocity
				count++
			return if p2.vec2.len(averagedirection) is 0
			
			inject.one('scale to max velocity') averagedirection
			force = inject.one('calculate steering') @e.phys.b.velocity, averagedirection
			p2.vec2.scale force, force, 0.4
			inject.one('apply force') @e, force
		
		form: =>
			@e.target = null
			@e.targets = null
			
			# get a local view of the battlefield
			distances = []
			inject.one('each by distance') @e.phys.b.position, 60, (d, e) =>
				return if e is @e or !e.ai?
				distances.push
					d: d
					e: e
			
			# no one around, probably should 'search'
			return if distances.length is 0
			
			# sort by closeness
			distances.sort (a, b) => a.d - b.d
			targets = []
			
			first = distances[0]
			
			# one comrade, move into position
			if distances.length is 1
				target = [0, 0]
				p2.vec2.sub target, @e.phys.b.position, first.e.phys.b.position
				p2.vec2.normalize target, target
				p2.vec2.scale target, target, 32
				p2.vec2.add target, target, first.e.phys.b.position
				targets.push target
			
			# more than one comrade, form a phalanx
			else
				next =
					d: 120
					e: null
				for d in distances
					continue if d.e is first.e
					dist = p2.vec2.dist d.e.phys.b.position, first.e.phys.b.position
					if dist < next.d
						next.d = dist
						next.e = d.e
				
				target = [0, 0]
				p2.vec2.sub target, first.e.phys.b.position, next.e.phys.b.position
				p2.vec2.normalize target, target
				p2.vec2.scale target, target, 32
				
				target1 = [0, 0]
				p2.vec2.add target1, first.e.phys.b.position, target
				target2 = [0, 0]
				p2.vec2.sub target2, first.e.phys.b.position, target
				rotate = inject.one('anticlockwise') target
				target3 = [0, 0]
				p2.vec2.add target3, first.e.phys.b.position, rotate
				target4 = [0, 0]
				p2.vec2.sub target4, first.e.phys.b.position, rotate
				targets.push target1
				targets.push target2
				targets.push target3
				targets.push target4
			
			# discount any target that is too close to a comrade
			targets = targets.filter (t) ->
				for d in distances
					dist = p2.vec2.dist t, d.e.phys.b.position
					if dist <= 24
						return no
				yes
				
			targets = targets.map (t) =>
				d: p2.vec2.dist t, @e.phys.b.position
				t: t
			targets.sort (a, b) => a.d - b.d
			
			@e.targets = targets
			
			# no space - panic!
			return if targets.length is 0
			
			@e.target = targets[0].t
			
			mag = [0, 0]
			p2.vec2.sub mag, @e.target, @e.phys.b.position
			inject.one('limit to max velocity') mag
			force = inject.one('calculate steering') @e.phys.b.velocity, mag
			p2.vec2.scale force, force, 0.5
			inject.one('apply force') @e, force

		cohere: =>
			averageposition = [0, 0]
			count = 0
			inject.one('each by distance') @e.phys.b.position, 100, (d, e) =>
				return if e is @e or !e.ai?
				p2.vec2.add averageposition, averageposition, e.phys.b.position
				count++
			
			inject.one('abs stat') @e,
				iscommunity: count > 0
			iscommunity = count > 0
			
			return if p2.vec2.len(averageposition) is 0
			p2.vec2.scale averageposition, averageposition, 1 / count
			
			targetvelocity = inject.one('calculate seeking') @e.phys.b.position, averageposition
			force = inject.one('calculate steering') @e.phys.b.velocity, targetvelocity
			p2.vec2.scale force, force, 0.1
			inject.one('apply force') @e, force
			
			
			
			
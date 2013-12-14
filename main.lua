function love.load()
		world = love.physics.newWorld(0, 32, false)
		e = {}
		e.f = {}
		e.f.b = love.physics.newBody(world, 0, 0)
		e.f.s = love.physics.newEdgeShape(0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
		e.f.f = love.physics.newFixture(e.f.b, e.f.s)
		e.f.f:setRestitution(1)
		fire = false
end
function spawnBullet(x, y, tx, ty)
		--if not fire then
				fire = true
				bullet = {}
				bullet.b = love.physics.newBody(world, x, y, "dynamic")
				bullet.s = love.physics.newCircleShape(5)
				bullet.f = love.physics.newFixture(bullet.b, bullet.s)
				bullet.b:setMass(10)
				local ang = math.atan2((ty-y), (tx-x))
				local tx = math.cos(ang) * 1*math.pow(10, 5.5)
				local ty = math.sin(ang) * 1*math.pow(10, 5.5)
				bullet.b:applyForce(tx, ty)
		--end
end
function love.mousepressed(x, y, k)
		spawnBullet(0, love.graphics.getHeight()/2, x, y)
end
function love.update(dt)
		world:update(dt)
end
function love.draw()
		if(fire) then
				love.graphics.circle('fill', bullet.b:getX(), bullet.b:getY(), bullet.s:getRadius())
		end
end

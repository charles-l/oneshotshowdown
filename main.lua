function love.load()
		world = love.physics.newWorld(0, 32, false)
		e = {}
		e.f = {}
		e.f.b = love.physics.newBody(world, 0, 0)
		e.f.s = love.physics.newEdgeShape(0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
		e.f.f = love.physics.newFixture(e.f.b, e.f.s)
		e.f.f:setRestitution(1)
		fire = false
		guy = love.graphics.newImage('guy.png')
		guy:setFilter("nearest", "nearest")
		bulletimg = love.graphics.newImage('bullet.png')
		flat = love.graphics.newQuad(0, 0, 16, 16, 48, 16)
		up = love.graphics.newQuad(16, 0, 16, 16, 48, 16)
		down = love.graphics.newQuad(32, 0, 16, 16, 48, 16)
		dir = flat
end
function spawnBullet(x, y, tx, ty)
		if not fire then
				fire = true
				bullet = {}
				bullet.b = love.physics.newBody(world, x, y, "dynamic")
				bullet.s = love.physics.newCircleShape(5)
				bullet.f = love.physics.newFixture(bullet.b, bullet.s)
				bullet.b:setMass(10)
				ang = math.atan2((ty-y), (tx-x))
				local tx = math.cos(ang) * 1*math.pow(10, 5.5)
				local ty = math.sin(ang) * 1*math.pow(10, 5.5)
				bullet.b:applyForce(tx, ty)
		end
end
function resetScene()
		bullet.f:destroy()
		bullet.b:destroy()
		bullet = nil
		fire = false
end
function love.mousepressed(x, y, k)
		if(dir == flat) then
				spawnBullet(53, (love.graphics.getHeight()/2)-5, x, y)
		end
		if(dir == up) then
				spawnBullet(55, (love.graphics.getHeight()/2)-20, x, y)
		end
		if(dir == down) then
				spawnBullet(55, (love.graphics.getHeight()/2)+8, x, y)
		end
end
function love.keypressed(k)
		if(k == "r") then
				resetScene()
		end
end
function love.update(dt)
		world:update(dt)
		if(love.mouse.getY() < 100) then
				dir = up
		elseif(love.mouse.getY() > 100 and love.mouse.getY() < 300)then
				dir = flat
		else
				dir = down
		end
end
function love.draw()
		love.graphics.setBackgroundColor(255, 255, 255)
		love.graphics.draw(guy, dir, 100, love.graphics.getHeight()/2, 0, 4, 4, guy:getWidth()/2, guy:getHeight()/2)
		if(fire) then
				love.graphics.draw(bulletimg, bullet.b:getX(), bullet.b:getY(), ang, 4)
		end
end

function love.load()
		world = love.physics.newWorld(0, 700, false)
		world:setCallbacks( beginContact, endContact, preSolve, postSolve )
		e = {}
		e.f = {}
		e.f.b = love.physics.newBody(world, 0, 0)
		e.f.s = love.physics.newEdgeShape(0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
		e.f.f = love.physics.newFixture(e.f.b, e.f.s)
		e.r = {}
		e.r.b = love.physics.newBody(world, 0, 0)
		e.r.s = love.physics.newEdgeShape(love.graphics.getWidth(), 0, love.graphics.getWidth(), love.graphics.getHeight())
		e.r.f = love.physics.newFixture(e.r.b, e.r.s)
		e.t = {}
		e.t.b = love.physics.newBody(world, 0, 0)
		e.t.s = love.physics.newEdgeShape(0, 0, love.graphics.getWidth(), 0)
		e.t.f = love.physics.newFixture(e.t.b, e.t.s)
		e.l = {}
		e.l.b = love.physics.newBody(world, 0, 0)
		e.l.s = love.physics.newEdgeShape(0, 0, 0, love.graphics.getHeight())
		e.l.f = love.physics.newFixture(e.l.b, e.l.s)
		fire = false
		fire2 = false
		guy = love.graphics.newImage('guy.png')
		guy:setFilter("nearest", "nearest")
		guy2 = love.graphics.newImage('guy2.png')
		guy2:setFilter("nearest", "nearest")
		bulletimg = love.graphics.newImage('bullet.png')
		flat = love.graphics.newQuad(0, 0, 16, 16, 48, 16)
		up = love.graphics.newQuad(16, 0, 16, 16, 48, 16)
		down = love.graphics.newQuad(32, 0, 16, 16, 48, 16)
		dir = flat
		c1 = {}
		c1.b = love.physics.newBody(world, 35, love.graphics.getHeight()/2, "static")
		c1.s = love.physics.newRectangleShape(10, 50)
		c1.f = love.physics.newFixture(c1.b, c1.s)
		c1.f:setSensor(true)
		c1.f:setUserData("Player1")
		c2 = {}
		c2.b = love.physics.newBody(world, love.graphics.getWidth()-32, love.graphics.getHeight()/2, "static")
		c2.s = love.physics.newRectangleShape(20, 30)
		c2.f = love.physics.newFixture(c2.b, c2.s)
		c2.f:setSensor(true)
		c2.f:setUserData("Player2")
		flat2 = love.graphics.newQuad(16, 0, 16, 16, 48, 16)
		up2 = love.graphics.newQuad(0, 0, 16, 16, 48, 16)
		down2 = love.graphics.newQuad(32, 0, 16, 16, 48, 16)
		dir2 = flat
		p2win = false
		rockimg = love.graphics.newImage("rock.png")
		rockimg:setFilter("nearest", "nearest")
		ricochet = love.audio.newSource("ricochet.wav", "static")
		ricochet:setVolume(.1)
		turn = 1
		generateBlocks()
		font100 = love.graphics.newFont('font.ttf', 100)
		font50 = love.graphics.newFont('font.ttf', 100)
		font20 = love.graphics.newFont('font.ttf', 20)
		debug = false
		score = {p1 = 0, p2 = 0}
		p1tx = -1
		p1ty = -1
		p2tx = -1
		p2ty = -1
end
function generateBlocks()
		blocks = {}
		math.randomseed(os.time())
		for i=1, math.random(6, 15) do
				x = {}
				x.b = love.physics.newBody(world, math.random(200, love.graphics.getWidth()-200), math.random(0, love.graphics.getHeight()))
				x.s = love.physics.newRectangleShape(math.ceil(math.random(20, 200))/8, math.random(20, 200))
				x.f = love.physics.newFixture(x.b, x.s)
				table.insert(blocks, x)
		end
end
function spawnBullet(x, y, tx, ty)
		if not fire then
				fire = true
				bullet = {}
				bullet.b = love.physics.newBody(world, x, y, "dynamic")
				bullet.s = love.physics.newCircleShape(5)
				bullet.f = love.physics.newFixture(bullet.b, bullet.s)
				bullet.f:setRestitution(1)
				bullet.b:setAngularDamping(10)
				bullet.f:setUserData("bullet")
				bullet.b:setMass(10)
				ang = math.atan2((ty-y), (tx-x))
				local tx = math.cos(ang) * 1*math.pow(10, 5.5)
				local ty = math.sin(ang) * 1*math.pow(10, 5.5)
				bullet.b:applyForce(tx, ty)
		end
end
function spawnBullet2(x, y, tx, ty)
		if not fire2 then
				fire2 = true
				bullet2 = {}
				bullet2.b = love.physics.newBody(world, x, y, "dynamic")
				bullet2.s = love.physics.newCircleShape(5)
				bullet2.f = love.physics.newFixture(bullet2.b, bullet2.s)
				bullet2.f:setRestitution(1)
				bullet2.b:setAngularDamping(10)
				bullet2.f:setUserData("bullet")
				bullet2.b:setMass(10)
				ang = math.atan2((ty-y), (tx-x))
				local tx = math.cos(ang) * 1*math.pow(10, 5.5)
				local ty = math.sin(ang) * 1*math.pow(10, 5.5)
				bullet2.b:applyForce(tx, ty)
		end
end
function resetScene()
		if(fire)then
				bullet.f:destroy()
				bullet.b:destroy()
				bullet = nil
				fire = false
		end
		if(fire2)then
				bullet2.f:destroy()
				bullet2.b:destroy()
				bullet2 = nil
				fire2 = false
		end
		for i,v in ipairs(blocks) do
				v.f:destroy()
				v.b:destroy()
		end
		blocks = {}
		generateBlocks()
		turn = 1
		p1win = false
		p2win = false
		p1tx = -1
		p1ty = -1
		p2tx = -1
		p2tx = -1
end
function love.mousepressed(x, y, k)
		if(k == "l")then
				if(turn == 1) then
						turn = 2
						p1tx = x
						p1ty = y
				else
						p2tx = x
						p2ty = y
						turn = 1
				end
		end
end
function love.keypressed(k)
		if(k == "r") then
				resetScene()
		end
		if(k=="d")then
				debug = not debug
		end
		if(k==" ")then
				spawnBullet(55, (love.graphics.getHeight()/2)+8, p1tx, p1ty)
				spawnBullet2(love.graphics.getWidth() - 65, (love.graphics.getHeight()/2)+8, p2tx, p2ty)
		end
end
function love.update(dt)
		if(p2win or p1win)then
				dt = dt * .1
		end
		world:update(dt)
		-- P1
		if (turn == 1) then
				if(love.mouse.getY() < 100) then
						dir = up
				elseif(love.mouse.getY() > 100 and love.mouse.getY() < 300)then
						dir = flat
				else
						dir = down
				end
		else
				-- P2
				if(love.mouse.getY() < 100) then
						dir2 = up2
				elseif(love.mouse.getY() > 100 and love.mouse.getY() < 300)then
						dir2 = flat2
				else
						dir2 = down2
				end
		end
end
function love.draw()
		love.graphics.setFont(font20)
		love.graphics.reset()
		love.graphics.setBackgroundColor(135, 206, 250)
		love.graphics.draw(rockimg, 0, love.graphics.getHeight()/2 + 14, 0, 4)
		love.graphics.draw(rockimg, love.graphics.getWidth(), love.graphics.getHeight()/2 + 14, 0, -4, 4)
		love.graphics.draw(guy, dir, 100, love.graphics.getHeight()/2, 0, 4, 4, guy:getWidth()/2, guy:getHeight()/2)
		love.graphics.draw(guy2, dir2, love.graphics.getWidth() + 30, love.graphics.getHeight()/2, 0, 4, 4, guy:getWidth()/2, guy:getHeight()/2)
		if(fire) then
				love.graphics.draw(bulletimg, bullet.b:getX(), bullet.b:getY(), bullet.b:getAngle(), 4)
		end
		if(fire2) then
				love.graphics.draw(bulletimg, bullet2.b:getX(), bullet2.b:getY(), bullet2.b:getAngle(), 4)
		end
		love.graphics.setColor(0, 0, 0)
		for i,v in ipairs(blocks) do
				love.graphics.polygon("fill", v.b:getWorldPoints(v.s:getPoints()))
		end
		if(debug) then
				love.graphics.print("FPS " .. love.timer.getFPS(), 10, 10)
				love.graphics.print("Blocks " ..#blocks, 10, 30)
				love.graphics.polygon("line", c1.b:getWorldPoints(c1.s:getPoints()))
				love.graphics.polygon("line", c2.b:getWorldPoints(c2.s:getPoints()))
		end
		love.graphics.setColor(255, 70, 70)
		love.graphics.rectangle('fill', p1tx, p1ty, 3, 3)
		love.graphics.setColor(70, 255, 70)
		love.graphics.rectangle('fill', p2tx, p2ty, 3, 3)
		love.graphics.setColor(0,0,0)
		love.graphics.print("Player 1: " .. score.p1, love.graphics.getWidth() - 100, 10)
		love.graphics.print("Player 2: " .. score.p2, love.graphics.getWidth() - 100, 30)
		if(p2win)then
				love.graphics.setFont(font100)
				love.graphics.setColor(255, 0, 0)
				love.graphics.print("Player 2 wins", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1, font100:getWidth("Player 1 wins")/2, font100:getHeight()/2)
		end
		if(p1win)then
				love.graphics.setFont(font100)
				love.graphics.setColor(255, 0, 0)
				love.graphics.print("Player 1 wins", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1, font100:getWidth("Player 2 wins")/2, font100:getHeight()/2)
		end
end
function beginContact(a, b, col)
		if(a:getUserData() == "bullet" or b:getUserData() == "bullet") then
				love.audio.rewind(ricochet)
				ricochet:setPitch( math.random(1, 5) )
				love.audio.play(ricochet)
		end
		if((a:getUserData() == "bullet" and b:getUserData() == "Player1") or (a:getUserData() == "Player1" and b:getUserData() == "bullet"))then
				p2win = true
				score.p2 = score.p2 + 1
		end
		if((a:getUserData() == "bullet" and b:getUserData() == "Player2") or (a:getUserData() == "Player2" and b:getUserData() == "bullet"))then
				p1win = true
				score.p1 = score.p1 + 1
		end
end

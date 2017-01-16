debug = true

player = { x = 200, y = 710, speed = 150, img = nil }
-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated

--More timers
createEnemyTimerMax = 1
createEnemyTimer = createEnemyTimerMax

-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function

-- More storage
enemies = {} -- array of current enemies on screen


function love.load(arg)
 player.img = love.graphics.newImage('assets/Aircraft_01.png')
 bulletImg = love.graphics.newImage('assets/bullet_2_blue.png')
 enemyImg = love.graphics.newImage('assets/Aircraft_09.png')
end

function love.update(dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	if love.keyboard.isDown('left','a') then
		if player.x > 0 then -- binds us to the map
			player.x = player.x - (player.speed*dt)
		end
	elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
	end

	-- Time out how far apart our shots can be.
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
	  canShoot = true
	end

	if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
		-- Create some bullets
		newBullet = { x = (player.x + (player.img:getWidth()/2)) -3 , y = player.y -5, img = bulletImg }
		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end
	-- update the positions of bullets
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

	  	if bullet.y < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end

	-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax
		-- Create an enemy
		randomNumber = math.random(10, love.graphics.getWidth() - 110)
		newEnemy = { x = randomNumber, y = -10, img = enemyImg }
		table.insert(enemies, newEnemy)
	end
	-- update the positions of enemies
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (200 * dt)

		if enemy.y > 850 then -- remove enemies when they pass off the screen
			table.remove(enemies, i)
		end
	end

end

function love.draw(dt)

    love.graphics.draw(player.img, player.x, player.y)

    for i, bullet in ipairs(bullets) do
  		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end
end

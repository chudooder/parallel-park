local class = require('lib.middleclass')
local Entity = require('src.engine.entity')
local vec2 = require('lib.vec2')
 
local CarEntity = class('CarEntity', Entity)
 
function CarEntity:initialize(arg)
    Entity.initialize(self, arg)
    --self.x = 0
    --self.y = 0
    self.height = 40
    self.width = 30
    self.desiredSpeed = 0
    self.maxFowardSpeed = 150
    self.maxBackwardSpeed = -150
    self.maxDriveForce = 200
    self.currentSpeed = 0
    self.desiredTorque = 0
    self.maxLateralImpulse = 1
    self.body = love.physics.newBody(arg.world, self.width/2, self.height/2, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end
 
function CarEntity:getLateralVelocity()
 
    rightNormalVec = vec2.new(self.body:getWorldVector(1,0))
    linearVelX, linearVelY = self.body:getLinearVelocity()
    linearVelVec = vec2.new(linearVelX, linearVelY)
 
    return vec2.scale(rightNormalVec, vec2.dot(rightNormalVec, linearVelVec))
end
 
function CarEntity:getFowardVelocity()
 
    rightNormalVec = vec2.new(self.body:getWorldVector(0,1))
    linearVelX, linearVelY = self.body:getLinearVelocity()
    linearVelVec = vec2.new(linearVelX, linearVelY)
 
    return vec2.scale(rightNormalVec, vec2.dot(rightNormalVec, linearVelVec))
end
 
function CarEntity:updatesFriction()
    negLateralVel = vec2.scale(self:getLateralVelocity(),-1)
    impulse = vec2.scale(negLateralVel,self.body:getMass())
 
    if vec2.len(impulse) > self.maxLateralImpulse then
        impulse = vec2.scale(impulse, self.maxLateralImpulse/vec2.len(impulse))
    end
 
    ix, iy = vec2.unpack(impulse)
    x, y = self.body:getWorldCenter()
    self.body:applyLinearImpulse(ix,iy,x,y)
end
    
 
function CarEntity:draw()
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)
end
 
function CarEntity:update(dt)
    if love.keyboard.isDown("w") then
        self.desiredSpeed = self.maxFowardSpeed
    end
 
    if love.keyboard.isDown("s") then
        self.desiredSpeed = self.maxBackwardSpeed
    end
 
    currentFowardNormal = vec2.new(self.body:getWorldVector(0,1))
    self.currentSpeed = vec2.dot(self:getFowardVelocity(),currentFowardNormal)
 
    
 
    if love.keyboard.isDown("a") then
        self.desiredTorque = 15
    end
 
    if love.keyboard.isDown("d") then
        self.desiredTorque = -15
    end
 
    self.body:applyTorque(self.desiredTorque)
 
    force = 0
    if(self.desiredSpeed > self.currentSpeed) then
        force = self.maxDriveForce
    elseif (self.desiredSpeed < self.currentSpeed) then
        force = -1*self.maxDriveForce
    end
 
    fx, fy = vec2.unpack(currentFowardNormal)
    x, y = self.body:getWorldCenter()
    self.body:applyForce(force*fx, force*fy, x, y)
 
    self:updatesFriction()
end
 
-- exports
return CarEntity
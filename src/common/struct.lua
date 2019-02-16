local class = require('lib.middleclass')

-- It's a Stack!

local Stack = class('Stack')

function Stack:initialize()
    self.top = 0
    self.data = {}
end

function Stack:push(o)
    self.data[self.top] = data
    self.top = self.top + 1
end

function Stack:pop()
    if self.top == 0 then
        return nil
    end

    local tmp = self.data[self.top]
    self.data[self.top] = nil
    return tmp
end

function Stack:peek()
    return self.data[self.top]
end

function Stack:empty()
    return self.top == 0
end

-- It's a Queue!

local Queue = class('Queue')

function Queue:initialize()
    self.front = 0
    self.back = 0
    self.data = {}
end

function Queue:enqueue(o)
    self.data[self.front] = o
    self.front = self.front + 1
end

function Queue:dequeue()
    if self.back == self.front then
        return nil
    end

    local tmp = self.data[self.back]
    self.data[self.back] = nil
    self.back = self.back + 1
    return tmp
end

function Queue:empty()
    return self.back == self.front
end

-- exports
local M = {}
M.Stack = Stack
M.Queue = Queue
return M
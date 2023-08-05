local ServerScriptService = game:GetService("ServerScriptService")

return function()
	local Component = require(ServerScriptService.Lib)

	it("should live in exact order", function()
		local component, create = Component()

		local counter = {}

		local function updateCounter(n)
			table.insert(counter, n)
		end

		function component:Init()
			updateCounter(1)
		end

		function component:Render()
			updateCounter(2)
			return Instance.new("Part")
		end

		function component:DidRender()
			updateCounter(3)
		end

		function component:WillDestroy()
			updateCounter(4)
		end

		create():Destroy()

		for i = 1, 4 do
			expect(counter[i]).to.equal(i)
		end
	end)

	describe("Component.Init", function()
		it("should reach", function()
			local component, create = Component()

			local reached = false
			function component:Init()
				reached = true
			end

			function component:Render()
				return Instance.new("Part")
			end

			create()
			expect(reached).to.equal(true)
		end)
	end)

	describe("Component.Render", function()
		it("should reach", function()
			local component, create = Component()

			local reached = false
			function component:Init()
				reached = true
			end

			function component:Render()
				return Instance.new("Part")
			end

			create()
			expect(reached).to.equal(true)
		end)

		it("should render an instance", function()
			local component, create = Component()

			function component:Render()
				return Instance.new("Part")
			end

			local result = create()

			expect(result).to.be.a("userdata")
		end)

		it("should render only instances", function()
			local component, create = Component()

			function component:Render()
				return 0
			end

			expect(create).to.throw()
		end)
	end)

	describe("Component.DidRender", function()
		it("should reach if instance is rendered", function()
			local component, create = Component()

			local reached = false

			function component:Render()
				return Instance.new("Part")
			end

			function component:DidRender()
				reached = true
			end

			create()
			expect(reached).to.equal(true)
		end)

		it("should not reach if instance is not rendered", function()
			local component, create = Component()

			local reached = false
			function component:DidRender()
				reached = true
			end

			expect(create).to.throw()
			expect(reached).to.equal(false)
		end)
	end)

	describe("Component.WillDestroy", function()
		it("should reach", function()
			local component, create = Component()

			local reached = false
			function component:WillDestroy()
				reached = true
			end

			function component:Render()
				return Instance.new("Part")
			end

			create():Destroy()
			expect(reached).to.equal(true)
		end)

		it("should reach only if instance is rendered", function()
			local component, create = Component()

			local reached = false
			function component:WillDestroy()
				reached = true
			end

			expect(create).to.throw()
			expect(reached).to.equal(false)
		end)

		it("should reach before instance is destroyed", function()
			local instance
			local component, create = Component()

			function component:Render()
				return Instance.new("Part", script)
			end

			local parent
			function component:WillDestroy()
				parent = instance.Parent
			end

			instance = create()
			instance:Destroy()
			expect(parent).to.be.ok()
		end)
	end)
end

local ServerScriptService = game:GetService("ServerScriptService")

local props = {
	Test = "Test",
	Value = 2,
}

return function()
	local Component = require(ServerScriptService.Lib)

	it("should receive props", function()
		local component, create = Component()

		local indentical = false

		function component:Init(receivedProps)
			indentical = (table.concat(receivedProps) == table.concat(props))
		end

		function component:Render()
			return Instance.new("Part")
		end

		create(props)
		expect(indentical).to.equal(true)
	end)

	it("should assign props field in fragment", function()
		local component, create = Component()

		local propsExists = false

		function component:Render()
			propsExists = (table.concat(self.Props) == table.concat(props))
			return Instance.new("Part")
		end

		create(props)
		expect(propsExists).to.equal(true)
	end)
end

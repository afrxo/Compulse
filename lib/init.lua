--!strict
--[[
		An open-source library for Fusion (dphfox),
		enabling seamless creation of component-based classes.
		Simplify UI development and embrace modularity with Fusion Component.
--]]

export type Factory<props> = (Props: props) -> Instance

export type Component<props> = {
	Props: props,
	Init: ((Component<props>, props: props) -> ())?,
	Render: ((Component<props>) -> Instance?)?,
	DidRender: ((Component<props>) -> ())?,
	WillDestroy: ((Component<props>) -> ())?,

	[string | any]: any
}

type table = { [any]: any }

local function tryMethod(object: table, name: string, ...: any): any
	if object[name] then
		return object[name](...)
	end

	return nil
end

return function<props>(): (Component<props>, Factory<props>)
	local component = {}

	local function create(Props: props)
		local fragment = setmetatable({
			Props = Props,
		}, {__index = component})

		tryMethod(component, "Init", fragment, Props)

		local renderResult: Instance = tryMethod(component, "Render", fragment)

		assert(
			typeof(renderResult) == "Instance",
			`Expected Component.Render to return an instance, got {typeof(renderResult)} instead`
		)

		tryMethod(component, "DidRender", fragment)

		local destroying
		destroying = renderResult.Destroying:Connect(function()
			tryMethod(component, "WillDestroy", fragment)

			destroying:Disconnect()
		end)

		return renderResult
	end

	return component, create
end

# Compulse
An open-source library for Roblox,
enabling seamless creation of component-based classes with lifecycle. Simplify UI development and embrace modularity.

## Installation
Add **Compulse** to your `wally.toml` dependency list:

`Compulse = "afrxo/compulse@^1" `


## Example
```lua
local Button, create = Compulse()

function Button:Init(props)
    self.Text = props.Text
end

function Button:Render()
    return Fusion.New "TextButton" {
        Text = self.Text,
        Size = UDim2.fromOffset(200, 50),
        [Fusion.OnEvent "Activated"] = self.Props.Activated
    }
end

function Button:DidRender()
    print('I was created ;)')
end

function Button:WillDestroy()
    print('There I go.. :C')
end

return create
```

```lua
-- [imports omitted]

local instance = Button {
    Text = "Click me!",
    Activated = function()
        print("Do something")
    end
}

instance.Parent = Fusion.New "ScreenGui" {
    Parent = Player.PlayerGui
}

task.delay(3, instance.Destroy, instance)
```

## Strictly Typed
```lua
export type Factory<props> = Compulse.Factory<props>
export type Component<props> = Compulse.Component<props>

export type Props = {
	Text: string,
	Activated: () -> ()
}

local Component: Component<Props>, create: Factory<Props> = Compulse()

-- The `props` type gets inferred automatically
function Component:Init(props)
	self.Text = props.Text
end

function Component:Render()
	return Fusion.New "TextButton" {
		Size = UDim2.fromOffset(200, 50),
		Text = self.Text,
		[Fusion.OnEvent "Activated"] = self.Props.Activated
	}
end

return create
```
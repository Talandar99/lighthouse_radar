require("prototypes.lighthouse")

if mods["space-age"] then
	data.raw["radar"]["lighthouse"].surface_conditions = {
		{
			property = "pressure",
			min = 1,
			max = 10000,
		},
	}
end

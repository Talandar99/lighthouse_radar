-------------------------------------------------------------------------------
-- lighthouse: spawn/remove lamp based on fuel state
-------------------------------------------------------------------------------
local function on_built_lighthouse(event)
	local lighthouse = event.entity or event.created_entity
	if not (lighthouse and lighthouse.valid and lighthouse.name == "lighthouse") then
		return
	end

	storage.lighthouse_night_lights[lighthouse.unit_number] = { radar = lighthouse, lamp = nil }
end
local function on_removed_lighthouse(event)
	local e = event.entity
	if not (e and e.valid and e.name == "lighthouse") then
		return
	end

	local data = storage.lighthouse_night_lights[e.unit_number]
	if data and data.lamp and data.lamp.valid then
		data.lamp.destroy()
	end
	storage.lighthouse_night_lights[e.unit_number] = nil
end
-------------------------------------------------------------------------------
-- check every 2 seconds
-------------------------------------------------------------------------------
script.on_nth_tick(120, function()
	if not storage.lighthouse_night_lights then
		return
	end

	for id, data in pairs(storage.lighthouse_night_lights) do
		local lighthouse = data.radar
		if not (lighthouse and lighthouse.valid) then
			if data.lamp and data.lamp.valid then
				data.lamp.destroy()
			end
			storage.lighthouse_night_lights[id] = nil
		else
			local fluid = lighthouse.fluidbox and lighthouse.fluidbox[1]
			local amount = (fluid and fluid.amount) or 0
			local has_fuel = amount > 0.01

			if has_fuel then
				data.empty_ticks = 0

				if not (data.lamp and data.lamp.valid) then
					local lamp = lighthouse.surface.create_entity({
						name = "lighthouse-night-light",
						position = { lighthouse.position.x - 0.1, lighthouse.position.y },
						force = lighthouse.force,
						create_build_effect_smoke = false,
					})
					if lamp then
						lamp.destructible = false
						lamp.operable = false
						data.lamp = lamp
					end
				end
			else
				data.empty_ticks = (data.empty_ticks or 0) + 1

				if data.empty_ticks >= 3 then
					if data.lamp and data.lamp.valid then
						data.lamp.destroy()
						data.lamp = nil
					end
				end
			end
		end
	end
end)
-------------------------------------------------------------------------------
--- init
-------------------------------------------------------------------------------
local function ensure_storage_integrity()
	if not storage then
		return
	end

	storage.lighthouse_night_lights = storage.lighthouse_night_lights or {}
	storage.pelagos_diesel_collectors = storage.pelagos_diesel_collectors or {}
end
-------------------------------------------------------------------------------
-- on_entity_built logic
-------------------------------------------------------------------------------
local function on_entity_built(event)
	ensure_storage_integrity()
end

-------------------------------------------------------------------------------
local function on_init(event)
	storage.lighthouse_night_lights = storage.lighthouse_night_lights or {}
end
script.on_init(on_init)

local function on_configuration_changed(event)
	storage.lighthouse_night_lights = storage.lighthouse_night_lights or {}
	if not next(storage.lighthouse_night_lights) then
		for _, surface in pairs(game.surfaces) do
			for _, lighthouse in pairs(surface.find_entities_filtered({ name = "lighthouse" })) do
				storage.lighthouse_night_lights[lighthouse.unit_number] = {
					radar = lighthouse,
					lamp = nil,
				}
			end
		end
	end
end
script.on_configuration_changed(on_configuration_changed)
-------------------------------------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end

	on_entity_built(event)
	on_built_lighthouse(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end
	on_entity_built(event)
	on_built_lighthouse(event)
end)
script.on_event(defines.events.on_space_platform_built_entity, function(event)
	local e = event.entity
	if not (e and e.valid) then
		return
	end

	on_built_lighthouse(event)
end)

script.on_event(
	{ defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity },
	function(event)
		local e = event.entity
		if not e then
			return
		end

		on_removed_lighthouse(event)
	end
)

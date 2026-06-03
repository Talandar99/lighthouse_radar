-------------------------------------------------------------------------------
-- lighthouse: spawn/remove render objects based on fuel state
-------------------------------------------------------------------------------
local GLOW_OFFSET_X = 0 
local GLOW_OFFSET_Y = -130 / 32

local function on_built_lighthouse(event)
	local lighthouse = event.entity or event.created_entity
	if not (lighthouse and lighthouse.valid and lighthouse.name == "lighthouse") then
		return
	end

	storage.lighthouse_night_lights[lighthouse.unit_number] = { radar = lighthouse, render_id = nil, glow_id = nil }
end
local function on_removed_lighthouse(event)
	local e = event.entity
	if not (e and e.valid and e.name == "lighthouse") then
		return
	end

	local data = storage.lighthouse_night_lights[e.unit_number]
	if data then
		if data.render_id and data.render_id.valid then data.render_id.destroy() end
		if data.glow_id and data.glow_id.valid then data.glow_id.destroy() end
	end
	storage.lighthouse_night_lights[e.unit_number] = nil
end
-------------------------------------------------------------------------------
-- check every 2 seconds
-------------------------------------------------------------------------------
script.on_nth_tick(20, function()
	if not storage.lighthouse_night_lights then
		return
	end

	for id, data in pairs(storage.lighthouse_night_lights) do
		local lighthouse = data.radar
		if not (lighthouse and lighthouse.valid) then
			if data.render_id and data.render_id.valid then data.render_id.destroy() end
			if data.glow_id and data.glow_id.valid then data.glow_id.destroy() end
			storage.lighthouse_night_lights[id] = nil
		else
			local fluid = lighthouse.fluidbox and lighthouse.fluidbox[1]
			local amount = (fluid and fluid.amount) or 0
			local has_fuel = amount > 0.01

			if has_fuel then
				data.empty_ticks = 0
				local dark = lighthouse.surface.darkness > 0.3

				if not (data.render_id and data.render_id.valid) then
					data.render_id = rendering.draw_light{
						sprite = "utility/light_medium",
						scale = 12.8,
						intensity = 2.1,
						minimum_darkness = 0.3,
						oriented = false,
						color = { r = 1, g = 1, b = 0.75, a = 1 },
						surface = lighthouse.surface,
						target = lighthouse,
						target_offset = { -0.1, 0 },
					}
				end

				if not (data.glow_id and data.glow_id.valid) then
					data.glow_id = rendering.draw_sprite{
						sprite = "lighthouse-glow",
						surface = lighthouse.surface,
						target = {
							lighthouse.position.x + GLOW_OFFSET_X,
							lighthouse.position.y + GLOW_OFFSET_Y,
						},
						x_scale = 0.5,
						y_scale = 0.5,
					}
				end
				if data.glow_id and data.glow_id.valid then
					data.glow_id.visible = dark
				end
			else
				data.empty_ticks = (data.empty_ticks or 0) + 1

				if data.empty_ticks >= 3 then
					if data.render_id and data.render_id.valid then
						data.render_id.destroy()
						data.render_id = nil
					end
					if data.glow_id and data.glow_id.valid then
						data.glow_id.destroy()
						data.glow_id = nil
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
	if not storage then return end
	storage.lighthouse_night_lights = storage.lighthouse_night_lights or {}
	storage.pelagos_diesel_collectors = storage.pelagos_diesel_collectors or {}
end

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

	-- Clean up lamp entities and old render objects from prior implementations.
	for id, data in pairs(storage.lighthouse_night_lights) do
		if data.lamp and data.lamp.valid then data.lamp.destroy() end
		if data.render_id and data.render_id.valid then data.render_id.destroy() end
		if data.glow_id and data.glow_id.valid then data.glow_id.destroy() end
		storage.lighthouse_night_lights[id] = { radar = data.radar, render_id = nil, glow_id = nil }
	end
	for _, surface in pairs(game.surfaces) do
		for _, lamp in pairs(surface.find_entities_filtered({ name = "lighthouse-night-light" })) do
			lamp.destroy()
		end
	end

	if not next(storage.lighthouse_night_lights) then
		for _, surface in pairs(game.surfaces) do
			for _, lighthouse in pairs(surface.find_entities_filtered({ name = "lighthouse" })) do
				storage.lighthouse_night_lights[lighthouse.unit_number] = {
					radar = lighthouse,
					render_id = nil,
					glow_id = nil,
				}
			end
		end
	end
end
script.on_configuration_changed(on_configuration_changed)
-------------------------------------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then return end
	on_entity_built(event)
	on_built_lighthouse(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then return end
	on_entity_built(event)
	on_built_lighthouse(event)
end)

script.on_event(defines.events.on_space_platform_built_entity, function(event)
	local e = event.entity
	if not (e and e.valid) then return end
	on_built_lighthouse(event)
end)

script.on_event(
	{ defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity },
	function(event)
		local e = event.entity
		if not e then return end
		on_removed_lighthouse(event)
	end
)

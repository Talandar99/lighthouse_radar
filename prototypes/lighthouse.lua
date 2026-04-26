local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local hit_effects = require("__base__.prototypes.entity.hit-effects")

data:extend({

	{
		type = "item",
		name = "lighthouse",
		icon = "__lighthouse_radar__/graphics/lighthouse-icon.png",
		subgroup = "defensive-structure",
		order = "d[radar]-a[radar]",
		inventory_move_sound = item_sounds.metal_large_inventory_move,
		pick_sound = item_sounds.metal_large_inventory_pickup,
		drop_sound = item_sounds.metal_large_inventory_move,
		place_result = "lighthouse",
		--default_import_location = "pelagos",
		weight = 1000 * kg,
		stack_size = 50,
		random_tint_color = item_tints.iron_rust,
	},
	{
		type = "recipe",
		name = "lighthouse",
		category = "advanced-crafting",
		enabled = false,
		ingredients = {
			{ type = "item", name = "pipe", amount = 10 },
			{ type = "item", name = "iron-plate", amount = 20 },
			{ type = "item", name = "concrete", amount = 200 },
			--{ type = "item", name = "coconut-sealant", amount = 10 },
		},
		energy_required = 10,
		results = { { type = "item", name = "lighthouse", amount = 1 } },
	},
	{
		type = "radar",
		name = "lighthouse",
		icon = "__lighthouse_radar__/graphics/lighthouse-icon.png",
		flags = { "placeable-player", "player-creation" },
		minable = { mining_time = 0.1, result = "lighthouse" },
		fast_replaceable_group = "radar",
		max_health = 250,
		corpse = "lighthouse-remnants",
		dying_explosion = "radar-explosion",
		resistances = {
			{
				type = "fire",
				percent = 70,
			},
			{
				type = "impact",
				percent = 30,
			},
		},
		--		surface_conditions = {
		--			{
		--				property = "pressure",
		--				min = 300,
		--				max = 1809,
		--			},
		--		},
		collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
		selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
		damaged_trigger_effect = hit_effects.entity(),
		--energy_per_sector = "10MJ",
		energy_per_sector = "1MJ",
		--max_distance_of_sector_revealed = 14,--vanilla
		--max_distance_of_sector_revealed = 36,--maraxsis sonar
		max_distance_of_sector_revealed = 36,
		--max_distance_of_nearby_sector_revealed = 3,--vanilla
		--max_distance_of_nearby_sector_revealed = 6,--maraxsis sonar
		max_distance_of_nearby_sector_revealed = 2,
		energy_per_nearby_scan = "2kJ",
		energy_source = {
			type = "fluid",
			burns_fluid = true, -- fluid used as power
			scale_fluid_usage = true,
			light_flicker = {
				color = { 0, 0, 0, 0 }, -- to remove default burner glow
			},
			fluid_box = {
				--pipe_covers = pipecoverspictures(),
				--pipe_picture = dieselassemblingmachinepipes(),
				pipe_covers = pipecoverspictures(),
				always_draw_covers = false,
				volume = 100,
				pipe_connections = {
					{ direction = defines.direction.west, position = { -1, 0 } },
					{ direction = defines.direction.east, position = { 1, 0 } },
					{ direction = defines.direction.south, position = { 0, 1 } },
					{ direction = defines.direction.north, position = { 0, -1 } },
				},
				production_type = "input",
			},
			-- need to fix position on rotation
			--smoke = {
			--	{
			--		name = "smoke",
			--		frequency = 10,
			--		position = { 0, 0 },
			--		starting_vertical_speed = 0.06, --base 0.08
			--		starting_frame_deviation = 60,
			--	},
			--},
			emissions_per_minute = { pollution = 10 }, --12 is burner drill ,10 is electric drill
		},
		energy_usage = "300kW",
		--integration_patch = {
		--	filename = "__base__/graphics/entity/radar/radar-integration.png",
		--	priority = "low",
		--	width = 238,
		--	height = 216,
		--	shift = util.by_pixel(1.5, 4.0),
		--	scale = 0.5,
		--},
		pictures = {
			layers = {
				{
					filename = "__lighthouse_radar__/graphics/lighthouse.png",
					priority = "low",
					width = 256,
					height = 730,
					apply_projection = false,
					direction_count = 1,
					line_length = 1,
					shift = util.by_pixel(1.0, -130.0),
					scale = 0.5,
					--scale = 0.25,
				},
				{
					filename = "__lighthouse_radar__/graphics/lighthouse_shadow.png",
					priority = "low",
					width = 720,
					height = 256,
					apply_projection = false,
					direction_count = 1,
					line_length = 1,
					shift = util.by_pixel(140, 5.0),
					draw_as_shadow = true,
					scale = 0.5,
				},
				--				{
				--					filename = "__lighthouse_radar__/graphics/lighthouse_light.png",
				--					blend_mode = "additive",
				--					width = 256,
				--					height = 730,
				--					apply_projection = false,
				--					direction_count = 1,
				--					line_length = 1,
				--					shift = util.by_pixel(1.0, -130.0),
				--					draw_as_glow = true,
				--					scale = 0.5,
				--				},
			},
		},
		impact_category = "metal",
		working_sound = {
			sound = {
				filename = "__base__/sound/radar.ogg",
				volume = 0.4,
				modifiers = volume_multiplier("main-menu", 2.0),
			},
			max_sounds_per_prototype = 3,
			use_doppler_shift = false,
		},
		radius_minimap_visualisation_color = { 0.059, 0.092, 0.235, 0.275 },
		rotation_speed = 0.01,
		water_reflection = {
			pictures = {
				filename = "__base__/graphics/entity/radar/radar-reflection.png",
				priority = "extra-high",
				width = 28,
				height = 32,
				shift = util.by_pixel(5, 35),
				variation_count = 1,
				scale = 5,
			},
			rotate = false,
			orientation_to_variation = false,
		},
		is_military_target = false,
		circuit_connector = circuit_connector_definitions["radar"],
		circuit_wire_max_distance = default_circuit_wire_max_distance,
	},
	{
		type = "corpse",
		name = "lighthouse-remnants",
		icon = "__lighthouse_radar__/graphics/lighthouse-icon.png",
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "defensive-structure-remnants",
		order = "a-g-a",
		selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
		tile_width = 3,
		tile_height = 3,
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15, -- 15 minutes
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
		animation = {
			filename = "__lighthouse_radar__/graphics/lighthouse-remnants.png",
			line_length = 1,
			width = 282,
			height = 212,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			scale = 0.5,
		},
	},
})
data:extend({
	{
		type = "lamp",
		name = "lighthouse-night-light",
		icon = "__lighthouse_radar__/graphics/lighthouse-icon.png",
		flags = { "not-on-map" },
		fast_replaceable_group = "lamp",
		--minable = { mining_time = 0.1, result = "small-lamp" },
		max_health = 100,
		corpse = "lamp-remnants",
		dying_explosion = "lamp-explosion",
		--collision_box = { { -0.15, -0.15 }, { 0.15, 0.15 } },
		--selection_box = { { 0, -0.9 }, { 1, 0.1 } },
		damaged_trigger_effect = hit_effects.entity(),
		impact_category = "glass",
		open_sound = { filename = "__base__/sound/open-close/electric-small-open.ogg", volume = 0.7 },
		close_sound = { filename = "__base__/sound/open-close/electric-small-close.ogg", volume = 0.7 },
		energy_source = {
			type = "void",
			--usage_priority = "lamp",
		},
		energy_usage_per_tick = "5kW",
		darkness_for_all_lamps_on = 0.5,
		darkness_for_all_lamps_off = 0.3,
		--light = { intensity = 0.9, size = 40, color = { 1, 1, 0.75 } },
		light = { intensity = 2.1, size = 120, color = { 1, 1, 0.75 } },
		light_when_colored = { intensity = 0, size = 6, color = { 1, 1, 0.75 } },
		--glow_size = 6,
		glow_size = 6,
		glow_color_intensity = 1,
		glow_render_mode = "multiplicative",
		picture_off = {
			layers = {
				{
					filename = "__core__/graphics/empty.png",
					priority = "low",
					width = 1,
					height = 1,
				},
			},
		},
		picture_on = {
			layers = {
				{
					filename = "__lighthouse_radar__/graphics/lighthouse_light.png",
					blend_mode = "additive",
					width = 256,
					height = 730,
					apply_projection = false,
					direction_count = 1,
					line_length = 1,
					--shift = util.by_pixel(1.0, -130.0),
					shift = util.by_pixel(17.0, -146.0),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
		},
		signal_to_color_mapping = {
			{ type = "virtual", name = "signal-red", color = { 1, 0, 0 } },
			{ type = "virtual", name = "signal-green", color = { 0, 1, 0 } },
			{ type = "virtual", name = "signal-blue", color = { 0, 0, 1 } },
			{ type = "virtual", name = "signal-yellow", color = { 1, 1, 0 } },
			{ type = "virtual", name = "signal-pink", color = { 1, 0, 1 } },
			{ type = "virtual", name = "signal-cyan", color = { 0, 1, 1 } },
			{ type = "virtual", name = "signal-white", color = { 1, 1, 1 } },
			{ type = "virtual", name = "signal-grey", color = { 0.5, 0.5, 0.5 } },
			{ type = "virtual", name = "signal-black", color = { 0, 0, 0 } },
		},
		default_red_signal = { type = "virtual", name = "signal-red" },
		default_green_signal = { type = "virtual", name = "signal-green" },
		default_blue_signal = { type = "virtual", name = "signal-blue" },
		default_rgb_signal = { type = "virtual", name = "signal-white" },

		circuit_connector = circuit_connector_definitions["lamp"],
		circuit_wire_max_distance = default_circuit_wire_max_distance,
	},
})
data:extend({
	{
		type = "technology",
		name = "lighthouse",
		icon = "__lighthouse_radar__/graphics/lighthouse-technology.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "lighthouse",
			},
		},
		prerequisites = { "concrete", "radar", "oil-processing" },
		unit = {
			count = 300,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
			},
			time = 30,
		},
	},
})
if mods["cargo-ships"] then
	data:extend({
		{
			type = "technology",
			name = "lighthouse",
			icon = "__lighthouse_radar__/graphics/lighthouse-technology.png",
			icon_size = 256,
			effects = {
				{
					type = "unlock-recipe",
					recipe = "lighthouse",
				},
			},
			prerequisites = { "concrete", "radar", "automated_water_transport" },
			research_trigger = {
				type = "build-entity",
				entity = "indep-boat",
			},
		},
	})
end

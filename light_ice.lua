local function melt(pos)
	minetest.env:set_node(pos, {name="default:water_source"})
end


minetest.register_node("fireballs:lightice", {
	tile_images = {"default_water.png^fireballs_lightice.png"},
	description = "Light Ice",
	groups={snappy=2,choppy=2,oddly_breakable_by_hand=2},
	light_source = 1,
	drop = "default:water_source",
	-- on_construct = function(pos)
	-- 		minetest.after(15, melt, pos)
	-- 	end,
	light_source = 8,
})

minetest.register_abm({
	nodenames = {"fireballs:lightice"},
	interval = 1.0,
	chance = 20,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:set_node(pos, {name = "default:water_source"})
	end,
})
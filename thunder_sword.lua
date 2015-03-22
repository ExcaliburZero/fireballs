-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Normal Thunder    --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_node("fireballs:thunder", {
	description = "Thunder",
	drawtype = "plantlike",
	tiles = {{
		name="fireballs_thunder.png",
	}},
	light_source = 12,
	walkable = false,
	buildable_to = true,
	damage_per_second = 5,
	groups = {dig_immediate=3},
})

minetest.register_abm({
	nodenames = {"fireballs:thunder"},
	interval = 3.0,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:remove_node(pos)
	end,
})

-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Normal Thunderball--
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_entity("fireballs:thunderball", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "fireballs_thunderball.x",
	textures = {"fireballs_thunderball_texture.png"},
	velocity = 8,
	light_source = 2,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
			for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "fireballs:thunderball" and obj:get_luaentity().name ~= "__builtin:item" then
					local speed = vector.length(self.object:getvelocity())
					local damage = ((speed + 5)^1.2)/10
					obj:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						damage_groups={fleshy=damage},
					}, nil)
					self.object:remove()
				end
			end
		end
			--for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			--	if player:is_player() then
			--		self.hit_player(self, player)
			--		self.object:remove()
			--		return
			--	end
			--end
		end,
	hit_player = function(self, player)
		local s = player:getpos()
		local p = player:get_look_dir()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = player:getpos()
		for dx=0,1 do
			for dy=0,1 do
				for dz=0,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="fireballs:thunder"})
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="fireballs:thunder"})
					end
				end
			end
		end
	end
})

minetest.register_tool("fireballs:thundersword", {
	description = "Thunder Sword",
	inventory_image = "fireballs_thundersword.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "fireballs:thunderball")
			local vec = {x=dir.x*3,y=dir.y*3,z=dir.z*3}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 2,
})

minetest.register_craft({
output = "fireballs:thundersword",
recipe = {
{'', 'fireballs:fireball', ''},
{'', 'default:sword_mese', ''},
{'', '', ''},
}
})

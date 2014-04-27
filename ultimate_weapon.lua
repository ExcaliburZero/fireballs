-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Ultimate Weapon   --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_entity("fireballs:ultimate_projectile", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "fireballs_ultimate_weapon.x",
	textures = {"fireballs_ultimate_weapon_texture.png"},
	velocity = 5,
	light_source = 12,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
		end,
	hit_node = function(self, pos, node)
		for dx=-7,7 do
			for dy=-7,7 do
				for dz=-7,7 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(pos).name
					if math.random(1, 100) <= 50 then
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end
})

minetest.register_tool("fireballs:ultimate_weapon", {
	description = "Ultimate Weapon",
	inventory_image = "fireballs_ultimate_weapon.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "fireballs:ultimate_projectile")
			local vec = {x=dir.x*6,y=dir.y*6,z=dir.z*6}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 12,
})

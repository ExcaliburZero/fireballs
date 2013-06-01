-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Normal Fireball   --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_entity("fireballs:fireball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	--textures = {{name="fireballs_fireball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
	textures = {"fireballs_fireball.png"},
	velocity = 5,
	light_source = 12,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
				if player:is_player() then
					self.hit_player(self, player)
					self.object:remove()
					return
				end
			end
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
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
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
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end
})

minetest.register_tool("fireballs:fireball", {
	description = "Fireball",
	inventory_image = "fireballs_fireball.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "fireballs:fireball")
			local vec = {x=dir.x*3,y=dir.y*3,z=dir.z*3}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 12,
})

minetest.register_craft({
output = '"fireballs:fireball" 1',
recipe = {
{'', 'default:torch', ''},
{'', 'default:mese_crystal', ''},
{'', '', ''},
}
})

-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Iceball  -- -- -- --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_entity("fireballs:iceball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	--textures = {{name="fireballs_iceball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
	textures = {"fireballs_iceball.png"},
	velocity = 5,
	light_source = 12,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			end
		end,
	hit_node = function(self, pos, node)
		for dx=-2,1 do
			for dy=-1,1 do
				for dz=-2,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "default:water_source") then
						minetest.env:set_node(p, {name="fireballs:lightice"})
					end
				end
			end
		end
	end
})

minetest.register_tool("fireballs:iceball", {
	description = "Iceball",
	inventory_image = "fireballs_iceball.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "fireballs:iceball")
			local vec = {x=dir.x*3,y=dir.y*3,z=dir.z*3}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 12,
})

minetest.register_craft({
output = '"fireballs:iceball" 1',
recipe = {
{'', 'default:torch', ''},
{'', 'default:mese_crystal', ''},
{'', 'default:torch', ''},
}
})
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- Normal Fireball   --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --

minetest.register_entity("fireballs:fireball", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "fireballs_fireball.x",
	textures = {"fireballs_fireball_texture.png"},
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
output = "fireballs:fireball",
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

local snow_box =
{
	type  = "fixed",
	fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5}
}

-- Snow cover
minetest.register_node("fireballs:snow_cover", {
	tiles = {"weather_snow_cover.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = snow_box,
	selection_box = snow_box,
	groups = {not_in_creative_inventory = 1, crumbly = 3, attached_node = 1},
	drop = {}
})

minetest.register_abm({
	nodenames = {"fireballs:snow_cover"},
	interval = 1.0,
	chance = 20,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:set_node(pos, {name = "default:water_flowing"})
	end,
})

minetest.register_entity("fireballs:iceball", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "fireballs_iceball.x",
	textures = {"fireballs_iceball_texture.png"},
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
		end,
	hit_node = function(self, pos, node)
		for dx=-2,1 do
			for dy=1,-1,-1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					local psub = {x=pos.x+dx, y=pos.y+dy-1, z=pos.z+dz}
					local nsub = minetest.env:get_node(psub).name
					-- if it's water then freeze to light ice or if lava to stone
					-- if it's not water then coat in a layer of snow
					if (n == "default:water_source") then
						minetest.env:set_node(p, {name="fireballs:lightice"})
					elseif (n == "default:water_flowing") then
						minetest.env:set_node(p, {name="air"})
					elseif (n == "default:lava_source") then
						minetest.env:set_node(p, {name="default:stone"})
					elseif (n == "default:lava_flowing") then
						minetest.env:set_node(p, {name="default:stone"})
					elseif (n == "air") and (not (nsub == "air")) and (not (nsub == "fireballs:snow_cover")) then
						minetest.env:add_node(p, {name="fireballs:snow_cover"})
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
			local vec = {x=dir.x*4,y=dir.y*4,z=dir.z*4}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 12,
})

minetest.register_craft({
output = "fireballs:iceball",
recipe = {
{'', 'default:torch', ''},
{'', 'default:mese_crystal', ''},
{'', 'default:torch', ''},
}
})

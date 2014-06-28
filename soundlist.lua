-- preferred data types: .ogg for music, .wav for sound effects
class "Soundlist" {}
music = {
	----example:
	-- music1 = love.audio.newSource("music.ogg")
	music_main = love.audio.newSource("audio/music_main.ogg")
	--, -- next file here
}

soundEffects = {
	-- add official test sound before enabling the line below again
	-- testsound = love.audio.newSource("testsound.wav","static")
	----example:
	-- sound = love.audio.newSource("sound.wav","static")
	--, -- next file here

	cube_appear = love.audio.newSource("audio/cube_appear.wav", "static"),
	cube_rotate = love.audio.newSource("audio/cube_rotate.wav", "static"),

	-- select random on hit
	cube_hit_a2 = love.audio.newSource("audio/cube_hit_a2.wav", "static"),
	cube_hit_a3 = love.audio.newSource("audio/cube_hit_a3.wav", "static"),
	cube_hit_c3 = love.audio.newSource("audio/cube_hit_c3.wav", "static"),
	cube_hit_c4 = love.audio.newSource("audio/cube_hit_c4.wav", "static"),
	cube_hit_d2 = love.audio.newSource("audio/cube_hit_d2.wav", "static"),
	cube_hit_d4 = love.audio.newSource("audio/cube_hit_d4.wav", "static"),
	cube_hit_e2 = love.audio.newSource("audio/cube_hit_e2.wav", "static"),
	cube_hit_e3 = love.audio.newSource("audio/cube_hit_e3.wav", "static"),

	-- select sound depending how many rows have been cleared
	row_clear_1 = love.audio.newSource("audio/row_clear_1.wav", "static"),
	row_clear_2 = love.audio.newSource("audio/row_clear_2.wav", "static"),
	row_clear_3 = love.audio.newSource("audio/row_clear_3.wav", "static"),
	row_clear_4 = love.audio.newSource("audio/row_clear_4.wav", "static"),

	ship_weapon_fire = love.audio.newSource("audio/ship_weapon_fire.wav", "static"),
}

function Soundlist:getMusic(name)
	return music[name]
end

function Soundlist:getSound(name)
	return soundEffects[name]
end

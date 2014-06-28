-- preferred data types: .ogg for music, .wav for sound effects
class "Soundlist" {}
music = {
	----example:
	-- music1 = love.audio.newSource("music.ogg")
	--, -- next file here
}

soundEffects = {
	-- add official test sound before enabling the line below again
	-- testsound = love.audio.newSource("testsound.wav","static")
	----example:
	-- sound = love.audio.newSource("sound.wav","static")
	--, -- next file here
}

function Soundlist:getMusic(name)
	return music[name]
end

function Soundlist:getSound(name)
	return soundEffects[name]
end

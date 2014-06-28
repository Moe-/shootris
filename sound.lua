require('soundlist')
--[[
	example for playing sound effects:	gSound.playSound("testsound",100,-10,5,1)
	"testsound": name in soundlist.lua
	100: volume, 0-100
	-10: x Coordinate: negative values mean that the source is left, positive values mean that it's right
	5: y Coordinate: does (most likely) not do much on a normal 2 speaker system; can be set to 0 or nil or ignored completely if no parameters after this value are used
	1: z Coordinate; see above
--]]

gSound = {}
--------------- background music
-- music functions: play, pause, resume, stop, change volume
function gSound.playMusic(musicName, volume)
		local m = gSound.getMusic(musicName)
	if m then
		gSound.stopMusic("all")
		m:setVolume(volume)
		m:play()
	end
end

function gSound.pauseMusic()
	local m = gSound.getMusic(musicName)
	if m then
		m:pause()
	end
end

function gSound.resumeMusic(musicName)
	local m = gSound.getMusic(musicName)
	if m then
		m:resume()
	end
end

function gSound.stopMusic(musicName)
	if musicName == "all" then
		for _,v in ipairs(gSoundlist.music) do
			gSound.stopMusic(v)
		end
	else
		local m = gSound.getMusic(musicName)
		if m then
			m:stop()
		end
	end
end

function gSound.changeMusicVolume(musicName,newVolume)
	local m = gSound.getMusic(musicName)
	if m then
		m:setVolume(newVolume)
	end
end

function gSound.getMusic(name)
	return gSoundlist.music[name]
end
--------------- sound effects
-- sound effect functions: play, pause(+all), resume, stop(+all)
function gSound.playSound(sound, volume, xCoord, yCoord, zCoord)
	local s = gSound.getSound(sound)
	if s then
		s:setVolume(volume)
		s:setPosition(xCoord or 0,yCoord or 0,zCoord or 0)
		s:play()
	end
end

function gSound.pauseSound()
	local m = gSound.getSound(soundName)
	if m then
		m:pause()
	end
end

function gSound.resumeSound(soundName)
	local m = gSound.getSound(soundName)
	if m then
		m:resume()
	end
end

function gSound.stopSound(soundName)
	if soundName == "all" then
		for _,v in ipairs(gSoundlist.sound) do
			gSound.stopSound(v)
		end
	else
		local m = gSound.getSound(soundName)
		if m then
			m:stop()
		end
	end
end

function gSound.changeSoundVolume(soundName,newVolume)
	local m = gSound.getSound(soundName)
	if m then
		m:setVolume(newVolume)
	end
end

function gSound.getSound(name)
	return gSoundlist.soundEffects[name]
end

require('soundlist')
--[[
	example for playing sound effects:	Sound:playSound("testsound",100,-10,5,1)
	"testsound": name in soundlist.lua
	100: volume, 0-100
	-10: x Coordinate: negative values mean that the source is left, positive values mean that it's right
	5: y Coordinate: does (most likely) not do much on a normal 2 speaker system; can be set to 0 or nil or ignored completely if no parameters after this value are used
	1: z Coordinate; see above
--]]
class "Sound" {
	parent = nil;
}
--------------- background music
-- music functions: play, pause, resume, stop, change volume
function Sound:playMusic(musicName, volume)
		local m = Soundlist:getMusic(musicName)
	if m then
		Sound:stopMusic("all")
		m:setVolume(volume)
		m:play()
	end
end

function Sound:pauseMusic()
	local m = Soundlist:getMusic(musicName)
	if m then
		m:pause()
	end
end

function Sound:resumeMusic(musicName)
	local m = Soundlist:getMusic(musicName)
	if m then
		m:resume()
	end
end

function Sound:stopMusic(musicName)
	if musicName == "all" then
		for _,v in ipairs(Soundlist.music) do
			Sound:stopMusic(v)
		end
	else
		local m = Soundlist:getMusic(musicName)
		if m then
			m:stop()
		end
	end
end

function Sound:changeMusicVolume(musicName,newVolume)
	local m = Soundlist:getMusic(musicName)
	if m then
		m:setVolume(newVolume)
	end
end
--------------- sound effects
-- sound effect functions: play, pause(+all), resume, stop(+all)
function Sound:playSound(sound, volume, xCoord, yCoord, zCoord)
	local s = Soundlist:getSound(sound)
	if s then
		s:setVolume(volume)
		s:setPosition(xCoord or 0,yCoord or 0,zCoord or 0)
		s:play()
	end
end

function Sound:pauseSound()
	local m = Soundlist:getSound(soundName)
	if m then
		m:pause()
	end
end

function Sound:resumeSound(soundName)
	local m = Soundlist:getSound(soundName)
	if m then
		m:resume()
	end
end

function Sound:stopSound(soundName)
	if soundName == "all" then
		for _,v in ipairs(sList.soundEffects) do
			Sound:stopSound(v)
		end
	else
		local m = Soundlist:getSound(soundName)
		if m then
			m:stop()
		end
	end
end

function Sound:changeSoundVolume(soundName,newVolume)
	local m = Soundlist:getSound(soundName)
	if m then
		m:setVolume(newVolume)
	end
end

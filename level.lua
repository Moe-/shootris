class "Level" {
    width = 10;
    height = 10;
}
function Level:__init(x, y, z)
    self.level = {}
end

function Level:print()
    print("bla" .. self.width)
end

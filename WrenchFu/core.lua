--[[
WrenchFu core: base functionality.

]]

if not WrenchFu then WrenchFu = {} end


function WrenchFu.notify_all(msg)
    for _,player in pairs(game.players) do
        player.print(msg)
    end
end

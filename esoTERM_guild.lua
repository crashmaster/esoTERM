esoTERM_guild = {}

local function print_motd_of_guilds()
    for i=1, GetNumGuilds() do
        local guild_id = GetGuildId(i)
        local guild_name = GetGuildName(guild_id)
        local guild_motd = GetGuildMotD(guild_id)
        esoTERM_output.stdout(string.format("%s: %s", guild_name, guild_motd))
    end
end

CALLBACK_MANAGER:RegisterCallback("esoTERMModulesInitialized", print_motd_of_guilds)

return esoTERM_guild

esoTERM_guild = {}

local function print_motd_of_guilds()
    for i=1, GetNumGuilds() do
        local guild_id = GetGuildId(i)
        esoTERM_output.stdout(string.format("%s: %s",
                                            GetGuildName(guild_id),
                                            GetGuildMotD(guild_id)))
    end
end

CALLBACK_MANAGER:RegisterCallback("esoTERMModulesInitialized", print_motd_of_guilds)

return esoTERM_guild

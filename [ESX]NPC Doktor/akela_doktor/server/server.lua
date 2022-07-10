ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('akela_doktor:basla')
AddEventHandler('akela_doktor:basla', function(cost)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canSwapItem('cash', cost, 'cash', cost) then
		TriggerClientEvent('esx_ambulancejob:revive', source)
		xPlayer.removeMoney(cost)
		dclog(xPlayer, cost..'$ ödeyerek tedavi oldu')
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Geçmiş olsun!'})
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Üzerinde yeterli nakit yok!'})
	end
end)


function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
  
    local discord_webhook = "https://discord.com/api/webhooks/988794341688508426/gwe9xPoMijh5q7ChWdtlJmdWPdZBB524lxtdF2EgALTRotbgQ1TB5Y6qh8Ra_knFzu0k"
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = "Moon Logger - Npc Doktor Log",
      ["avatar_url"] = "https://i.hizliresim.com/9jnonmu.png",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName .. ' - ' .. xPlayer.identifier
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end
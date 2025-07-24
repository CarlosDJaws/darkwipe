-- client.lua
-- This script's only job is to receive messages from the server and display them in chat.

-- This event receives the message from the server.
RegisterNetEvent('darkwipe:client:ShowMessage')
AddEventHandler('darkwipe:client:ShowMessage', function(message)
    -- We use the built-in chat event to display the message.
    -- This allows for better formatting, like adding a sender name and color.
    TriggerEvent('chat:addMessage', {
        -- The color is a light blue (RGB).
        color = { 0, 150, 255 }, 
        multiline = true,
        -- The args are {sender, message}.
        args = { "[SERVER]", message } 
    })
end)
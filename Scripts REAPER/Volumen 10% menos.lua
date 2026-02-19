-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- Recorrer todos los ítems
for i = 0, num_items - 1 do
    local item = reaper.GetMediaItem(0, i)

    if item then
        -- Establecer volumen del ítem al 10% (0.1)
        reaper.SetMediaItemInfo_Value(item, "D_VOL", 0.1)
    end
end

-- Actualizar la vista
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Reducir amplitud de todos los ítems al 10%",
    -1
)


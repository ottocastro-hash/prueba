-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener el número total de ítems en el proyecto
local num_items = reaper.CountMediaItems(0)

-- Recorrer todos los ítems
for i = 0, num_items - 1 do
    local item = reaper.GetMediaItem(0, i)

    if item then
        -- Obtener la posición actual del ítem
        local posicion_actual = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

        -- Calcular el 50% de la posición
        local nueva_posicion = posicion_actual * 0.5

        -- Establecer la nueva posición
        reaper.SetMediaItemInfo_Value(item, "D_POSITION", nueva_posicion)
    end
end

-- Actualizar la vista del proyecto
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock("Mover cada ítem al 50% de su posición", -1)


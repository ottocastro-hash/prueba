-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- Recorrer todos los ítems
for i = 0, num_items - 1 do
    local item = reaper.GetMediaItem(0, i)

    if item then
        -- Posición actual del ítem (en segundos)
        local posicion_actual = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

        -- Nueva posición comprimida al 50%
        local nueva_posicion = posicion_actual * 0.5

        -- Asignar nueva posición
        reaper.SetMediaItemInfo_Value(item, "D_POSITION", nueva_posicion)
    end
end

-- Actualizar la vista del proyecto
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Comprimir posiciones de todos los ítems al 50%",
    -1
)


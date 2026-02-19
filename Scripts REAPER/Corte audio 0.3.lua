-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Parámetros
local segmento = 0.3
local fade_in = 0.2
local fade_out = 0.2

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- IMPORTANTE: recorrer de atrás hacia adelante
for i = num_items - 1, 0, -1 do
    local item = reaper.GetMediaItem(0, i)

    if item then
        local posicion = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local duracion = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local fin = posicion + duracion

        local tiempo_split = posicion + segmento
        local item_actual = item

        -- Dividir en segmentos de 0.3 s
        while tiempo_split < fin do
            item_actual = reaper.SplitMediaItem(item_actual, tiempo_split)
            tiempo_split = tiempo_split + segmento
        end
    end
end

-- Volver a obtener todos los ítems (ya divididos)
local total_items = reaper.CountMediaItems(0)

-- Aplicar fades a todos los fragmentos
for i = 0, total_items - 1 do
    local item = reaper.GetMediaItem(0, i)
    if item then
        reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fade_in)
        reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fade_out)
    end
end

-- Actualizar la vista
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Dividir ítems en segmentos de 0.3 s con fade in/out de 0.2 s",
    -1
)


-- Inicializar generador aleatorio
math.randomseed(os.time())

-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener posición inicial (cursor de edición)
local posicion_actual = reaper.GetCursorPosition()

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- Tabla para almacenar ítems y sus duraciones
local items = {}

-- Recolectar ítems
for i = 0, num_items - 1 do
    local item = reaper.GetMediaItem(0, i)
    if item then
        local duracion = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        table.insert(items, {item = item, length = duracion})
    end
end

-- Ordenar ítems de menor a mayor duración
table.sort(items, function(a, b)
    return a.length < b.length
end)

-- Reposicionar ítems ordenados
for i = 1, #items do
    local item = items[i].item
    local duracion = items[i].length

    -- Establecer posición del ítem
    reaper.SetMediaItemInfo_Value(item, "D_POSITION", posicion_actual)

    -- Calcular separación aleatoria entre 0.3 y 0.5 segundos
    local separacion = 0.3 + (math.random() * (0.5 - 0.3))

    -- Avanzar la posición para el siguiente ítem
    posicion_actual = posicion_actual + duracion + separacion
end

-- Actualizar la vista
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Ordenar ítems por duración (menor a mayor) con separación 0.3–0.5 s",
    -1
)


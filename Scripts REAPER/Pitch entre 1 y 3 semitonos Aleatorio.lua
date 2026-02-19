-- Inicializar generador de números aleatorios
math.randomseed(os.time())

-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- Recorrer todos los ítems
for i = 0, num_items - 1 do
    local item = reaper.GetMediaItem(0, i)
    if item then
        -- Obtener el take activo
        local take = reaper.GetActiveTake(item)

        -- Verificar que exista y que sea un take de audio
        if take and not reaper.TakeIsMIDI(take) then
            -- Generar pitch aleatorio entre 1 y 3 semitonos
            local pitch_aleatorio = 1.0 + (math.random() * (3.0 - 1.0))

            -- Asignar el pitch al take (en semitonos)
            reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", pitch_aleatorio)
        end
    end
end

-- Actualizar la vista
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Asignar pitch aleatorio (1 a 3 semitonos) a cada ítem de audio",
    -1
)


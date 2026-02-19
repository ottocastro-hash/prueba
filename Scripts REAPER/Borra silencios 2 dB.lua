-- Tamaño de bloque para análisis de audio
local BLOCK_SIZE = 1024

-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener número total de ítems
local num_items = reaper.CountMediaItems(0)

-- Recorrer ítems de atrás hacia adelante (seguro para borrar)
for i = num_items - 1, 0, -1 do
    local item = reaper.GetMediaItem(0, i)

    if item then
        local take = reaper.GetActiveTake(item)

        -- Solo analizar takes de audio
        if take and not reaper.TakeIsMIDI(take) then
            local src = reaper.GetMediaItemTake_Source(take)
            local samplerate = reaper.GetMediaSourceSampleRate(src)
            local channels = reaper.GetMediaSourceNumChannels(src)
            local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

            local max_peak = 0.0
            local sample_pos = 0.0

            -- Analizar todo el ítem
            while sample_pos < length do
                local retval, peaks = reaper.GetMediaItemTake_Peaks(
                    take,
                    samplerate,
                    sample_pos,
                    BLOCK_SIZE,
                    channels,
                    0
                )

                if retval > 0 and peaks then
                    for j = 1, #peaks do
                        local val = math.abs(peaks[j])
                        if val > max_peak then
                            max_peak = val
                        end
                    end
                end

                sample_pos = sample_pos + (BLOCK_SIZE / samplerate)
            end

            -- Si el ítem es completamente silencioso, eliminar
            if max_peak == 0 then
                reaper.DeleteTrackMediaItem(
                    reaper.GetMediaItemTrack(item),
                    item
                )
            end
        end
    end
end

-- Actualizar vista
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock(
    "Eliminar ítems completamente silenciosos",
    -1
)


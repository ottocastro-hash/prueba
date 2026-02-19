-- Inicializar el generador de números aleatorios
math.randomseed(os.time())

-- Iniciar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener el número total de pistas
local num_tracks = reaper.CountTracks(0)

-- Recorrer todas las pistas
for i = 0, num_tracks - 1 do
    local track = reaper.GetTrack(0, i)

    if track then
        -- Generar pitch aleatorio entre 0.3 y 3 semitonos
        local pitch_aleatorio = 0.3 + (math.random() * (3.0 - 0.3))

        -- Asignar el pitch a la pista (en semitonos)
        reaper.SetMediaTrackInfo_Value(track, "D_PITCH", pitch_aleatorio)
    end
end

-- Actualizar la interfaz
reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock("Asignar pitch aleatorio (0.3 a 3 semitonos) a cada pista", -1)


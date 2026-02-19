-- Inicializar el generador de números aleatorios
math.randomseed(os.time())

-- Comenzar bloque de undo
reaper.Undo_BeginBlock()

-- Obtener el número total de pistas
local num_tracks = reaper.CountTracks(0)

-- Recorrer todas las pistas
for i = 0, num_tracks - 1 do
    local track = reaper.GetTrack(0, i)

    if track then
        -- Generar paneo aleatorio entre -1.0 y 1.0
        local pan_aleatorio = (math.random() * 2) - 1

        -- Establecer el paneo de la pista
        reaper.SetMediaTrackInfo_Value(track, "D_PAN", pan_aleatorio)
    end
end

-- Actualizar la vista
reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()

-- Finalizar bloque de undo
reaper.Undo_EndBlock("Asignar paneo aleatorio a cada pista", -1)


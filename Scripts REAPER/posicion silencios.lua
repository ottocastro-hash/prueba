-- Distribuir ítems aleatoriamente con silencios entre 0.4 y 2 segundos
-- Entorno: REAPER

reaper.Undo_BeginBlock()

-- Parámetros de silencio (segundos)
local SILENCE_MIN = 0.4
local SILENCE_MAX = 2.0

-- Obtener pista seleccionada
local track = reaper.GetSelectedTrack(0, 0)
if not track then
  reaper.ShowMessageBox("No hay ninguna pista seleccionada.", "Error", 0)
  return
end

-- Obtener ítems de la pista
local items = {}
local item_count = reaper.CountTrackMediaItems(track)

if item_count < 2 then
  reaper.ShowMessageBox("La pista debe contener al menos dos ítems.", "Aviso", 0)
  return
end

local start_pos = math.huge

for i = 0, item_count - 1 do
  local item = reaper.GetTrackMediaItem(track, i)
  local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

  table.insert(items, {
    item = item,
    length = len
  })

  start_pos = math.min(start_pos, pos)
end

-- Inicializar aleatoriedad
math.randomseed(os.time())

-- Barajar ítems (Fisher-Yates)
for i = #items, 2, -1 do
  local j = math.random(i)
  items[i], items[j] = items[j], items[i]
end

-- Colocar ítems con silencios aleatorios
local current_pos = start_pos

for i, data in ipairs(items) do
  reaper.SetMediaItemInfo_Value(data.item, "D_POSITION", current_pos)
  current_pos = current_pos + data.length

  -- Agregar silencio excepto después del último ítem
  if i < #items then
    local silence = SILENCE_MIN + math.random() * (SILENCE_MAX - SILENCE_MIN)
    current_pos = current_pos + silence
  end
end

reaper.UpdateArrange()
reaper.Undo_EndBlock("Distribuir ítems aleatoriamente con silencios", -1)


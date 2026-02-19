-- Distribuir ítems de forma aleatoria en la pista seleccionada
-- Autor: Script genérico LUA para REAPER

reaper.Undo_BeginBlock()

-- Obtener la pista seleccionada
local track = reaper.GetSelectedTrack(0, 0)
if not track then
  reaper.ShowMessageBox("No hay ninguna pista seleccionada.", "Error", 0)
  return
end

-- Obtener todos los ítems de la pista
local items = {}
local item_count = reaper.CountTrackMediaItems(track)

if item_count < 2 then
  reaper.ShowMessageBox("La pista debe contener al menos dos ítems.", "Aviso", 0)
  return
end

local min_pos = math.huge
local max_pos = 0

for i = 0, item_count - 1 do
  local item = reaper.GetTrackMediaItem(track, i)
  local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

  table.insert(items, {item = item, length = len})

  min_pos = math.min(min_pos, pos)
  max_pos = math.max(max_pos, pos + len)
end

-- Generador aleatorio
math.randomseed(os.time())

-- Reasignar posiciones aleatorias
local current_pos = min_pos

-- Barajar ítems
for i = #items, 2, -1 do
  local j = math.random(i)
  items[i], items[j] = items[j], items[i]
end

-- Colocar ítems
for _, data in ipairs(items) do
  reaper.SetMediaItemInfo_Value(data.item, "D_POSITION", current_pos)
  current_pos = current_pos + data.length
end

reaper.UpdateArrange()
reaper.Undo_EndBlock("Distribuir ítems aleatoriamente en la pista", -1)


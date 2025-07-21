local PLUGIN = PLUGIN

-- Загружаем деревья после инициализации мира
function PLUGIN:LoadData()
    local data = self:GetData() or {}
    for _, treeData in ipairs(data) do
        local tree = ents.Create("ix_tree")
        if IsValid(tree) then
            tree:SetPos(treeData.pos)
            tree:SetAngles(treeData.ang)
            tree.stage = treeData.stage or 3 -- если нет stage, считать взрослым
            tree:Spawn()
            tree:SetStage(tree.stage)
        end
    end
end

-- Сохраняем деревья на сервере
function PLUGIN:SaveData()
    local data = {}
    for _, ent in ipairs(ents.FindByClass("ix_tree")) do
        if IsValid(ent) and not ent._forceDelete then
            table.insert(data, {
                pos = ent:GetPos(),
                ang = ent:GetAngles(),
                stage = ent.stage or 3
            })
        end
    end

    self:SetData(data)
end

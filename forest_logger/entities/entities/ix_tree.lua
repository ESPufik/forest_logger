AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Дерево"
ENT.Category = "Лесоруб"
ENT.Spawnable = true

-- Модели для разных стадий дерева
local treeModels = {
    [0] = "models/props_forest/tree_pine_stump02.mdl",                          -- пень
    [1] = "models/props_foliage/tree_deciduous_01a-lod.mdl",                    -- маленькое дерево
    [2] = "models/props_foliage/tree_dead03.mdl",                               -- среднее дерево
    [3] = "models/props_foliage/tree_dead01.mdl"                                -- большое дерево
}

-- Регистрация сетевых строк только на сервере
if SERVER then
    util.AddNetworkString("ixLumber_StartProgress")
    util.AddNetworkString("ixLumber_EndProgress")
end

if SERVER then
    function ENT:Initialize()
        self:SetUseType(CONTINUOUS_USE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self.usingPlayers = {}

        self.stage = self.stage or 1  -- Изначально начинается с маленького дерева
        self:SetStage(self.stage)
    end

    function ENT:SetStage(stage)
        self.stage = stage
        self:SetModel(treeModels[stage])
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        -- Таймеры для смены стадий
        if stage == 0 then
            -- Пень → маленькое дерево через 60 сек
            timer.Simple(60, function()
                if IsValid(self) then
                    self:SetStage(1)
                end
            end)
        elseif stage == 1 then
            -- Маленькое → среднее через 30 сек
            timer.Simple(30, function()
                if IsValid(self) then
                    self:SetStage(2)
                end
            end)
        elseif stage == 2 then
            -- Среднее → большое через 30 сек
            timer.Simple(30, function()
                if IsValid(self) then
                    self:SetStage(3)
                end
            end)
        end
    end

    function ENT:Use(ply)
        -- Если дерево еще не взрослое, нельзя его срубить
        if self.stage < 3 then
            ply:Notify("Это дерево ещё не выросло.")
            return
        end

        if self.usingPlayers[ply] then return end

        local char = ply:GetCharacter()
        if not char then return end

        if not char:GetInventory():HasItem("axe") then
            ply:Notify("У вас нет топора.")
            return
        end

        self.usingPlayers[ply] = true

        net.Start("ixLumber_StartProgress")
        net.WriteFloat(7)  -- Прогресс рубки: 7 секунд
        net.Send(ply)

        local id = "ixLumber_Timer_" .. self:EntIndex() .. "_" .. ply:EntIndex()

        timer.Create(id, 7, 1, function()
            if not IsValid(self) or not IsValid(ply) then return end
            if not ply:KeyDown(IN_USE) then
                self.usingPlayers[ply] = nil
                net.Start("ixLumber_EndProgress")
                net.Send(ply)
                return
            end

            local inv = char:GetInventory()
            if inv:Add("log") then
                ply:Notify("Вы получили брёвна.")
            else
                ix.item.Spawn("log", self:GetPos() + Vector(0, 0, 40))
            end

            self:EmitSound("physics/wood/wood_crate_break2.wav")
            net.Start("ixLumber_EndProgress")
            net.Send(ply)

            self.usingPlayers[ply] = nil

            local pos, ang = self:GetPos(), self:GetAngles()
            self._forceDelete = true
            self:Remove()

            -- Спавним пень сразу
            local stump = ents.Create("ix_tree")
            if IsValid(stump) then
                stump:SetPos(pos)
                stump:SetAngles(ang)
                stump.stage = 0  -- Пень
                stump:Spawn()
                stump:SetStage(0)
            end
        end)
    end

    function ENT:Think()
        -- Отслеживаем состояние удержания E (если игрок отпускает)
        for ply, _ in pairs(self.usingPlayers) do
            if not IsValid(ply) or not ply:KeyDown(IN_USE) then
                self.usingPlayers[ply] = nil
                net.Start("ixLumber_EndProgress")
                net.Send(ply)

                local id = "ixLumber_Timer_" .. self:EntIndex() .. "_" .. ply:EntIndex()
                timer.Remove(id)
            end
        end

        self:NextThink(CurTime() + 0.1)
        return true
    end
end

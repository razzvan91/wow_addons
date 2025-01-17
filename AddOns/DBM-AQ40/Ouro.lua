local mod	= DBM:NewMod("Ouro", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200626182941")
mod:SetCreatureID(15517)
mod:SetEncounterID(716)
mod:SetModelID(15509)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 26615",
	"SPELL_CAST_START 26102 26103",
	"SPELL_SUMMON 26058",
	"UNIT_HEALTH mouseover target"
)

local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", 3, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnEmerge		= mod:NewAnnounce("WarnEmerge", 3, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnSweep			= mod:NewSpellAnnounce(26103, 2, nil, "Tank", 2)
local warnBerserk		= mod:NewSpellAnnounce(26615, 3)
local warnBerserkSoon	= mod:NewSoonAnnounce(26615, 2)

local specWarnBlast		= mod:NewSpecialWarningSpell(26102, nil, nil, nil, 2, 2)

--local timerSubmerge		= mod:NewTimer(30, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, nil, 6)
local timerEmerge		= mod:NewTimer(30, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)
local timerSweepCD		= mod:NewNextTimer(20.5, 26103, nil, "Tank", 2, 5, nil, DBM_CORE_L.TANK_ICON)
local timerBlastCD		= mod:NewNextTimer(23, 26102, nil, nil, nil, 2)

mod.vb.prewarn_Berserk = false
mod.vb.Berserked = false

function mod:OnCombatStart(delay)
	self.vb.prewarn_Berserk = false
	self.vb.Berserked = false
end

function mod:Emerge()
	warnEmerge:Show()
end

do
	local Berserk = DBM:GetSpellInfo(26615)
	function mod:SPELL_AURA_APPLIED(args)
		--if args.spellId == 26615 then
		if args.spellName == Berserk and args:IsDestTypeHostile() then
			self.vb.Berserked = true
			warnBerserk:Show()
		end
	end
end

do
	local SandBlast, Sweep = DBM:GetSpellInfo(26102), DBM:GetSpellInfo(26103)
	function mod:SPELL_CAST_START(args)
		--if args.spellId == 26102 then
		if args.spellName == SandBlast then
			specWarnBlast:Show()
			specWarnBlast:Play("stunsoon")
			timerBlastCD:Start()
		--elseif args.spellId == 26103 then
		elseif args.spellName == Sweep and args:IsSrcTypeHostile() then
			warnSweep:Show()
			timerSweepCD:Start()
		end
	end
end

do
	local SummonOuroMounds = DBM:GetSpellInfo(26058)
	function mod:SPELL_SUMMON(args)
		--if args.spellId == 26058 and self:AntiSpam(3) and not self.vb.Berserked then
		if args.spellName == SummonOuroMounds and self:AntiSpam(3) and not self.vb.Berserked then
			timerBlastCD:Stop()
			timerSweepCD:Stop()
			warnSubmerge:Show()
			timerEmerge:Start()
			self:ScheduleMethod(30, "Emerge")
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 15517 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.23 and not self.vb.prewarn_Berserk then
		self.vb.prewarn_Berserk = true
		warnBerserkSoon:Show()
	end
end

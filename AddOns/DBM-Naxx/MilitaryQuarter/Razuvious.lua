local mod	= DBM:NewMod("Razuvious", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200626182941")
mod:SetCreatureID(16061)
mod:SetEncounterID(1113)
mod:SetModelID(16582)
mod:RegisterCombat("combat_yell", L.Yell1, L.Yell2, L.Yell3, L.Yell4)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 55543 29107 29060 29061"
)

--TODO, find out if args:IsPetSource() actually works, or find something else that does
local warnShoutNow		= mod:NewSpellAnnounce(29107, 1)
local warnShoutSoon		= mod:NewSoonAnnounce(29107, 3)
local warnShieldWall	= mod:NewAnnounce("WarningShieldWallSoon", 3, 29061)

local timerShout		= mod:NewNextTimer(16, 29107, nil, nil, nil, 2)
local timerTaunt		= mod:NewCDTimer(20, 29060, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON)
local timerShieldWall	= mod:NewCDTimer(20, 29061, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON)

function mod:OnCombatStart(delay)
	timerShout:Start(16 - delay)
	warnShoutSoon:Schedule(11 - delay)
end

do
	local DisruptingShout, Taunt, ShieldWall = DBM:GetSpellInfo(29107), DBM:GetSpellInfo(29060), DBM:GetSpellInfo(29061)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args:IsSpellID(29107, 55543) then  -- Disrupting Shout
		if args.spellName == DisruptingShout and args:IsPetSource() then--What does an MCed unit return?
			timerShout:Start()
			warnShoutNow:Show()
			warnShoutSoon:Schedule(11)
		--elseif args.spellId == 29060 then -- Taunt
		elseif args.spellName == Taunt and args:IsPetSource() then
			timerTaunt:Start()
		--elseif args.spellId == 29061 then -- ShieldWall
		elseif args.spellName == ShieldWall and args:IsPetSource() then
			timerShieldWall:Start()
			warnShieldWall:Schedule(15)
		end
	end
end


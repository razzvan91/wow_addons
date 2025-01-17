local mod	= DBM:NewMod("Garr-Classic", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200626182941")
mod:SetCreatureID(12057)--, 12099
mod:SetEncounterID(666)
mod:SetModelID(12110)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 15732",
	"SPELL_CAST_SUCCESS 19492"
)

--[[
ability.id = 19492 and type = "cast"
--]]
local warnAntiMagicPulse	= mod:NewSpellAnnounce(19492, 2)
local warnImmolate			= mod:NewTargetNoFilterAnnounce(15732, 2, nil, false, 3)--Still feels spammy, they can opt into this if they want it

local timerAntiMagicPulseCD	= mod:NewCDTimer(15.7, 19492, nil, nil, nil, 2)--15.7-20 variation

function mod:OnCombatStart(delay)
	timerAntiMagicPulseCD:Start(10-delay)
end

do
	local ImmolateSpell = DBM:GetSpellInfo(15732)
	function mod:SPELL_AURA_APPLIED(args)
		--if args.spellId == 15732 and self:IsInCombat() then
		if args.spellName == ImmolateSpell and args:IsDestTypePlayer() then
			warnImmolate:CombinedShow(1, args.destName)
		end
	end
end

do
	local AntiMagicPulse = DBM:GetSpellInfo(19492)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 19492 then
		if args.spellName == AntiMagicPulse then
			warnAntiMagicPulse:Show()
			timerAntiMagicPulseCD:Start()
		end
	end
end

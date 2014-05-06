--[[
					Leo The Great
					Written by Austin
					This is my first script.  Tell me if you can see things that I should add.  :)
					v0.01
					Let me know how I'm doing and what I could change and stuff.  Thanks. :)
					#OnTheRoadToDev
]]
if myHero.charName ~= "Leona" then return end

local ts
local qRange = 150
local eRange = 875
local rRange = 1200
local rDelay = 0.625
local aRange = 125
local eDelay = 0
local exRange = 550
local targetdistance = 0
	
function OnLoad()
	LeoConfig = scriptConfig("Amazing Leo", "Leo");
	LeoConfig:addSubMenu("Combo Settings", "Combo")
	LeoConfig.Combo:addParam("ScriptActive", "Combo Activate", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	LeoConfig.Combo:addParam("useQ", "Stun", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Combo:addParam("useW", "Shield", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Combo:addParam("useE", "Dash", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Combo:addParam("useR", "Ult", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Combo:addParam("useEx", "Exhaust", SCRIPT_PARAM_ONOFF, false)
	LeoConfig.Combo:addParam("mouse", "Move to mouse", SCRIPT_PARAM_ONOFF, true)
	
	LeoConfig:addSubMenu("Harass In Lane", "Harass")
	LeoConfig.Harass:addParam("HarassActive", "Use Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	LeoConfig.Harass:addParam("harQ", "Stun", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Harass:addParam("harW", "Shield", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Harass:addParam("harE", "Dash", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Harass:addParam("harR", "Ulti", SCRIPT_PARAM_ONOFF, false)
	LeoConfig.Harass:addParam("harEx", "Exhaust", SCRIPT_PARAM_ONOFF, false)
	LeoConfig.Harass:addParam("hmouse", "Move to mouse", SCRIPT_PARAM_ONOFF, true)
	
	LeoConfig:addSubMenu("Extras", "Extras")
	LeoConfig.Extras:addParam("ECircles", "Draw Circle for E", SCRIPT_PARAM_ONOFF, true)
	LeoConfig.Extras:addParam("RCircles", "Draw Circle for R", SCRIPT_PARAM_ONOFF, true)
	

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,1200,DAMAGE_MAGIC)
	ts.name = "Leona"
	ts.targetSelected = true
	LeoConfig:addTS(ts)
		PrintChat("Amazing Leo by Austin loaded! V0.01");
	if myHero:GetSpellData(SUMMONER_1).name == "Summoner" then exhaust = SUMMONER_1
		elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then exhaust = SUMMONER_2
end
end

function OnTick()
	ts:update()
	
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	if LeoConfig.Combo.ScriptActive then TeamFight() end
	if LeoConfig.Harass.HarassActive then Harass() end
end

function TeamFight()		

		if ts.target ~= nil then 
			targetdistance = GetDistance(ts.target)
			if WREADY and LeoConfig.Combo.useW then CastSpell(_W) end
			
			if EREADY and LeoConfig.Combo.useE and targetdistance<= eRange and targetdistance >= qRange then
				EPred = GetPredictionPos(ts.target, eDelay)
				if EPred then CastSpell(_E, EPred.x, EPred.z)end 
			end		
			
			if QREADY and LeoConfig.Combo.useQ and targetdistance<=qRange then 
				CastSpell(_Q)
				myHero:Attack(ts.target) 
			end
		
		if RREADY and LeoConfig.Combo.useR and targetdistance<=rRange then
			RPred = GetPredictionPos(ts.target, rDelay)
			if RPred then CastSpell(_R, RPred.x, RPred.z)end
		end
		if LeoConfig.Combo.mouse then myHero:MoveTo(mousePos.x, mousePos.z) end
		if exhaust and LeoConfig.Harass.useEx and targetdistance<= exRange then CastSpell(exhaust, target) end

	end
end
function Harass()
	if ts.target ~= nil then
		targetdistance = GetDistance(ts.target)
		if WREADY and LeoConfig.Harass.harW then CastSpell(_W) end
		
		if EREADY and LeoConfig.Harass.harE then
			EPred = GetPredictionPos(ts.target, eDelay)
			if EPred then CastSpell(_E, EPred.x, EPred.z) end
		end
		
		if QREADY and LeoConfig.Harass.harQ then 
			CastSpell(_Q) 
			myHero:Attack(ts.target) 
		end
		
		if RREADY and LeoConfig.Harass.harR and targetdistance<=rRange and GetDistance(ts.target, EPred) <= 50 then
			RPred = GetPredictionPos(ts.target, rDelay)
			if RPred then CastSpell(_R, RPred.x, RPred.z) end
		end
		if LeoConfig.Harass.hmouse then	myHero:MoveTo(mousePos.x, mousePos.z) end
		if exhaust and LeoConfig.Harass.harEx and targetdistance <= exRange then CastSpell(exhaust, target) end
	end	
end	
	
function OnDraw()
	if LeoConfig.Extras.ECircles and EREADY then DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0xFFFF00) end
	if LeoConfig.Extras.RCircles and RREADY then DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0xFF0000) end
end

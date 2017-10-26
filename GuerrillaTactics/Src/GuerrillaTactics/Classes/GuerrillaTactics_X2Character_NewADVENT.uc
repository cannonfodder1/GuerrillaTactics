class GuerrillaTactics_X2Character_NewADVENT extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
	// watch this space...
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreateTemplate_AdvRifleman());
	Templates.AddItem(CreateTemplate_AdvGunner());
	Templates.AddItem(CreateTemplate_AdvCaptain());
	Templates.AddItem(CreateTemplate_AdvMedic());
	Templates.AddItem(CreateTemplate_AdvLancer());
	Templates.AddItem(CreateTemplate_AdvSharpshooter());
	Templates.AddItem(CreateTemplate_AdvBreacher());
	Templates.AddItem(CreateTemplate_AdvRiotTrooper());
	return Templates;
}


static function X2CharacterTemplate CreateTemplate_AdvRifleman()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvRifleman');
	CharTemplate.CharacterGroupName = 'AdventRifleman';
	CharTemplate.DefaultLoadout='AdvRifleman_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM3_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvRifleman_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvLancer()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvLancer');
	CharTemplate.CharacterGroupName = 'AdventLancer';
	CharTemplate.DefaultLoadout='AdvLancer_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvLancer_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}




static function X2CharacterTemplate CreateTemplate_AdvSharpshooter()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvSharpshooter');
	CharTemplate.CharacterGroupName = 'AdventSharpshooter';
	CharTemplate.DefaultLoadout='AdvSharpshooter_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvSharpshooter_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvGunner()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvGunner');
	CharTemplate.CharacterGroupName = 'AdventGunner';
	CharTemplate.DefaultLoadout='AdvGunner_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM2_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvGunner_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvMedic()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvMedic');
	CharTemplate.CharacterGroupName = 'AdventMedic';
	CharTemplate.DefaultLoadout='AdvMedic_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvMedic_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM3');
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCaptain');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptain_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM1_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptain_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM3');
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


simulated function string GetAdventMatineePrefix(XComGameState_Unit UnitState)
{
	if(UnitState.kAppearance.iGender == eGender_Male)
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Male";
	}
	else
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Female";
	}
}


static function X2CharacterTemplate CreateTemplate_AdvBreacher()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvBreacher');
	CharTemplate.CharacterGroupName = 'AdventBreacher';
	CharTemplate.DefaultLoadout='AdvBreacher_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvBreacher_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvShieldBearerM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('EnergyShield');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvShieldBearerM2');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvRiotTrooper()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvRiotTrooper');
	CharTemplate.CharacterGroupName = 'AdventRiotTrooper';
	CharTemplate.DefaultLoadout='AdvRiotTrooper_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvRiotTrooper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvShieldBearerM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('EnergyShield');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvShieldBearerM2');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

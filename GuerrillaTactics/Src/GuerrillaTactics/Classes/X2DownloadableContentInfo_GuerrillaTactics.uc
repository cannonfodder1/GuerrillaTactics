class X2DownloadableContentInfo_GuerrillaTactics extends X2DownloadableContentInfo
	config(Game);

static event OnPostTemplatesCreated()
{
	`log("GuerrillaTactics :: Present and Correct");

	class'GuerrillaTactics_WeaponManager'.static.LoadWeaponProfiles();
	class'GuerrillaTactics_WeaponManager'.static.LoadArmorProfiles();
	class'GuerrillaTactics_CharacterManager'.static.UpdateCharacterProfiles();

	class'GuerrillaTactics_ScrubMissionManager'.static.ScrubInclusionExclusionLists();
	class'GuerrillaTactics_ScrubMissionManager'.static.ReplaceConfigurableEncounterSpawns();
}

static event InstallNewCampaign(XComGameState StartState)
{
	local XComGameState_Unit NewSoldierState;	
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_GameTime GameTime;

	assert( StartState != none);

	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}	
	
	foreach StartState.IterateByClassType(class'XComGameState_GameTime', GameTime)
	{
		break;
	}

	assert( GameTime != none );
	
	NewSoldierState = `CHARACTERPOOLMGR.CreateCharacter(StartState, XComOnlineProfileSettings(class'Engine'.static.GetEngine().GetProfileSettings()).Data.m_eCharPoolUsage);
	
	NewSoldierState.RandomizeStats();
	NewSoldierState.ApplyInventoryLoadout(StartState);
	NewSoldierState.bIsFamous = true;

	NewSoldierState.SetHQLocation(eSoldierLoc_Barracks);

	XComHQ.AddToCrew(StartState, NewSoldierState);
	NewSoldierState.m_RecruitDate = GameTime.CurrentTime; // AddToCrew does this, but during start state creation the StrategyRuleset hasn't been created yet

	XComHQ.Squad.RemoveItem(XComHQ.Squad[3]); // 3 is faction soldier in non legendary playthrough
	XComHQ.Squad.AddItem(NewSoldierState.GetReference());
}

static function ChainAbilityTag()
{
  local XComEngine Engine;
  local GuerrillaTactics_X2AbilityTag AbilityTag;
  local X2AbilityTag OldAbilityTag;
  local int idx;

  Engine = `XENGINE;

  OldAbilityTag = Engine.AbilityTag;

  AbilityTag = new class'GuerrillaTactics_X2AbilityTag';
  AbilityTag.WrappedTag = OldAbilityTag;

  idx = Engine.LocalizeContext.LocalizeTags.Find(Engine.AbilityTag);
  Engine.AbilityTag = AbilityTag;
  Engine.LocalizeContext.LocalizeTags[idx] = AbilityTag;
}

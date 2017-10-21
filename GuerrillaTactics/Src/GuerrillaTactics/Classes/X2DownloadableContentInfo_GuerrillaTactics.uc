class X2DownloadableContentInfo_GuerrillaTactics extends X2DownloadableContentInfo
	config(Game);

static event OnPostTemplatesCreated()
{
	`log("GuerrillaTactics :: Present and Correct");

	class'GuerrillaTactics_WeaponManager'.static.LoadWeaponProfiles();
	class'GuerrillaTactics_WeaponManager'.static.LoadArmorProfiles();
	class'GuerrillaTactics_CharacterManager'.static.UpdateCharacterProfiles();
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

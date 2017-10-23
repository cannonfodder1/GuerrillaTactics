class GuerrillaTactics_WeaponManager extends Object
	config(GWWeapons);

enum eGT_FireMode
{
	eGT_FireMode_Aimed,
	eGT_FireMode_Snap,
	eGT_FireMode_Volume,
};

struct GuerrillaTacticsGrazeProfile
{
	var int High;
	var int Low;
	var int Open; // for units that don't take cover
	var int Flanked;

	structdefaultproperties
	{
		High = -1;
		Low = -1;
		Open = -1;
		Flanked = -1;
	}
};

struct GuerrillaTacticsShotProfile
{
	var int ShotCount;
	var int SuppressionPenalty;
	var int AimModifier;
	var int CritModifier;
	var GuerrillaTacticsGrazeProfile GrazeModifier;
};

struct GuerrillaTacticsWeaponProfile
{
	var name WeaponName;
	var int iClipSize;
	var WeaponDamageValue BulletProfile;
	var int OverwatchAimModifier;
	var GuerrillaTacticsGrazeProfile DefaultGrazeModifier;
	var GuerrillaTacticsShotProfile Aimed;
	var GuerrillaTacticsShotProfile Snap;
	var GuerrillaTacticsShotProfile Volume;
};

struct GuerrillaTacticsArmorProfile
{
	var name ArmorName;
	var name ArmorAbilityName;
	var int HP;
	var int ArmorChance;
	var int ArmorMitigation;
	var int Dodge;
	var int Mobility;
};

var config array<GuerrillaTacticsWeaponProfile>		arrWeaponProfiles;
var config array<GuerrillaTacticsArmorProfile>		arrArmorProfiles;


static function GuerrillaTacticsWeaponProfile GetWeaponProfile(
  name WeaponName
)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  foreach default.arrWeaponProfiles(WeaponProfile)
  {
    if (WeaponProfile.WeaponName == WeaponName)
    {
      return WeaponProfile;
    }
  }
}


static function int GetShotCount(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Snap.ShotCount;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Aimed.ShotCount;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Volume.ShotCount;
  }
  return 0;
}


static function int GetOverwatchAimModifier(name WeaponName)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);
  return WeaponProfile.OverwatchAimModifier;
}


static function int GetAimModifier(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Snap.AimModifier;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Aimed.AimModifier;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Volume.AimModifier;
  }
  return 0;
}


static function int GetCritModifier(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Snap.CritModifier;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Aimed.CritModifier;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Volume.CritModifier;
  }
  return 0;
}


static function int GetSuppressionPenalty(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Snap.SuppressionPenalty;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Aimed.SuppressionPenalty;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Volume.SuppressionPenalty;
  }
  return 0;
}


static function GuerrillaTacticsGrazeProfile GetGrazeProfile(
  name WeaponName, name AbilityName
)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;
  local GuerrillaTacticsGrazeProfile IdealGrazeProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (AbilityName)
  {
    case 'GT_SnapShot':
    case 'GT_SnapFollowShot':
    IdealGrazeProfile = WeaponProfile.Snap.GrazeModifier;
    break;

    case 'GT_AimedShot':
    case 'GT_AimedFollowShot':
    IdealGrazeProfile = WeaponProfile.Aimed.GrazeModifier;
    break;

    case 'GT_VolumeShot':
    case 'GT_VolumeFollowShot':
    IdealGrazeProfile = WeaponProfile.Volume.GrazeModifier;
    break;
  }

  if (IdealGrazeProfile.High == -1)
  {
    return WeaponProfile.DefaultGrazeModifier;
  }
  else
  {
    return IdealGrazeProfile;
  }
}


static function LoadWeaponProfiles ()
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;
  local array<X2DataTemplate> ItemTemplates;
  local X2DataTemplate ItemTemplate;
  local X2WeaponTemplate WeaponTemplate;
  local X2ItemTemplateManager Manager;

  Manager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

  foreach default.arrWeaponProfiles(WeaponProfile)
  {
    ItemTemplates.Length = 0;
    Manager.FindDataTemplateAllDifficulties(WeaponProfile.WeaponName, ItemTemplates);
    foreach ItemTemplates(ItemTemplate)
    {
      WeaponTemplate = X2WeaponTemplate(ItemTemplate);
      WeaponTemplate.BaseDamage = WeaponProfile.BulletProfile;
      WeaponTemplate.iClipSize = WeaponProfile.iClipSize;

      WeaponTemplate.Abilities.RemoveItem('StandardShot');
      WeaponTemplate.Abilities.RemoveItem('SniperStandardFire');
      WeaponTemplate.Abilities.AddItem('GT_AmbientSuppressionCancel');

      WeaponTemplate.Abilities.RemoveItem('Overwatch');
      WeaponTemplate.Abilities.RemoveItem('OverwatchShot');
      WeaponTemplate.Abilities.RemoveItem('SniperRifleOverwatch');

      WeaponTemplate.Abilities.AddItem('GT_OverwatchSnap');
      WeaponTemplate.Abilities.AddItem('GT_OverwatchSnapShot');
      WeaponTemplate.Abilities.AddItem('GT_OverwatchSnapFollowShot');

      if (WeaponProfile.DefaultGrazeModifier.High != -1)
      {
        WeaponTemplate.Abilities.AddItem('GT_WeaponConditionalGraze');
      }

      if (WeaponProfile.Aimed.ShotCount > 0)
      {
        WeaponTemplate.Abilities.AddItem('GT_AimedShot');
        WeaponTemplate.Abilities.AddItem('GT_AimedFollowShot');
      }

      if (WeaponProfile.Snap.ShotCount > 0)
      {
        WeaponTemplate.Abilities.AddItem('GT_SnapShot');
        WeaponTemplate.Abilities.AddItem('GT_SnapFollowShot');
      }

      if (WeaponProfile.Volume.ShotCount > 0)
      {
        WeaponTemplate.Abilities.AddItem('GT_VolumeShot');
        WeaponTemplate.Abilities.AddItem('GT_VolumeFollowShot');
      }
    }
  }
}


static function LoadArmorProfiles ()
{
  local array<X2DataTemplate> ItemTemplates;
  local array<X2AbilityTemplate> AbilityTemplates;
  local X2DataTemplate ItemTemplate;
  local X2ArmorTemplate ArmorTemplate;
  local X2AbilityTemplate AbilityTemplate;
  local X2AbilityTemplateManager AbilityManager;
  local GuerrillaTacticsArmorProfile ArmorProfile;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
  local X2ItemTemplateManager Manager;

  AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
  Manager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

  ItemTemplates.Length = 0;
  Manager.FindDataTemplateAllDifficulties('KevlarArmor', ItemTemplates);
  foreach ItemTemplates(ItemTemplate)
  {
    ArmorTemplate = X2ArmorTemplate(ItemTemplate);
    ArmorTemplate.Abilities.AddItem('KevlarArmorStats');
  }

  foreach default.arrArmorProfiles(ArmorProfile)
  {
    ItemTemplates.Length = 0;
    Manager.FindDataTemplateAllDifficulties(ArmorProfile.ArmorName, ItemTemplates);
    foreach ItemTemplates(ItemTemplate)
    {
      ArmorTemplate = X2ArmorTemplate(ItemTemplate);
      ArmorTemplate.UIStatMarkups.Length = 0;

      if (ArmorProfile.HP != 0)
      {
        ArmorTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, ArmorProfile.HP, true);
      }
      
      if (ArmorProfile.Mobility != 0)
      {
        ArmorTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, ArmorProfile.Mobility);
      }

      if (ArmorProfile.Dodge != 0) {
        ArmorTemplate.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, ArmorProfile.Dodge);
      }
    }

    AbilityTemplates.Length = 0;
    AbilityManager.FindAbilityTemplateAllDifficulties(ArmorProfile.ArmorAbilityName, AbilityTemplates);
    foreach AbilityTemplates(AbilityTemplate)
    {
      AbilityTemplate.AbilityTargetEffects.Length = 0;

      PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
      PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);

      if (ArmorProfile.ArmorChance != 0)
      {
        PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, ArmorProfile.ArmorChance);
      }

      if (ArmorProfile.ArmorMitigation != 0)
      {
        PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, ArmorProfile.ArmorMitigation);
      }

      if (ArmorProfile.HP != 0)
      {
        PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, ArmorProfile.HP);
      }
      
      if (ArmorProfile.Mobility != 0)
      {
        PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, ArmorProfile.Mobility);
      }

      if (ArmorProfile.Dodge != 0) {
        PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, ArmorProfile.Dodge);
      }

      AbilityTemplate.AddTargetEffect(PersistentStatChangeEffect);
    }
  }
}

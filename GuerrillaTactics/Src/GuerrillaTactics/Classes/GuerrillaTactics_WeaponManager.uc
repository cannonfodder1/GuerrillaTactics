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
	var int SuppressionPower;
	var int SuppressionRadius;
	var float Recoil;
	// 1,6,11,16,21,26,31,36,41,46 - ranges in array, fall off with modifier after range
	var array<int> Aim;
	var array<int> Crit;
	var GuerrillaTacticsGrazeProfile GrazeModifier;

	structdefaultproperties
	{
		SuppressionRadius = 1;
	}
};

struct GuerrillaTacticsWeaponProfile
{
	var name WeaponName;
	var int iClipSize;
	var WeaponDamageValue BulletProfile;
	var bool DontLoadAbilities;
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

static function float GetRecoil(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Recoil;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Recoil;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Recoil;
  }
  return 0;
}


static function int GetOverwatchAimModifier(name WeaponName)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);
  return WeaponProfile.OverwatchAimModifier;
}


static function int GetAimModifier(name WeaponName, eGT_FireMode FireMode, int Range)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;
	local Array<int> AimList;
	local int TileIndex;
	local int BaseMod, InterpGap;
	local float TileFloat, TileInterp;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    AimList = WeaponProfile.Snap.Aim;
		break;

    case eGT_FireMode_Aimed:
    AimList = WeaponProfile.Aimed.Aim;
		break;
    
    case eGT_FireMode_Volume:
    AimList = WeaponProfile.Volume.Aim;
		break;
  }

	TileFloat = Range / 5.0;
	TileInterp = TileFloat % 1.0;
	TileIndex = TileFloat;

	if (TileIndex < AimList.Length) {
		BaseMod = AimList[TileIndex];
		if (TileIndex + 1 < AimList.Length) {
			InterpGap = AimList[TileIndex] - AimList[TileIndex + 1];
			return Round(BaseMod + (InterpGap * TileInterp));
		} else {
			return BaseMod;
		}
	} else {
		return AimList[AimList.Length - 1];
	}

  return 0;
}


static function int GetCritModifier(name WeaponName, eGT_FireMode FireMode, int Range)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;
	local Array<int> CritList;
	local int TileIndex;
	local int BaseMod, InterpGap;
	local float TileFloat, TileInterp;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    CritList = WeaponProfile.Snap.Crit;
		break;

    case eGT_FireMode_Aimed:
    CritList = WeaponProfile.Aimed.Crit;
		break;
    
    case eGT_FireMode_Volume:
    CritList = WeaponProfile.Volume.Crit;
		break;
  }

	TileFloat = Range / 5.0;
	TileInterp = TileFloat % 1.0;
	TileIndex = TileFloat;

	if (TileIndex < CritList.Length) {
		BaseMod = CritList[TileIndex];
		if (TileIndex + 1 < CritList.Length) {
			InterpGap = CritList[TileIndex] - CritList[TileIndex + 1];
			return Round(BaseMod + (InterpGap * TileInterp));
		} else {
			return BaseMod;
		}
	} else {
		return CritList[CritList.Length - 1];
	}

  return 0;
}


static function int GetSuppressionPower(name WeaponName, eGT_FireMode FireMode)
{
  local GuerrillaTacticsWeaponProfile WeaponProfile;

  WeaponProfile = GetWeaponProfile(WeaponName);

  switch (FireMode)
  {
    case eGT_FireMode_Snap:
    return WeaponProfile.Snap.SuppressionPower;

    case eGT_FireMode_Aimed:
    return WeaponProfile.Aimed.SuppressionPower;
    
    case eGT_FireMode_Volume:
    return WeaponProfile.Volume.SuppressionPower;
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

			if (!WeaponProfile.DontLoadAbilities)
			{
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

class GuerrillaTactics_X2Item_AdventWeaponry extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue SMG_MAGNETIC_BASEDAMAGE;

var config int SMG_MAGNETIC_AIM;
var config int SMG_MAGNETIC_CRITCHANCE;
var config int SMG_MAGNETIC_ICLIPSIZE;
var config int SMG_MAGNETIC_ISOUNDRANGE;
var config int SMG_MAGNETIC_IENVIRONMENTDAMAGE;
var config int SMG_MAGNETIC_ISUPPLIES;
var config int SMG_MAGNETIC_TRADINGPOSTVALUE;
var config int SMG_MAGNETIC_IPOINTS;

var config array<int> MIDSHORT_MAGNETIC_RANGE;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

  Weapons.AddItem(CreateTemplate_AssaultRifle_Advent());
  Weapons.AddItem(CreateTemplate_Pistol_Advent());
  Weapons.AddItem(CreateTemplate_SMG_Advent());
  Weapons.AddItem(CreateTemplate_SniperRifle_Advent());
  Weapons.AddItem(CreateTemplate_Cannon_Advent());
  Weapons.AddItem(CreateTemplate_Shotgun_Advent());
  Weapons.AddItem(CreateTemplate_PsiAmp_Advent());
  Weapons.AddItem(CreateTemplate_Sword_Advent());

  Weapons.AddItem(CreateTemplate_AdvGrenadeLauncher_Advent());
  Weapons.AddItem(CreateTemplate_GremlinDrone_Advent());

	return Weapons;
}


static function X2DataTemplate CreateTemplate_AssaultRifle_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AssaultRifle_Advent');
	Template.WeaponPanelImage = "_MagneticRifle";              
  // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "NewAdventWeapons.WP_AssaultRifle_MG_Advent";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	Template.iPhysicsImpulse = 5;
	
	//Template.UpgradeItem = 'AssaultRifle_Advent_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}


static function X2DataTemplate CreateTemplate_SniperRifle_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SniperRifle_Advent');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvSniperRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;
	Template.iTypicalActionCost = 2;

	Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NewAdventWeapons.WP_SniperRifle_Long_MG_Advent";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}


static function X2DataTemplate CreateTemplate_Pistol_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_Advent');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NewAdventWeapons.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;
		
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_Advent');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvShotgun";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.SHOTGUN_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NewAdventWeapons.WP_Shotgun_MG_Advent";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_Advent');
	Template.WeaponPanelImage = "_MagneticCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NewAdventWeapons.WP_Cannon_MG_Advent";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Sword_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sword_Advent');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvStunBaton";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Adv_StunLancer.WP_StunLance";
	Template.Tier = 2;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE));

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE);
		
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	return Template;
}

static function X2DataTemplate CreateTemplate_PsiAmp_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PsiAmp_Advent');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.DamageTypeTemplateName = 'Psi';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvPsiAmp";
	Template.EquipSound = "Psi_Amp_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.Tier = 2;
	// This all the resources; sounds, animations, models, physics, the works.
	
	Template.GameArchetype = "WP_PsiAmp_MG.WP_PsiAmp_MG_Advent";

	Template.Abilities.AddItem('PsiAmpMG_BonusStats');

	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.PSIAMPT2_ABILITYDAMAGE;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, class'X2Ability_ItemGrantedAbilitySet'.default.PSIAMP_MG_STATBONUS);
		
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_Advent');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvSMG";     
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 2;

	/* Template.Abilities.AddItem('SMG_MG_Advent_StatBonus'); */
	/* Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_SMGAbilities'.default.SMG_MAGNETIC_MOBILITY_BONUS); */

	Template.RangeAccuracy = default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.SMG_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.SMG_MAGNETIC_AIM;
	Template.CritChance = default.SMG_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.SMG_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.SMG_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	// TODO : update for SMG Magnetic model and default attachments
	Template.GameArchetype = "NewAdventWeapons.WP_SMG_MG_Advent";

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';
		
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	return Template;
}


static function X2GrenadeLauncherTemplate CreateTemplate_AdvGrenadeLauncher_Advent()
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'GrenadeLauncher_Advent');

	Template.strImage = "img:///NewAdventWeapons.UI_AdvGrenadeLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 18;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 1;

	Template.IncreaseGrenadeRadius = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_RADIUSBONUS;
	Template.IncreaseGrenadeRange = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_RANGEBONUS;

	Template.GameArchetype = "NewAdventWeapons.WP_GrenadeLauncher_MG_Advent";

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_RANGEBONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_RADIUSBONUS);
		
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';

	return Template;
}

static function X2DataTemplate CreateTemplate_GremlinDrone_Advent()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'Gremlin_Advent');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///NewAdventWeapons.UI_AdvGremlinT2";
	Template.EquipSound = "Gremlin_Equip";

	Template.CosmeticUnitTemplate = "GremlinAdvent";
	Template.Tier = 2;

	Template.ExtraDamage = class'X2Item_DefaultWeapons'.default.GREMLINMK2_ABILITYDAMAGE;
	Template.HackingAttemptBonus = class'X2Item_DefaultWeapons'.default.GREMLINMK2_HACKBONUS;
	Template.AidProtocolBonus = 10;
	Template.HealingBonus = 1;
	Template.BaseDamage.Damage = 4;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor

	Template.iRange = 2;
	Template.iRadius = 40;              //  only for scanning protocol
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, class'X2Item_DefaultWeapons'.default.GREMLINMK2_HACKBONUS);

	return Template;
}

class GuerrillaTactics_X2Ability_StandardShooting extends X2Ability;

var localized string SuppressionTargetEffectName;
var localized string SuppressionTargetEffectDesc;
var localized string OverwatchFlyover;


static function array<X2DataTemplate> CreateTemplates()
{
  local array<X2DataTemplate> Templates;

  // Aimed and Snap shot are implemented exactly like burst and auto
  // the finalize is normally triggered by follow ups determining that they shouldn't trigger
  // this leaves us with two choices -- trigger the finalize in the first step (currently done)
  // or add follow ups for every ability, that don't ever trigger
  // this makes two more abilities, so that's not ideal
  AddShotPair(Templates, 'GT_AimedShot', 'GT_AimedFollowShot', 2, eGT_FireMode_Aimed);
  AddShotPair(Templates, 'GT_SnapShot', 'GT_SnapFollowShot', 1, eGT_FireMode_Snap);
  AddShotPair(Templates, 'GT_VolumeShot', 'GT_VolumeFollowShot', 2, eGT_FireMode_Volume);

  AddShotPair(Templates, 'GT_OverwatchSnapShot', 'GT_OverwatchSnapFollowShot', 1, eGT_FireMode_Snap, true);

  Templates.AddItem(AmbientSuppressionCancel());
  Templates.AddItem(AddAnimationAbility());
  Templates.AddItem(WeaponConditionalGraze());

  return Templates;
}


static function AddShotPair(
  out array<X2DataTemplate> Templates,
  name TriggerAbilityName,
  name FollowUpAbilityName,
  int AbilityCost,
  eGT_FireMode FireMode,
  bool bOverwatch = false
)
{
  local X2AbilityTemplate Template;
  class'GuerrillaTactics_AbilityManager'.static.RegisterAbilityPair(
    TriggerAbilityName, FollowUpAbilityName, FireMode, bOverwatch
  );

  Template = AddShotType(TriggerAbilityName, AbilityCost, FireMode, bOverwatch);
  if (FollowUpAbilityName != '')
  {
		Template.PostActivationEvents.AddItem(FollowUpAbilityName);
  }
  else
  {
		Template.PostActivationEvents.AddItem('GT_FinaliseAnimation');
  }
  Templates.AddItem(Template);

  if (FollowUpAbilityName != '')
  {
		Template = AddFollowShot(FollowUpAbilityName, FireMode, bOverwatch);
		Templates.AddItem(Template);
  }

  if (bOverwatch)
  {
    Template = AddOverwatchAbility(
      FireMode == eGT_FireMode_Snap ? 'GT_OverwatchSnap' : 'GT_OverwatchVolume',
      TriggerAbilityName,
      FireMode
    );
    Templates.AddItem(Template);
  }
}


static function X2AbilityTemplate WeaponConditionalGraze()
{
	local X2AbilityTemplate						Template;
	local GuerrillaTactics_X2Effect_ConditionalGraze	GrazeEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'GT_WeaponConditionalGraze');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	GrazeEffect = new class'GuerrillaTactics_X2Effect_ConditionalGraze';
	GrazeEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(GrazeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate AmbientSuppressionCancel() {
  local X2AbilityTemplate                 Template;	
  local array<name>                       SkipExclusions;

	local X2AbilityTrigger_Event	        Trigger;

	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveEffects            RemoveSuppression;

  // Macro to do localisation and stuffs
  `CREATE_X2ABILITY_TEMPLATE(Template, 'GT_AmbientSuppressionCancel');

  // Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

  SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
  SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
  Template.AddShooterEffectExclusions(SkipExclusions);

  // Targeting Details
  // Can only shoot visible enemies
  // Can't target dead; Can't target friendlies
  Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
  // Can't shoot while dead
  Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
  // Only at single targets that are in range.
  Template.AbilityTargetStyle = default.SimpleSingleTarget;


	//Trigger on movement - interrupt the move
    // TODO: this skips one tile movements, since they don't have an interrupt step
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(class'GuerrillaTactics_X2Effect_AmbientSuppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

	RemoveSuppression = new class'X2Effect_RemoveEffects';
	RemoveSuppression.EffectNamesToRemove.AddItem(class'GuerrillaTactics_X2Effect_AmbientSuppression'.default.EffectName);
	RemoveSuppression.bCheckSource = true;
	RemoveSuppression.SetupEffectOnShotContextResult(true, true);
	Template.AddShooterEffect(RemoveSuppression);

  // MAKE IT LIVE!
  Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
  Template.BuildVisualizationFn = NoOpVisualisation;
  Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

  Template.bDisplayInUITooltip = false;
  Template.bDisplayInUITacticalText = false;

  return Template;	
}


simulated function NoOpVisualisation(XComGameState VisualizeGameState)
{
}


static function X2AbilityTemplate AddShotType(
  name AbilityName,
  int AbilityCost,
  eGT_FireMode FireMode,
  bool bOverwatch
)
{
  local X2AbilityTemplate                 Template;	
  local GuerrillaTactics_X2AbilityCost_BurstAmmoCost  AmmoCost;
  local X2AbilityCost_ActionPoints        ActionPointCost;
  local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
  local array<name>                       SkipExclusions;
  local X2AbilityTrigger_Event            EventTrigger;
  local X2Effect_Knockback				KnockbackEffect;
  local GuerrillaTactics_X2Effect_AmbientSuppression SuppressionEffect;
  local X2Condition_Visibility            VisibilityCondition;
  local GuerrillaTactics_X2AbilityToHitCalc_StandardAim    ToHitCalc;

  // Macro to do localisation and stuffs
  `CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

  // Icon Properties
  Template.bDontDisplayInAbilitySummary = true;

  switch (FireMode)
  {
    case eGT_FireMode_Volume:
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_blindfire";
    break;

    case eGT_FireMode_Aimed:
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_snipershot";
    break;

    case eGT_FireMode_Snap:
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
    break;

    default:
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
    break;
  }
  Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
  Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
  Template.DisplayTargetHitChance = true;
  Template.AbilitySourceName = 'eAbilitySource_Standard';    // color of the icon
  // Activated by a button press; additionally, tells the AI this is an activatable
  
  if (bOverwatch)
  {
    EventTrigger = new class'X2AbilityTrigger_Event';
    EventTrigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
    EventTrigger.MethodName = 'InterruptGameState';
    Template.AbilityTriggers.AddItem(EventTrigger);
  }
  else
  {
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
  }

  SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
  SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
  Template.AddShooterEffectExclusions(SkipExclusions);

  // Targeting Details
  // Can only shoot visible enemies
  VisibilityCondition = new class'X2Condition_Visibility';
  VisibilityCondition.bRequireGameplayVisible = true;

  if (bOverwatch)
  {
    VisibilityCondition.bDisablePeeksOnMovement = true;
  }
  else
  {
    VisibilityCondition.bAllowSquadsight = true;
  }

  Template.AbilityTargetConditions.AddItem(VisibilityCondition);

  if (bOverwatch)
  {
    Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
    Template.AbilityTargetConditions.AddItem(
      class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition()
    );
  }


  // Can't target dead; Can't target friendlies
  Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
  // Can't shoot while dead
  Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
  // Only at single targets that are in range.
  Template.AbilityTargetStyle = default.SimpleSingleTarget;

  // Action Point
  if (bOverwatch)
  {
    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
    ReserveActionPointCost.AllowedTypes.AddItem('returnfire');
    Template.AbilityCosts.AddItem(ReserveActionPointCost);
  }
  else
  {
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = AbilityCost;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);	
  }

  // Ammo
  AmmoCost = new class'GuerrillaTactics_X2AbilityCost_BurstAmmoCost';	
  AmmoCost.FireMode = FireMode;
  Template.AbilityCosts.AddItem(AmmoCost);
  Template.bAllowAmmoEffects = true;
  Template.bAllowBonusWeaponEffects = true;

  // Weapon Upgrade Compatibility
  Template.bAllowFreeFireWeaponUpgrade = !bOverwatch;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

  //  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
  Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
  //  Various Soldier ability specific effects - effects check for the ability before applying	
  Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
  Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Damage Effect
	/* WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage'; */
	/* Template.AddTargetEffect(WeaponDamageEffect); */

  if (!bOverwatch)
  {
    SuppressionEffect = new class'GuerrillaTactics_X2Effect_AmbientSuppression';
    SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    SuppressionEffect.bRemoveWhenTargetDies = true;
    SuppressionEffect.FireMode = FireMode;
    SuppressionEffect.bApplyOnMiss = true;
    SuppressionEffect.bApplyOnHit = true;
    SuppressionEffect.bRemoveWhenSourceDamaged = false;
    SuppressionEffect.bBringRemoveVisualizationForward = true;
    SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, default.SuppressionTargetEffectName, default.SuppressionTargetEffectDesc, Template.IconImage);
    /* SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.SuppressionSourceEffectDesc, Template.IconImage); */
    Template.AddTargetEffect(SuppressionEffect);
  }

  ToHitCalc = new class'GuerrillaTactics_X2AbilityToHitCalc_StandardAim';
  ToHitCalc.FireMode = FireMode;
  if (bOverwatch) { ToHitCalc.bReactionFire = true; }
  Template.AbilityToHitCalc = ToHitCalc;
  Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
  // this was wrong -- only used for visualization
  // Template.bIsASuppressionEffect = true;

  Template.AssociatedPassives.AddItem('HoloTargeting');
  // Targeting Method
  if (bOverwatch)
  {
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.DisplayTargetHitChance = false;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    /* Template.BuildVisualizationFn = FirstShot_BuildVisualization; */
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
  }
  else
  {
    Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
    Template.bUsesFiringCamera = true;
    Template.CinescriptCameraType = "StandardGunFiring";	

    // MAKE IT LIVE!
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    /* Template.BuildVisualizationFn = FirstShot_BuildVisualization; */
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.PostActivationEvents.AddItem('StandardShotActivated');
  }

  KnockbackEffect = new class'X2Effect_Knockback';
  KnockbackEffect.KnockbackDistance = 2;
  Template.AddTargetEffect(KnockbackEffect);
  Template.DamagePreviewFn = FireDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;


  return Template;	
}


static function X2AbilityTemplate AddFollowShot(
  name AbilityName,
  eGT_FireMode FireMode,
  bool bOverwatch
)
{
  local X2AbilityTemplate                 Template;	
  local array<name>                       SkipExclusions;
  local X2Effect_Knockback				KnockbackEffect;
  local X2Condition_Visibility            VisibilityCondition;
  local X2AbilityTrigger_EventListener  Trigger;
	local GuerrillaTactics_X2AbilityToHitCalc_StandardAim    ToHitCalc;

  // Macro to do localisation and stuffs
  `CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

  // Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

  SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
  SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
  Template.AddShooterEffectExclusions(SkipExclusions);

  // Targeting Details
  // Can only shoot visible enemies
  VisibilityCondition = new class'X2Condition_Visibility';
  VisibilityCondition.bRequireGameplayVisible = true;
  VisibilityCondition.bAllowSquadsight = true;
  Template.AbilityTargetConditions.AddItem(VisibilityCondition);
  // Can't target dead; Can't target friendlies
  // Can't shoot while dead
  Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
  // Only at single targets that are in range.
  Template.AbilityTargetStyle = default.SimpleSingleTarget;

  Template.bAllowAmmoEffects = true;
  Template.bAllowBonusWeaponEffects = true;
  Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

  //  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
  //  Various Soldier ability specific effects - effects check for the ability before applying
  Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = AbilityName;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = MultiShotListener;
	Template.AbilityTriggers.AddItem(Trigger);

	ToHitCalc = new class'GuerrillaTactics_X2AbilityToHitCalc_StandardAim';
  if (bOverwatch) { ToHitCalc.bReactionFire = true; }
  ToHitCalc.FireMode = FireMode;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

  // MAKE IT LIVE!
  Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
  Template.BuildVisualizationFn = FollowShot_BuildVisualization;
  Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

  Template.bDisplayInUITooltip = false;
  Template.bDisplayInUITacticalText = false;

/* follow up shots don't use cinescript
   this may sound like a bad limitation, but is a reasonable (tm) compromise
   cinescript doesn't even survive multiple blocks, and using no cinescript here prevents hastic camera movement
  Template.bUsesFiringCamera = true;
  Template.CinescriptCameraType = "StandardGunFiring";	
*/

  KnockbackEffect = new class'X2Effect_Knockback';
  KnockbackEffect.KnockbackDistance = 2;
  Template.AddTargetEffect(KnockbackEffect);
  Template.DamagePreviewFn = FireDamagePreview;

  Template.PostActivationEvents.AddItem(AbilityName);

  return Template;	
}


simulated function FollowShot_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata ShadowMetaData, CosmeticUnitMetaData;
	local XComGameState_Unit ShadowUnit, ShadowbindTargetUnit, TargetUnitState, CosmeticUnit;
	local UnitValue ShadowUnitValue;
	local X2Effect_SpawnShadowbindUnit SpawnShadowEffect;
	local int j;
	local name SpawnShadowEffectResult;
	local X2Action_Fire SourceFire;
	local X2Action_MoveBegin SourceMoveBegin;
	local Actor SourceUnit;
	local array<X2Action> TransformStopParents;
	local VisualizationActionMetadata SourceMetaData, TargetMetaData;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_EnterCover EnterCoverAction;
	local XComGameState_Item ItemState;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	ExitCoverAction = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', , Context.InputContext.PrimaryTarget.ObjectID));
	VisMgr.DestroyAction(ExitCoverAction, true);
	EnterCoverAction = X2Action_EnterCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_EnterCover', , Context.InputContext.PrimaryTarget.ObjectID));
	VisMgr.DestroyAction(EnterCoverAction, true);
}


static function X2AbilityTemplate AddOverwatchAbility(
  name AbilityName,
  name ShotName,
  eGT_FireMode FireMode
)
{
	local X2AbilityTemplate                 Template;	
	local GuerrillaTactics_X2AbilityCost_BurstAmmoCost                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	
	Template.bDontDisplayInAbilitySummary = true;

  AmmoCost = new class'GuerrillaTactics_X2AbilityCost_BurstAmmoCost';	
  AmmoCost.FireMode = FireMode;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
  Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	/* SuppressedCondition = new class'X2Condition_UnitEffects'; */
	/* SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed'); */
	/* Template.AbilityShooterConditions.AddItem(SuppressedCondition); */
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = ShotName;
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	/* Template.HideIfAvailable.AddItem('LongWatch'); */
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
  Template.LocFlyOverText = default.OverwatchFlyover;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	return Template;	
}


static function EventListenerReturn SingleShotListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
  local XComGameState_Unit Shooter;
	local XComGameState_Ability Ability, ShotAbility;
  local XComGameStateHistory History;

  History = `XCOMHISTORY;
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
    Ability = XComGameState_Ability(
      History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)
    );
    Shooter = XComGameState_Unit(
      History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID)
    );
    ShotAbility = XComGameState_Ability(
      History.GetGameStateForObjectID(Shooter.FindAbility('GT_FinaliseAnimation').ObjectID)
    );

    ShotAbility.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false);
	}
	return ELR_NoInterrupt;
}



static function EventListenerReturn MultiShotListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
  local XComGameStateContext_Ability AbilityContext;
  local int iMaxShots, iShotIndex, iTakenShots, iDummyTotalShots;
  local AbilityRelation Relation;
  local XComGameStateHistory History;
  local XComGameState_Ability ShotAbility;
  local XComGameState_Unit Shooter;

  AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

  if (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
  {
    return ELR_NoInterrupt;
  }

  if (!class'GuerrillaTactics_AbilityManager'.static.GetEventChainInfo(AbilityContext, iShotIndex, iMaxShots, iDummyTotalShots, Relation))
  {
    // failsafe if the ability is not in a follow-up chain. shouldn't happen, but you never know...
    return ELR_NoInterrupt;
  }

  History = `XCOMHISTORY;
  Shooter = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

  iTakenShots = iShotIndex + 1;
  if (iTakenShots < iMaxShots)
  {
		`log("Triggering shot " $ (iTakenShots + 1) $ "/" $ iMaxShots);
    ShotAbility = XComGameState_Ability(
        History.GetGameStateForObjectID(Shooter.FindAbility(Relation.FollowUpAbility).ObjectID)
    );
  }
  if (ShotAbility == none
        || !ShotAbility.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false))
  {
    // if we don't want a follow up shot or it failed (target dead), enter cover now (i.e. finalise)
		`log("End shot");
    ShotAbility = XComGameState_Ability(
        History.GetGameStateForObjectID(Shooter.FindAbility('GT_FinaliseAnimation').ObjectID)
    );
    ShotAbility.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false);
  }
	return ELR_NoInterrupt;
}


// What is this? triggered against an enemy or self?
// also, enter cover needs either major changes or the triggering code needs to be adjusted
// since enter cover is responsible for speaking
static function X2AbilityTemplate AddAnimationAbility()
{
  local X2AbilityTemplate                 Template;	
  local X2Condition_Visibility            VisibilityCondition;
  local X2AbilityTrigger_EventListener Trigger;

  // Macro to do localisation and stuffs
  `CREATE_X2ABILITY_TEMPLATE(Template, 'GT_FinaliseAnimation');

  // Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// don't frame this -- entering cover isn't something exciting to look at 
	Template.FrameAbilityCameraType = eCameraFraming_Never;


  Trigger = new class'X2AbilityTrigger_EventListener';
  Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
  Trigger.ListenerData.EventID = 'GT_FinaliseAnimation';
  Trigger.ListenerData.Filter = eFilter_Unit;
  Trigger.ListenerData.EventFn = SingleShotListener;
  Template.AbilityTriggers.AddItem(Trigger);

  // Targeting Details
  // Can only shoot visible enemies
  VisibilityCondition = new class'X2Condition_Visibility';
  VisibilityCondition.bRequireGameplayVisible = true;
  VisibilityCondition.bAllowSquadsight = true;
  Template.AbilityTargetConditions.AddItem(VisibilityCondition);
  // Can't shoot while dead
  Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
  // Only at single targets that are in range.
  Template.AbilityTargetStyle = default.SimpleSingleTarget;

  Template.AbilityTriggers.AddItem(Trigger);

  // MAKE IT LIVE!
  Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
  Template.BuildVisualizationFn = Finalize_BuildVisualization;
  Template.MergeVisualizationFn = GT_Shooting_MergeVisualization;
  // cannot be interrupted
//  Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

  Template.bDisplayInUITooltip = false;
  Template.bDisplayInUITacticalText = false;

  Template.bUsesFiringCamera = true;
  /* Template.CinescriptCameraType = "StandardGunFiring"; */	

  return Template;	
}


simulated function Finalize_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata ShadowMetaData, CosmeticUnitMetaData;
	local XComGameState_Unit ShadowUnit, ShadowbindTargetUnit, TargetUnitState, CosmeticUnit;
	local UnitValue ShadowUnitValue;
	local X2Effect_SpawnShadowbindUnit SpawnShadowEffect;
	local int j;
	local name SpawnShadowEffectResult;
	local X2Action_Fire SourceFire;
	local X2Action_MoveBegin SourceMoveBegin;
	local Actor SourceUnit;
	local array<X2Action> TransformStopParents;
	local VisualizationActionMetadata SourceMetaData, TargetMetaData;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_EnterCover EnterCoverAction;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	ExitCoverAction = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', , Context.InputContext.PrimaryTarget.ObjectID));
	VisMgr.DestroyAction(ExitCoverAction, true);
}


//	e.g. Rapid Fire, Chain Shot, Banish
simulated function GT_Shooting_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> arrActions;
	local X2Action_MarkerTreeInsertBegin MarkerStart;
	local X2Action_MarkerNamed MarkerNamed, JoinMarker, TrackerMarker;
	local X2Action_ExitCover ExitCoverAction, FirstExitCoverAction;
	local X2Action_EnterCover EnterCoverAction, LastEnterCoverAction;
	local X2Action_WaitForAnotherAction WaitAction;
	local VisualizationActionMetadata ActionMetadata;
	local int i;
	local int iBestHistoryIndex;

	VisMgr = `XCOMVISUALIZATIONMGR;
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	`log("GT_Shooting_MergeVisualization");
}


function bool FireDamagePreview(
  XComGameState_Ability AbilityState,
  StateObjectReference TargetRef,
  out WeaponDamageValue MinDamagePreview,
  out WeaponDamageValue MaxDamagePreview,
  out int AllowsShield
) {
  local XComGameState_Item WeaponState;
  local X2AbilityTemplate AbilityTemplate;
  local GuerrillaTacticsWeaponProfile WeaponProfile;
  local GuerrillaTactics_X2AbilityCost_BurstAmmoCost BurstAmmoCost;
  local X2AbilityCost AbilityCost;
  local eGT_FireMode FireMode;
  local int ShotCount;

  WeaponState = XComGameState_Item(
    `XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID)
  );
  AbilityTemplate = AbilityState.GetMyTemplate();

  foreach AbilityTemplate.AbilityCosts(AbilityCost)
  {
    BurstAmmoCost = GuerrillaTactics_X2AbilityCost_BurstAmmoCost(AbilityCost);
    if (BurstAmmoCost != none)
    {
      FireMode = BurstAmmoCost.FireMode;
    }
  }

  WeaponProfile = class'GuerrillaTactics_WeaponManager'.static.GetWeaponProfile(
    WeaponState.GetMyTemplateName()
  );
  ShotCount = class'GuerrillaTactics_WeaponManager'.static.GetShotCount(
    WeaponState.GetMyTemplateName(), FireMode
  );

  MinDamagePreview.Damage = WeaponProfile.BulletProfile.Damage - WeaponProfile.BulletProfile.Spread;
  MinDamagePreview.Pierce = WeaponProfile.BulletProfile.Pierce;
  MinDamagePreview.Shred = WeaponProfile.BulletProfile.Shred;
  MaxDamagePreview.Damage = ShotCount * (WeaponProfile.BulletProfile.Damage + WeaponProfile.BulletProfile.Spread);
  MaxDamagePreview.Pierce = ShotCount * (WeaponProfile.BulletProfile.Pierce);
  MaxDamagePreview.Shred = ShotCount * (WeaponProfile.BulletProfile.Shred);

	return true;
}

class GuerrillaTactics_X2Effect_AmbientSuppression extends X2Effect_Suppression;

var eGT_FireMode FireMode;

function bool UniqueToHitModifiers() { return false; } // stack suppression

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;
	local XComGameState_Ability SourceAbility;

	SourceAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

  ShotMod.ModType = eHit_Success;
  ShotMod.Value = GetAimModifierFromAbility(SourceAbility);
  ShotMod.Reason = FriendlyName;

  ShotModifiers.AddItem(ShotMod);
}

function int GetAimModifierFromAbility(XComGameState_Ability SourceAbility)
{
	local XComGameState_Item ItemState;
	local name WeaponName;

	ItemState = SourceAbility.GetSourceWeapon();
	WeaponName = ItemState.GetMyTemplateName();
	
  return class'GuerrillaTactics_WeaponManager'.static.GetSuppressionPower(
    WeaponName, FireMode
  ) * -1;
}


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// override X2Effect_Sppression code, but not X2Effect_Persistent one
	super(X2Effect_Persistent).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	SourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceUnit.m_SuppressionHistoryIndex = History.GetNumGameStates(); // the NewGameState is pending submission, so its index will be the next index in the history
	NewGameState.AddStateObject(SourceUnit);
}


DefaultProperties
{
	EffectName="AmbientSuppression"
	bUseSourcePlayerState=true
	CleansedVisualizationFn=CleansedSuppressionVisualization
}

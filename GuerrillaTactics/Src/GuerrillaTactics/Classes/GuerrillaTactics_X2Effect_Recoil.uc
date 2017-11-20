class GuerrillaTactics_X2Effect_Recoil extends X2Effect;

var eGT_FireMode FireMode;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local XComGameState_Item ItemState;
	local name WeaponName;
	local float CurrentRecoil, RecoilToAdd;

	SourceAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	ItemState = SourceAbility.GetSourceWeapon();
	WeaponName = ItemState.GetMyTemplateName();
  RecoilToAdd = class'GuerrillaTactics_WeaponManager'.static.GetRecoil(WeaponName, FireMode);
	TargetUnitState = XComGameState_Unit(kNewTargetState);
	TargetUnitState.GetUnitValue('GT_Recoil', CurrentRecoil);
	TargetUnitState.SetUnitFloatValue(
		'GT_Recoil', CurrentRecoil + RecoilToAdd, eCleanup_BeginTactical
	);
}

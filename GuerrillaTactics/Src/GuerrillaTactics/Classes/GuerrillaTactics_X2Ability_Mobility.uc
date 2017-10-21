class GuerrillaTactics_X2Ability_Mobility extends X2Ability;

var localized string SuppressionTargetEffectName;
var localized string SuppressionTargetEffectDesc;
var localized string OverwatchFlyover;


static function array<X2DataTemplate> CreateTemplates()
{
  local array<X2DataTemplate> Templates;

  Templates.AddItem(BlueMovePenalty());

  return Templates;
}

static function X2AbilityTemplate BlueMovePenalty()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger_EventListener		EventListener;
	local X2AbilityTarget_Self							TargetStyle;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GT_BlueMovePenalty');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parkour";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 0.6, MODOP_Multiplication);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, "BlueMovePenalty", "Your guy slows down yo.", Template.IconImage);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

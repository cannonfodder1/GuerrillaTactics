class GuerrillaTactics_UIScreenListener_AdventCOIN extends UIScreenListener;

var private bool HasInited;

event OnInit(UIScreen Screen)
{
	if(UIShell(Screen) == none)
	{
		return;
	}

	if (HasInited)
	{
		return;
	}

	HasInited = true;
	class'GuerrillaTactics_ScrubMissionManager'.static.UpdateAIJobs();
}

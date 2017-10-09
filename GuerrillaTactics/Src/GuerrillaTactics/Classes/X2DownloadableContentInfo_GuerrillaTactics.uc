class X2DownloadableContentInfo_GuerrillaTactics extends X2DownloadableContentInfo
	config(Game);

static event OnPostTemplatesCreated()
{
	`log("GuerrillaTactics :: Present and Correct");

	class'GuerrillaTactics_WeaponManager'.static.LoadWeaponProfiles();
	class'GuerrillaTactics_WeaponManager'.static.LoadArmorProfiles();
}

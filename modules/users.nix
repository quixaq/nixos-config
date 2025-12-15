{
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.quixaq = {
		isNormalUser = true;
		description = "quixaq";
		extraGroups = [ "networkmanager" "docker" "realtime" "audio "];
		# packages = with pkgs; [];
	};
}
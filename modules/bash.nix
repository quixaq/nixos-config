{
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	# ANCHOR aliases
	environment.shellAliases = {
		sudo = "doas";
		clean = "mat2";
		music_download = "yt-dlp --concurrent-fragments 10 -f \"bestaudio/best\" -xi --audio-quality 0 --audio-format opus --cookies-from-browser chromium --embed-thumbnail --embed-metadata -o \"%(title)s.%(ext)s\" --no-overwrites";
	};
	environment.interactiveShellInit = ''
		export DOTNET_CLI_TELEMETRY_OPTOUT=1
	'';
}

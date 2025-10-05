local apps = {
	"nm-applet",
	"nitrogen --restore",
	"picom",
	"dunst",
	"mpd",
	"alacritty",
	"xfce4-power-manager",
	"emacs --daemon"
}

for _, value in pairs(apps) do
	os.execute(value.."&")
end


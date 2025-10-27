local apps = {
	"nitrogen --restore",
	"picom",
	"dunst",
	"mpd",
	terminal,
	"xfce4-power-manager",
	"emacs --daemon"
}

for _, value in pairs(apps) do
	os.execute(value.."&")
end


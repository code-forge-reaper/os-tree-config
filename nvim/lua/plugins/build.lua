return {
    "cyuria/build.nvim",
    event = { "DirChanged", "BufRead" },
    opts = {},
    config = function()
	    require('build').setup({
	        -- Events to set the compiler on. Set this to {} to not
	        -- generate an autocommand for this
	        update_events = {
	        	"DirChanged",
	        	"BufRead",
	        },
	        
	        -- A list of marker files which indicate the parent directory
	        -- should be considered the project root
	        root = {
	        	".bzr",
	        	".git",
	        	".hg",
	        	".svn",
	        	"_darcs",
	        	"package.json",
	        },
	        -- Extra marker files. Use this to avoid overwriting the
	        -- default markers
	        root_extra = {},
	    })
    end
}

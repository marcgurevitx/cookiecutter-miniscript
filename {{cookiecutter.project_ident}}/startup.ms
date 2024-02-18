import "grfon"

globals.startup = {}

if not globals.hasIndex("abort") then
	globals.abort = function(msg)
		print msg
		exit
	end function
end if

if not globals.hasIndex("ensureImport") then
	// from /sys/lib/importUtil.ms
	globals.ensureImport = function(moduleName)
		if globals.hasIndex(moduleName) then return
		globals[moduleName] = "PENDING"	// (module is being imported now)
		import moduleName
		globals[moduleName] = locals[moduleName]
	end function
end if

importAndReturn = function(path)
	moduleName = file.name(path) - ".ms"
	import moduleName
	return locals[moduleName]
end function

startup.importAndReturn = @importAndReturn

addImportPaths = function(dirs)
	if not dirs then dirs = []
	if env.hasIndex("importPaths") then
		env.importPaths += dirs
	else
		env.MS_IMPORT_PATH += ":" + dirs.join(":")
	end if
end function

startup.addImportPaths = @addImportPaths

readConfig = function(fileName="project.grfon")
	return grfon.parse(file.readLines(fileName).join(char(13)))
end function

getCmdParams = function
	if env.hasIndex("cmdLineArgs") then
		params = env.cmdLineArgs
	else
		params = shellArgs
	end if
	return params
end function

parseCl = function(params)
	args = []
	opts = {}
	prevOpt = null
	noOptP = false
	for param in params
		if param == "--" then
			noOptP = true
		else if noOptP then
			args.push param
		else if param[0] == "-" then
			prevOpt = param[1:]
			opts[prevOpt] = true
		else if prevOpt then
			opts[prevOpt] = param
			prevOpt = null
		else
			args.push param
		end if
	end for
	return {"args": args, "opts": opts}
end function

runCommand = function(command)
	cmdModule = file.child("cmd", command) + ".ms"
	if not file.exists(cmdModule) then abort "no such command in `cmd/`: `" + command + "`"
	importAndReturn(cmdModule).launch
end function

main = function
	addImportPaths ["lib", "cmd"]
	config = readConfig
	startup.config = config
	addImportPaths config.dirs
	
	//
	if config.dirs then
		print "additional paths:"
		for d in config.dirs
			print " " + d
		end for
		print
	end if
	//
	
	cl = parseCl(getCmdParams)
	startup.cl = cl
	cl.args.pull  // drop program name
	command = cl.args.pull
	if command == null and config.hasIndex("command") then command = config.command
	startup.command = command
	if command then runCommand command
end function

if refEquals(locals, globals) then main

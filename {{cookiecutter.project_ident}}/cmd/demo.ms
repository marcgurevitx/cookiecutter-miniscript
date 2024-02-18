displayHeight = 25

launch = function  // run as a "startup command"
	if version.hostName != "Mini Micro" then abort "demo command is only for Mini Micro!"
	
	if startup.cl.args.len > 0 then
		// Run one demo
		demoFile = startup.cl.args[0]
		if not file.exists(demoFile) and not file.exists(demoFile + ".ms") then abort "no such demo: `" + demoFile + "`!"
		run demoFile
		return  // probably not needed, since `run` doesn't return...
	end if
	
	// Run all demos.
	// We make us a shell and exit the command, so the `main` function will get immediately invoked.
	env.shell = "cmd/demo"  // this file
	
end function

main = function  // run as a "Mini Micro shell"
	import "chars"
	import "mathUtil"
	
	clear
	key.clear
	demoFiles = file.children("demo")
	
	if demoFiles.len == 0 then
		print "(no demos in `demo/`!)"
		env.shell = ""
		exit
	end if
	
	if not globals.hasIndex("demoIndex") then
		globals.demoIndex = 0
		globals.demoOffset = 0
	end if
	
	if demoIndex >= demoFiles.len then
		globals.demoIndex = demoFiles.len - 1
		globals.demoOffset = mathUtil.max(0, globals.demoIndex - displayHeight + 1)
	end if
	
	while true
		clear
		
		// Draw menu
		lastIndex = mathUtil.min(demoFiles.len - 1, demoOffset + displayHeight - 1)
		for i in range(demoOffset, lastIndex)
			if i == demoIndex then text.inverse = true
			print (i + 1) + ". " + demoFiles[i] - ".ms"
			if i == demoIndex then text.inverse = false
		end for
		
		// Handle menu commands
		k = key.get
		if k == chars.up then
			if demoIndex > 0 then globals.demoIndex -= 1
			if demoOffset > demoIndex then globals.demoOffset = demoIndex
		else if k == chars.down then
			if demoIndex < demoFiles.len - 1 then globals.demoIndex += 1
			if demoOffset < demoIndex - displayHeight + 1 then globals.demoOffset = demoIndex - displayHeight + 1
		else if k == " " or k.code == 10 or k.code == 13 then  // <enter> or <space>
			clear
			run file.child("demo", demoFiles[demoIndex])
		else if k.code == 27 then  // <escape>
			env.shell = ""
			exit
		end if
		
		yield
	end while
end function

if refEquals(locals, globals) then main

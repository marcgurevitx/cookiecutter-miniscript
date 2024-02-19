
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

//ensureImport "{{ cookiecutter.project_ident }}Util"

foo = function
	return "foo"
end function

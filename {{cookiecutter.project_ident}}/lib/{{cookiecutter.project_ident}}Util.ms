ensureImport "mapUtil"

isInstance = function(x, T)
	if not @x isa T then return false
	if not @x isa map then return true
	_noVal = {}
	if refEquals(x.get("_inited", _noVal), _noVal) then return true
	return x._inited
end function

Class = {}
Class._name = "Class"
Class._inited = false
Class.set = function(name, value)
	if not isInstance(self, Class) then abort "uninited " + self._name
	_noval = {}
	if refEquals(self.get(name, _noval), _noval) then abort "unable to set `" + name + "`"
	self[name] = @value
	return self
end function

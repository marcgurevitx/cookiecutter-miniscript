ensureImport "qa"
ensureImport "{{ cookiecutter.project_ident }}Util"

enhanceStringsEqualityCheck qa

testIsInstance = function
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(42, number), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(42, string), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance("foo", string), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance("foo", list), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance([11, 12, 13], list), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance([11, 12, 13], map), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance({"foo": 42}, map), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance({"foo": 42}, funcRef), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(@print, funcRef), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(@print, number), false
	
	M = {}
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance({}, M), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(new M, M), true
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(new (new M), M), true
	
	M2 = {}
	M2._inited = false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance({}, M2), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance(new M2, M2), false
	qa.assertEqual {{ cookiecutter.project_ident }}Util.isInstance({"__isa": M2, "_inited": true}, M2), true
end function

testClass = function
	M = new {{ cookiecutter.project_ident }}Util.Class
	M._name = "M"
	M.x = null
	M.init = function(x)
		self._inited = true
		self.set "x", x
		return self
	end function
	qa.assertEqual (new M).init(42).x, 42
end function

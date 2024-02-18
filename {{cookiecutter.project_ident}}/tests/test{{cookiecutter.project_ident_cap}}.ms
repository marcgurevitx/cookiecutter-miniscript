ensureImport "qa"
ensureImport "{{ cookiecutter.project_ident }}"

enhanceStringsEqualityCheck qa

testFoo = function
	qa.assertEqual {{ cookiecutter.project_ident }}.foo, "foo"
end function

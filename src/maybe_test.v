module safety

fn test_maybe() {
	res1 := maybe_test_something()
	if !res1.is_something() {
		assert false
	}

	res2 := maybe_test_nothing()
	if !res2.is_nothing() {
		assert false
	}
}

fn maybe_test_something() Maybe<int> {
	return something<int>(1)
}

fn maybe_test_nothing() Maybe<int> {
	return nothing<int>()
}

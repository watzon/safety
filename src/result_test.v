module safety

fn test_result() {
	res1 := result_test_ok()
	if !res1.is_ok() {
		assert false
	}

	res2 := result_test_err()
	if !res2.is_err() {
		assert false
	}
}

fn result_test_ok() Result<int> {
	return ok(1)
}

fn result_test_err() Result<int> {
	return err<int>('some fancy error message')
}

module safety

pub struct SomeError {
mut:
	msg string
}

pub struct Result<T> {
mut:
	err   &SomeError = unsafe{ &SomeError(nil) }
	value &T = unsafe { &T(nil) }
}

pub fn ok<T>(value T) Result<T> {
	return Result<T> {
		value: &value,
	}
}

pub fn err<T>(err string) Result<T> {
	e := SomeError { msg: err }
	return Result<T> {
		err:   &e,
	}
}

pub fn (mut r Result<T>) ok(value T) Result<T> {
	r.value = &value
	r.err = unsafe { nil }
	return r
}
pub fn (mut r Result<T>) err(err string) Result<T> {
	r.value = unsafe { nil }
	r.err = &SomeError { msg: err }
	return r
}

pub fn (r &Result<T>) is_ok() bool {
	return isnil(r.err)
}

pub fn (r &Result<T>) is_err() bool {
	return !isnil(r.err)
}

pub fn (r &Result<T>) unwrap_err() string {
	if isnil(r.err.msg) {
		panic("can't unwrap non-error value")
	}

	return r.err.msg
}

pub fn (o &Result<T>) unwrap() &T {
	if o.is_err() {
		panic("can't unwrap err value")
	}
	return o.value
}

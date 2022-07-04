module safety

pub struct SomeError {
mut:
	msg string
}

pub struct Result<T> {
mut:
	err   &SomeError
	value &T
}

pub fn ok<T>(value T) Result<T> {
	return Result<T> {
		value: &value,
		err:   unsafe { voidptr(0) },
	}
}

pub fn err<T>(err string) Result<T> {
	e := SomeError { msg: err }
	return Result<T> {
		value: unsafe { voidptr(0) },
		err:   &e,
	}
}

pub fn (mut r Result<T>) ok(value T) Result<T> {
	r.value = &value
	r.err = unsafe { voidptr(0) }
	return r
}

pub fn (mut r Result<T>) err(err string) Result<T> {
	r.value = unsafe { voidptr(0) }
	r.err = &SomeError { msg: err }
	return r
}

pub fn (r &Result<T>) is_ok() bool {
	return isnil(r.err)
}

pub fn (r &Result<T>) is_err() bool {
	return !isnil(r.err)
}

pub fn (r &Result<T>) throw() ? {
	return error(r.err.msg)
}

pub fn (o &Result<T>) unwrap() &T {
	if o.is_err() {
		panic("can't unwrap err value")
	}
	return o.value
}

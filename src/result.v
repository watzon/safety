module safety
git@github.com:watzon/safety.git
pub struct SomeError {
mut:
	msg string
}

pub fn (err SomeError) str() string {
	return 'Error("$err.msg")'
}

pub struct Result<T> {
mut:
	err   &SomeError = unsafe { &SomeError(nil) }
	value &T = unsafe { &T(nil) }
}

pub fn (res Result<T>) str() string {
	if !isnil(res.err) {
		return res.err.str()
	}
	return 'Result($res.value)'
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

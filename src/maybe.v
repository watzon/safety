module safety

pub struct Maybe<T> {
mut:
	value &T = unsafe { &T(nil) }
}

pub fn (mb Maybe<T>) str() string {
	if isnil(mb.value) {
		return "Nothing"
	}
	return 'Something($mb.value)'
}

pub fn something<T>(value T) Maybe<T> {
	return Maybe<T>{
		value: &value
	}
}

pub fn nothing<T>() Maybe<T> {
	return Maybe<T>{
		value: unsafe { voidptr(0) },
	}
}

pub fn (mut o Maybe<T>) something(value T) Maybe<T> {
	o.value = &value
	return o
}

pub fn (mut o Maybe<T>) nothing() Maybe<T> {
	o.value = unsafe { voidptr(0) }
	return o
}

pub fn (o &Maybe<T>) is_something() bool {
	return !isnil(o.value)
}

pub fn (o &Maybe<T>) is_nothing() bool {
	return isnil(o.value)
}

pub fn (o &Maybe<T>) unwrap() T {
	if o.is_nothing() {
		panic("can't unwrap none value")
	}
	return *o.value
}

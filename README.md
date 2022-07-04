# safety.v

Because sometimes optional errors just aren't enough.

## Why

The only issue I've had in V is the inability to assign a variable as an optional value. V technically has option types, but they share space with errors and can't be assigned or passed around. This library gives you the ability to use the Option and Result patterns, rather than having to rely soley on returning errors and having them bubble up.

In most cases a library like this probably isn't necessary, but in the cases where it is... well here it is.

## Usage

### Result

The `Result` type is very similar to how V behaves natively. A `Result` is a type that wraps a value or an error like this:

```v
fn fetch_results(path string) Result<MyType> {
    if res := some_fetch_operation() {
        return ok(res)
    } else {
        return err('Failed to fetch results')
    }
}
```

The main difference between this and V's builtin `error` type is the ability to pass the result around. With the builtin V error type you are forced to handle an error if it comes up. You can either have the error be ignored leading it to be returned and bubble up to the calling function (`fetch_results('foo')?`) or you can catch the error with an `or` block and fall back to a default value.

`Result`, however, can be passed around all you want. You can check if the `Result` contains an error or a value

```v
if res.is_some() {
    // Result contains a value
} else if res.is_none() {
    // Result contains an error
}
```

And you can even go as far as to convert the error into a v `error` type by using `res.throw()`.

### Maybe

This was going to be called `Option`, but V has an internal `Option` type already and the types were in conflict. `Maybe` allows you to achieve the benfits of `nil`, withouth actually using `nil`. Sometimes mutable values are necessary, and sometimes you might not be able to get away with using a default value. Take this example:

```v
fn foo() {
    // ...
    parts := str.split_nth('#', 2)
    maybe_id := if parts.len == 2 {
        something<string>(parts[1])
    } else {
        nothing<string>()
    }

    // ... some other stuff

    id := maybe_id.is_something() {
        u32(strconv.parse_uint(maybe_id.unwrap(), 16, 32))?
    } else {
        infer_id(str)
    }

    // ...
}
```

Might be too complicated to make a good example, but the basic idea is that when `maybe_id` is created you have no idea whether or not an id was given. You could choose to use a blank string, but `strconv.parse_uint` has no problem parsing a blank string as a `0`, so that would break the id parsing. There are, of course, other ways to handle this, but this is just one example.

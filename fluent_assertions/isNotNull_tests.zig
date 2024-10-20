const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(null).isNotNull() fails" {
    const actual = ensure(null).isNotNull();

    try ensure(actual).is(FluentError.ValueWasNull);
}

test "ensure(null).isNotNull() with nullable fails" {
    const value: ?i32 = null;

    const actual = ensure(value).isNotNull();

    try ensure(actual).is(FluentError.ValueWasNull);
}

test "ensure(5).isNotNull() succeeds" {
    const value: ?i32 = 5;

    try ensure(value).isNotNull();
}

test "ensure(null).isNotNull() with nullable ErrorUnion fails" {
    const value: ?TestError!i32 = null;

    const actual = ensure(value).isNotNull();

    try ensure(actual).is(FluentError.ValueWasNull);
}

test "ensure(5).isNotNull() with nullable ErrorUnion succeeds" {
    const value: ?TestError!i32 = 5;

    try ensure(value).isNotNull();
}

test "ensure(ErrorA).isNotNull() with nullable ErrorUnion succeeds" {
    const value: ?TestError!i32 = TestError.ErrorA;

    try ensure(value).isNotNull();
}

const TestError = error{ErrorA};

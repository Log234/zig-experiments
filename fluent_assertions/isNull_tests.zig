const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(null).isNull() succeeds" {
    try ensure(null).isNull();
}

test "ensure(null).isNull() with nullable succeeds" {
    const value: ?i32 = null;

    try ensure(value).isNull();
}

test "ensure(5).isNull() fails" {
    const value: ?i32 = 5;

    const actual = ensure(value).isNull();

    try ensure(actual).is(FluentError.ValueWasNotNull);
}

test "ensure(null).isNull() with nullable ErrorUnion succeeds" {
    const value: ?TestError!i32 = null;

    try ensure(value).isNull();
}

test "ensure(5).isNull() with nullable ErrorUnion fails" {
    const value: ?TestError!i32 = 5;

    const actual = ensure(value).isNull();

    try ensure(actual).is(FluentError.ValueWasNotNull);
}

test "ensure(ErrorA).isNull() with nullable ErrorUnion fails" {
    const value: ?TestError!i32 = TestError.ErrorA;

    const actual = ensure(value).isNull();

    try ensure(actual).is(FluentError.ValueWasNotNull);
}

const TestError = error{ErrorA};

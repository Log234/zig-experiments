const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure([1, 2, 3]).hasLength(3) succeeds" {
    const value = [_]i32{ 1, 2, 3 };

    try ensure(value).hasLength(3);
}

test "ensure([]).hasLength(0) succeeds" {
    const value = [_]i32{};

    try ensure(value).hasLength(0);
}

test "ensure([1, 2, 3]).hasLength(0) fails" {
    const value = [_]i32{ 1, 2, 3 };

    const actual = ensure(value).hasLength(0);

    try ensure(actual).is(FluentError.LengthMismatch);
}

test "ensure([]).hasLength(3) fails" {
    const value = [_]i32{};

    const actual = ensure(value).hasLength(3);

    try ensure(actual).is(FluentError.LengthMismatch);
}

test "ensure(null).hasLength(3) fails" {
    const value: ?[3]i32 = null;

    const actual = ensure(value).hasLength(3);

    try ensure(actual).is(FluentError.ValueWasNull);
}

const TestError = error{ErrorA};

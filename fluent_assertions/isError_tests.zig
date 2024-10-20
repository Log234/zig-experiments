const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(ErrorA).isError() succeeds" {
    const value: TestError!i32 = TestError.ErrorA;

    try ensure(value).isError();
}

test "ensure(5).isError() fails" {
    const value: TestError!i32 = 5;

    const actual = ensure(value).isError();

    try ensure(actual).is(FluentError.ExpectedErrorButGotSuccess);
}

test "ensure(null).isError() fails" {
    const value: ?TestError!i32 = null;

    const actual = ensure(value).isError();

    try ensure(actual).is(FluentError.ExpectedErrorButGotSuccess);
}

test "ensure(ErrorA).isError() when nullable succeeds" {
    const value: ?TestError!i32 = TestError.ErrorA;

    try ensure(value).isError();
}

const TestError = error{ErrorA};

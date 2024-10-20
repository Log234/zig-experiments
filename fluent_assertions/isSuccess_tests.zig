const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(5).isSuccess() succeeds" {
    const value: TestError!i32 = 5;

    try ensure(value).isSuccess();
}

test "ensure(null).isSuccess() succeeds" {
    const value: ?TestError!i32 = null;

    try ensure(value).isSuccess();
}

test "ensure(ErrorA).isSuccess() fails" {
    const value: TestError!i32 = TestError.ErrorA;

    const actual = ensure(value).isSuccess();

    try ensure(actual).is(FluentError.ExpectedSuccessButGotError);
}

test "ensure(ErrorA).isSuccess() when nullable succeeds" {
    const value: ?TestError!i32 = TestError.ErrorA;

    const actual = ensure(value).isSuccess();

    try ensure(actual).is(FluentError.ExpectedSuccessButGotError);
}

const TestError = error{ErrorA};

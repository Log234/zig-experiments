const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(5).is(5) fails" {
    const actual = ensure(5).isNot(5);

    try ensure(actual).is(FluentError.ValueMatchedUnexpectedValue);
}

test "ensure(5).isNot(4) succeeds" {
    try ensure(5).isNot(4);
}

test "ensure('A').isNot('A') fails" {
    const actual = ensure('A').isNot('A');

    try ensure(actual).is(FluentError.ValueMatchedUnexpectedValue);
}

test "ensure('A').isNot('B') succeeds" {
    try ensure('A').isNot('B');
}

test "ensure(5).isNot(5) with ErrorUnions fails" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = 5;

    const actual = ensure(value).isNot(expected);

    try ensure(actual).is(FluentError.ValueMatchedUnexpectedValue);
}

test "ensure(5).isNot(4) with ErrorUnions succeeds" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = 4;

    try ensure(value).isNot(expected);
}

test "ensure(5).isNot(ErrorA) succeeds" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = TestError.ErrorA;

    try ensure(value).isNot(expected);
}

test "ensure(ErrorA).isNot(5) succeeds" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = 5;

    try ensure(value).isNot(expected);
}

test "ensure(ErrorA).isNot(ErrorA) fails" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = TestError.ErrorA;

    const actual = ensure(value).isNot(expected);

    try ensure(actual).is(FluentError.ValueMatchedUnexpectedValue);
}

test "ensure(ErrorA).isNot(ErrorB) succeeds" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = TestError.ErrorB;

    try ensure(value).isNot(expected);
}

test "ensure(5).isNot(5) with nullable fails" {
    const value: ?i32 = 5;
    const expected: ?i32 = 5;

    const actual = ensure(value).isNot(expected);

    try ensure(actual).is(FluentError.ValueMatchedUnexpectedValue);
}

test "ensure(5).isNot(4) with nullable succeeds" {
    const value: ?i32 = 5;
    const expected: ?i32 = 4;

    try ensure(value).isNot(expected);
}

test "ensure(null).isNot(null) fails" {
    const value: ?i32 = null;
    const expected: ?i32 = null;

    const actual = ensure(value).isNot(expected);

    try ensure(actual).is(FluenError.ValueMatchedUnexpectedValue);
}

test "ensure(null).isNot(5) succeeds" {
    const value: ?i32 = null;
    const expected: ?i32 = 5;

    try ensure(value).isNot(expected);
}

const TestError = error{ ErrorA, ErrorB };

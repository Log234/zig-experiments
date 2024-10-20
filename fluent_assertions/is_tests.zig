const std = @import("std");
const fluent_assertions = @import("ensure.zig");
const ensure = fluent_assertions.ensure;
const FluentError = fluent_assertions.FluentError;

test "ensure(5).is(5) succeeds" {
    try ensure(5).is(5);
}

test "ensure(5).is(4) returns error" {
    const actual = ensure(5).is(4);

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

test "ensure('A').is('A') succeeds" {
    try ensure('A').is('A');
}

test "ensure('A').is('B') fails" {
    const actual = ensure('A').is('B');

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

test "ensure(5).is(5) with ErrorUnions succeeds" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = 5;

    try ensure(value).is(expected);
}

test "ensure(5).is(4) with ErrorUnions fails" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = 4;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

test "ensure(5).is(ErrorA) fails" {
    const value: TestError!i32 = 5;
    const expected: TestError!i32 = TestError.ErrorA;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ExpectedErrorButGotSuccess);
}

test "ensure(ErrorA).is(5) fails" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = 5;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ExpectedSuccessButGotError);
}

test "ensure(ErrorA).is(ErrorA) succeeds" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = TestError.ErrorA;

    try ensure(value).is(expected);
}

test "ensure(ErrorA).is(ErrorB) fails" {
    const value: TestError!i32 = TestError.ErrorA;
    const expected: TestError!i32 = TestError.ErrorB;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

test "ensure(5).is(5) with nullable succeeds" {
    const value: ?i32 = 5;
    const expected: ?i32 = 5;

    try ensure(value).is(expected);
}

test "ensure(5).is(4) with nullable fails" {
    const value: ?i32 = 5;
    const expected: ?i32 = 4;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

test "ensure(null).is(null) succeeds" {
    const value: ?i32 = null;
    const expected: ?i32 = null;

    try ensure(value).is(expected);
}

test "ensure(null).is(5) fails" {
    const value: ?i32 = null;
    const expected: ?i32 = 5;

    const actual = ensure(value).is(expected);

    try ensure(actual).is(FluentError.ValueDidNotMatchExpectation);
}

const TestError = error{ ErrorA, ErrorB };

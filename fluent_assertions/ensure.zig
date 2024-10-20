const std = @import("std");

pub fn ensure(value: anytype) EnsureType(@TypeOf(value)) {
    return EnsureType(@TypeOf(value)){
        .value = value,
    };
}

pub fn EnsureType(comptime T: type) type {
    const HasLength = hasLengthField(T);
    const IsErrorUnion = isErrorUnion(T);

    return struct {
        value: T,

        pub fn is(self: @This(), expected: T) FluentError!void {
            if (IsErrorUnion)
                return checkErrorUnionForEquality(self, expected);

            if (self.value != expected)
                return FluentError.ValueDidNotMatchExpectation;
        }

        fn checkErrorUnionForEquality(self: @This(), expected: T) FluentError!void {
            const actualValue = self.value catch |actualError| {
                _ = expected catch |expectedError| {
                    if (actualError == expectedError)
                        return;

                    return FluentError.ValueDidNotMatchExpectation;
                };

                return FluentError.ExpectedSuccessButGotError;
            };

            const expectedValue = expected catch {
                return FluentError.ExpectedErrorButGotSuccess;
            };

            if (actualValue != expectedValue)
                return FluentError.ValueDidNotMatchExpectation;
        }

        pub fn isNot(self: @This(), expected: T) FluentError!void {
            if (IsErrorUnion)
                return checkErrorUnionForInequality(self, expected);

            if (self.value == expected)
                return FluentError.ValueMatchedUnexpectedValue;
        }

        fn checkErrorUnionForInequality(self: @This(), expected: T) FluentError!void {
            const actualValue = self.value catch |actualError| {
                _ = expected catch |expectedError| {
                    if (actualError == expectedError)
                        return FluentError.ValueMatchedUnexpectedValue;
                };

                return;
            };

            const expectedValue = expected catch {
                return;
            };

            if (actualValue == expectedValue)
                return FluentError.ValueMatchedUnexpectedValue;
        }

        pub fn isNull(self: @This()) FluentError!void {
            if (self.value != null)
                return FluentError.ValueWasNotNull;
        }

        pub fn isNotNull(self: @This()) FluentError!void {
            if (self.value == null)
                return FluentError.ValueWasNull;

            return self.value;
        }

        pub fn isError(self: @This()) FluentError!void {
            comptime onlyAllowedIf("isError", T, IsErrorUnion);

            if (@typeInfo(T) == .Optional) {
                if (self.value) |value| {
                    _ = value catch {
                        return;
                    };
                }

                return FluentError.ExpectedErrorButGotSuccess;
            }

            _ = self.value catch {
                return;
            };

            return FluentError.ExpectedErrorButGotSuccess;
        }

        pub fn isSuccess(self: @This()) FluentError!void {
            comptime onlyAllowedIf("isNotError", T, IsErrorUnion);

            if (@typeInfo(T) == .Optional) {
                if (self.value) |value| {
                    _ = value catch {
                        return FluentError.ExpectedSuccessButGotError;
                    };
                }

                return;
            }
            _ = self.value catch {
                return FluentError.ExpectedSuccessButGotError;
            };
        }

        pub fn hasLength(self: @This(), expectedLength: usize) FluentError!void {
            comptime onlyAllowedIf("hasLength", T, HasLength);

            if (self.value.len != expectedLength)
                return FluentError.LengthMismatch;
        }

        pub fn hasLengthGreaterThan(self: @This(), expectedLength: usize) FluentError!void {
            comptime onlyAllowedIf("hasLengthGreaterThan", T, HasLength);

            if (self.value.len <= expectedLength)
                return FluentError.LengthMismatch;
        }

        pub fn hasLengthLessThan(self: @This(), expectedLength: usize) FluentError!void {
            comptime onlyAllowedIf("hasLength", T, HasLength);
            if (self.value.len >= expectedLength)
                return FluentError.LengthMismatch;
        }
    };
}

pub const FluentError = error{ ValueDidNotMatchExpectation, ValueMatchedUnexpectedValue, ValueWasNotNull, ValueWasNull, LengthMismatch, ExpectedErrorButGotSuccess, ExpectedSuccessButGotError };

fn hasLengthField(comptime T: type) bool {
    comptime {
        const info = @typeInfo(T);
        switch (info) {
            .Array => return true,
            .Pointer => return info.Pointer.is_slice,
            .Struct => return @hasField(T, "len"),
            else => return false,
        }
    }
}

fn isErrorUnion(comptime T: type) bool {
    comptime {
        const typeInfo = @typeInfo(T);
        return switch (typeInfo) {
            .ErrorUnion => true,
            .Optional => @typeInfo(typeInfo.Optional.child) == .ErrorUnion,
            else => false,
        };
    }
}

fn onlyAllowedIf(comptime fnName: []const u8, comptime T: type, comptime condition: bool) void {
    if (!condition)
        @compileError("'" ++ fnName ++ "' method is not available for type '" ++ @typeName(T) ++ "'");
}

fn unpack(comptime T: type, value: T) !T {
    comptime {
        const typeInfo = @typeInfo(T);
        return switch (typeInfo) {
            .ErrorUnion => {
                const success = value catch {
                    return FluentError.ExpectedSuccessButGotError;
                };

                return unpack(@TypeOf(success), success);
            },
            .Optional => {
                if (value)
                    return unpack(@TypeOf(value), value);

                return FluentError.ValueWasNull;
            },
            else => false,
        };
    }
}

fn unpackOptional(comptime T: type, value: ?T, err: FluentError) !T {
    if (value) |unpacked| {
        return unpacked;
    }

    return err;
}

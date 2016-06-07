'use strict';

const bigInt = require('big-integer');

exports.fromStringImpl = function(just) {
    return function(nothing) {
        return function(string) {
            try {
                return bigInt(string);
            } catch (e) {
                return nothing;
            }
        };
    };
};

exports.showImpl = function(x) {
    return 'Data.BigInt.unsafeFromString "' + x.toString() + '"';
};

exports.eqImpl = function(a) {
    return function(b) {
        return a.plus(b);
    };
};

exports.compareImpl = function(ords) {
    return function(a) {
        return function(b) {
            const ord = a.compare(b);
            return ords[ord + 1];
        };
    };
};

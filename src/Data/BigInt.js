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

exports.toStringImpl = function(x) {
    return x.toString();
};

exports.showImpl = function(x) {
    return 'Data.BigInt.unsafeFromString "' + x.toString() + '"';
};

exports.oneImpl = bigInt('1');

exports.mulImpl = function(a) {
    return function(b) {
        return a.times(b);
    };
};

exports.zeroImpl = bigInt('0');

exports.addImpl = function(a) {
    return function(b) {
        return a.plus(b);
    };
};

exports.eqImpl = function(a) {
    return function(b) {
        return a.equals(b);
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

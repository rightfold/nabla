// Generated by psc version 0.9.1
"use strict";
var Data_BigInt_1 = require("../Data.BigInt");
var Data_BigInt_1 = require("../Data.BigInt");
var Data_String = require("../Data.String");
var Prelude = require("../Prelude");
var Data_Eq = require("../Data.Eq");
var Data_HeytingAlgebra = require("../Data.HeytingAlgebra");
var Data_Ord = require("../Data.Ord");
var Data_Ordering = require("../Data.Ordering");
var Data_Semigroup = require("../Data.Semigroup");
var Data_Functor = require("../Data.Functor");
var Var = (function () {
    function Var(value0) {
        this.value0 = value0;
    };
    Var.create = function (value0) {
        return new Var(value0);
    };
    return Var;
})();
var App = (function () {
    function App(value0, value1) {
        this.value0 = value0;
        this.value1 = value1;
    };
    App.create = function (value0) {
        return function (value1) {
            return new App(value0, value1);
        };
    };
    return App;
})();
var Lam = (function () {
    function Lam(value0, value1) {
        this.value0 = value0;
        this.value1 = value1;
    };
    Lam.create = function (value0) {
        return function (value1) {
            return new Lam(value0, value1);
        };
    };
    return Lam;
})();
var Num = (function () {
    function Num(value0) {
        this.value0 = value0;
    };
    Num.create = function (value0) {
        return new Num(value0);
    };
    return Num;
})();
var Pi = (function () {
    function Pi() {

    };
    Pi.value = new Pi();
    return Pi;
})();
var E = (function () {
    function E() {

    };
    E.value = new E();
    return E;
})();
var Add = (function () {
    function Add() {

    };
    Add.value = new Add();
    return Add;
})();
var Mul = (function () {
    function Mul() {

    };
    Mul.value = new Mul();
    return Mul;
})();
var Pow = (function () {
    function Pow() {

    };
    Pow.value = new Pow();
    return Pow;
})();
var Log = (function () {
    function Log() {

    };
    Log.value = new Log();
    return Log;
})();
var Derivative = (function () {
    function Derivative() {

    };
    Derivative.value = new Derivative();
    return Derivative;
})();
var showNabla = function (v) {
    if (v instanceof Var) {
        return v.value0;
    };
    if (v instanceof App) {
        return "(" + (showNabla(v.value0) + (")[" + (Data_String.joinWith(", ")(Data_Functor.map(Data_Functor.functorArray)(showNabla)(v.value1)) + "]")));
    };
    if (v instanceof Lam) {
        return "fun[" + (Data_String.joinWith(", ")(v.value0) + ("] " + showNabla(v.value1)));
    };
    if (v instanceof Num) {
        return Data_BigInt_1.toString(v.value0);
    };
    if (v instanceof Pi) {
        return "Pi";
    };
    if (v instanceof E) {
        return "E";
    };
    if (v instanceof Add) {
        return "Add";
    };
    if (v instanceof Mul) {
        return "Multiply";
    };
    if (v instanceof Pow) {
        return "Raise";
    };
    if (v instanceof Log) {
        return "Log";
    };
    if (v instanceof Derivative) {
        return "Differentiate";
    };
    throw new Error("Failed pattern match at Nabla.Term line 37, column 1 - line 37, column 22: " + [ v.constructor.name ]);
};
var eqTerm = new Data_Eq.Eq(function (x) {
    return function (y) {
        if (x instanceof Var && y instanceof Var) {
            return x.value0 === y.value0;
        };
        if (x instanceof App && y instanceof App) {
            return Data_Eq.eq(eqTerm)(x.value0)(y.value0) && Data_Eq.eq(Data_Eq.eqArray(eqTerm))(x.value1)(y.value1);
        };
        if (x instanceof Lam && y instanceof Lam) {
            return Data_Eq.eq(Data_Eq.eqArray(Data_Eq.eqString))(x.value0)(y.value0) && Data_Eq.eq(eqTerm)(x.value1)(y.value1);
        };
        if (x instanceof Num && y instanceof Num) {
            return Data_Eq.eq(Data_BigInt_1.eqBigInt)(x.value0)(y.value0);
        };
        if (x instanceof Pi && y instanceof Pi) {
            return true;
        };
        if (x instanceof E && y instanceof E) {
            return true;
        };
        if (x instanceof Add && y instanceof Add) {
            return true;
        };
        if (x instanceof Mul && y instanceof Mul) {
            return true;
        };
        if (x instanceof Pow && y instanceof Pow) {
            return true;
        };
        if (x instanceof Log && y instanceof Log) {
            return true;
        };
        if (x instanceof Derivative && y instanceof Derivative) {
            return true;
        };
        return false;
    };
});
var ordTerm = new Data_Ord.Ord(function () {
    return eqTerm;
}, function (x) {
    return function (y) {
        if (x instanceof Var && y instanceof Var) {
            return Data_Ord.compare(Data_Ord.ordString)(x.value0)(y.value0);
        };
        if (x instanceof Var) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Var) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof App && y instanceof App) {
            var $56 = Data_Ord.compare(ordTerm)(x.value0)(y.value0);
            if ($56 instanceof Data_Ordering.LT) {
                return Data_Ordering.LT.value;
            };
            if ($56 instanceof Data_Ordering.GT) {
                return Data_Ordering.GT.value;
            };
            return Data_Ord.compare(Data_Ord.ordArray(ordTerm))(x.value1)(y.value1);
        };
        if (x instanceof App) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof App) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Lam && y instanceof Lam) {
            var $65 = Data_Ord.compare(Data_Ord.ordArray(Data_Ord.ordString))(x.value0)(y.value0);
            if ($65 instanceof Data_Ordering.LT) {
                return Data_Ordering.LT.value;
            };
            if ($65 instanceof Data_Ordering.GT) {
                return Data_Ordering.GT.value;
            };
            return Data_Ord.compare(ordTerm)(x.value1)(y.value1);
        };
        if (x instanceof Lam) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Lam) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Num && y instanceof Num) {
            return Data_Ord.compare(Data_BigInt_1.ordBigInt)(x.value0)(y.value0);
        };
        if (x instanceof Num) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Num) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Pi && y instanceof Pi) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof Pi) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Pi) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof E && y instanceof E) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof E) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof E) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Add && y instanceof Add) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof Add) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Add) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Mul && y instanceof Mul) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof Mul) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Mul) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Pow && y instanceof Pow) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof Pow) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Pow) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Log && y instanceof Log) {
            return Data_Ordering.EQ.value;
        };
        if (x instanceof Log) {
            return Data_Ordering.LT.value;
        };
        if (y instanceof Log) {
            return Data_Ordering.GT.value;
        };
        if (x instanceof Derivative && y instanceof Derivative) {
            return Data_Ordering.EQ.value;
        };
        throw new Error("Failed pattern match: " + [ x.constructor.name, y.constructor.name ]);
    };
});
module.exports = {
    Var: Var, 
    App: App, 
    Lam: Lam, 
    Num: Num, 
    Pi: Pi, 
    E: E, 
    Add: Add, 
    Mul: Mul, 
    Pow: Pow, 
    Log: Log, 
    Derivative: Derivative, 
    showNabla: showNabla, 
    eqTerm: eqTerm, 
    ordTerm: ordTerm
};

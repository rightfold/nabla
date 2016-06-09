var bigInt = require('big-integer');
var ctors;
module.exports['parse\''] = function(startRule) {
    return function(ctors_) {
        ctors = ctors_;
        return function(text) {
            try {
                return ctors.just(module.exports.parse(text, {
                    startRule: startRule,
                }));
            } catch (e) {
                console.log(e);
                return ctors.nothing;
            }
        };
    };
};
exports['parse\''] = module.exports['parse\'']; // fuck psc

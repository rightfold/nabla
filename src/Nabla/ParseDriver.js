var bigInt = require('big-integer');
var ctors;
module.exports['parse\''] = function(ctors_) {
    ctors = ctors_;
    return function(text) {
        try {
            return ctors.just(module.exports.parse(text));
        } catch (e) {
            return ctors.nothing;
        }
    };
};
exports['parse\''] = module.exports['parse\'']; // fuck psc

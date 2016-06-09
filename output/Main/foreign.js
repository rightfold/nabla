'use strict';

exports.serve = function(exchange) {
    return function() {
        addEventListener('message', function(message) {
            const request = JSON.parse(message.data);
            const result = exchange(request.formula);
            postMessage(JSON.stringify({id: request.id, result: result}));
        });
    };
};

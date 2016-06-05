'use strict';

function lex(text) {
    const lexemes = [];
    while (text !== '') {
        var match;
        switch (true) {
        case !!(match = /^\s+/.exec(text)):
            text = text.slice(match[0].length);
            break;

        case !!(match = /^[a-zA-Z+*^_]+/.exec(text)):
            lexemes.push({type: 'identifier', name: match[0]});
            text = text.slice(match[0].length);
            break;

        case !!(text[0] === '(' || text[0] === ')'):
            lexemes.push({type: text[0]});
            text = text.slice(1);
            break;

        default:
            return null;
        }
    }
    return lexemes;
}

function parse(ctors, lexemes) {
    return parseTerms(ctors, lexemes);
}

function parseTerms(ctors, lexemes) {
    const terms = [];
    for (;;) {
        const result = parseTerm(ctors, lexemes);
        if (result !== null) {
            terms.push(result.result);
            lexemes = result.rest;
        } else {
            break;
        }
    }
    return {result: terms, rest: lexemes};
}

function parseTerm(ctors, lexemes) {
    if (lexemes.length === 0) {
        return null;
    }
    switch (lexemes[0].type) {
    case 'identifier':
        return {
            result: ctors.var(lexemes[0].name),
            rest: lexemes.slice(1),
        };

    case '(':
        const result = parseTerms(ctors, lexemes.slice(1));
        if (result !== null
            && result.result.length >= 1
            && result.rest.length !== 0
            && result.rest[0].type === ')') {
            return {
                result: ctors.app(result.result[0])(result.result.slice(1)),
                rest: result.rest.slice(1),
            };
        } else {
            return null;
        }

    default:
        return null;
    }
}

exports['parse\''] = function(ctors) {
    return function(text) {
        const lexemes = lex(text);
        if (lexemes === null) {
            return ctors.nothing;
        } else {
            const result = parse(ctors, lexemes);
            if (result !== null && result.rest.length === 0) {
                return ctors.just(result.result);
            } else {
                return ctors.nothing;
            }
        }
    };
};

'use strict';

class Server {
    constructor() {
        this.worker = new Worker('output/nabla-server.js');
        this.worker.addEventListener('message', ev => {
            const {id, result} = JSON.parse(ev.data);
            const callback = this.callbacks.get(id);
            this.callbacks.delete(id);
            callback(result);
        });
        this.nextID = 0;
        this.callbacks = new Map();
    }

    dispose() {
        this.worker.terminate();
    }

    compute(formula, callback) {
        const id = this.nextID++;
        this.callbacks.set(id, callback);
        this.worker.postMessage(JSON.stringify({id, formula}));
    }
}

const FormulaCell = React.createClass({
    getInitialState: function() {
        return {formula: ''};
    },
    render: function() {
        return React.createElement('form', {onSubmit: ev => this.onSubmit(ev)},
            React.createElement('input', {
                type: 'text',
                value: this.state.formula,
                onChange: ev => this.setState({formula: ev.target.value}),
            }),
            React.createElement('button', {type: 'submit'}, '='),
            React.createElement('div', {ref: 'result'})
        );
    },
    onSubmit: function(ev) {
        ev.preventDefault();
        this.refs.result.textContent = '(loading)';
        this.props.server.compute(this.state.formula, result => {
            this.refs.result.textContent = '\\(' + result + '\\)';
            MathJax.Hub.Queue(['Typeset', MathJax.Hub, this.refs.result]);
        });
    },
});

addEventListener('load', () => {
    const server = new Server();
    ReactDOM.render(
        React.createElement(FormulaCell, {server}),
        document.getElementById('notebook')
    );
});

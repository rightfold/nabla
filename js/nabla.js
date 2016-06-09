'use strict';

let n = 0;

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

const CellList = React.createClass({
    getInitialState: function() {
        return {cells: []};
    },
    render: function() {
        return React.createElement('div',
            {className: '-cell-list'},
            this.state.cells,
            React.createElement('button', {onClick: () => this.addCell()}, '+')
        );
    },
    addCell: function() {
        const cells = this.state.cells.slice();
        cells.push(
            React.createElement(FormulaCell, {
                key: ++n,
                server: this.props.server,
            })
        );
        this.setState({cells});
    },
});

const FormulaCell = React.createClass({
    getInitialState: function() {
        return {formula: ''};
    },
    render: function() {
        return React.createElement('form',
            {
                className: '-cell -formula-cell',
                onSubmit: ev => this.onSubmit(ev)
            },
            React.createElement('div', {className: '-formula'},
                React.createElement('textarea', {
                    ref: 'formula',
                    value: this.state.formula,
                    placeholder: 'Formula',
                    onChange: ev => this.onChange(ev),
                    onKeyDown: ev => this.onKeyDown(ev),
                }),
                React.createElement('button', {type: 'submit'}, '=')
            ),
            React.createElement('div', {className: '-result', ref: 'result'})
        );
    },
    onChange: function(ev) {
        this.setState({formula: ev.target.value});
        const field = this.refs.formula;
        field.style.height = '';
        field.style.height = field.scrollHeight + 'px';
    },
    onKeyDown: function(ev) {
        if (ev.keyCode === 13 && ev.shiftKey) {
            this.onSubmit(ev);
        }
    },
    onSubmit: function(ev) {
        ev.preventDefault();
        this.refs.result.innerHTML = '<span class="-loading">Computing&hellip;</span>';
        this.props.server.compute(this.state.formula, result => {
            this.refs.result.textContent = result;
        });
    },
});

addEventListener('load', () => {
    const server = new Server();
    ReactDOM.render(
        React.createElement(CellList, {server}),
        document.getElementById('notebook')
    );
});

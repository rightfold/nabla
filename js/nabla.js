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

function formulaCell(server, parent) {
    const form = document.createElement('form');
    parent.appendChild(form);

    const formulaField = document.createElement('input');
    formulaField.type = 'text';
    form.appendChild(formulaField);

    const submitButton = document.createElement('button');
    submitButton.type = 'submit';
    submitButton.textContent = '=';
    form.appendChild(submitButton);

    const resultView = document.createElement('div');
    form.appendChild(resultView);

    form.addEventListener('submit', ev => {
        ev.preventDefault();
    });

    submitButton.addEventListener('click', () => {
        resultView.textContent = '(loading)';
        server.compute(formulaField.value, result => {
            resultView.textContent = '\\(' + result + '\\)';
            MathJax.Hub.Queue(['Typeset', MathJax.Hub, resultView]);
        });
    });
}

addEventListener('load', () => {
    const server = new Server();
    const notebook = document.getElementById('notebook');
    formulaCell(server, notebook);
});

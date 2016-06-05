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

addEventListener('load', () => {
    const server = new Server();
    server.compute('(log x y)', result => {
        console.log(result);
    });
});

const express = require('express');
const request = require('request-promise')
const app = express();

const backendEndpoint = `http://backend:8080`

app.get('/hello-frontend', (req, res) => res.send('Hello from the frontend!'));

app.get('/call-backend', (req, res) => {
    // Query the backend and return the response
    request.get(backendEndpoint + "/hello-backend")
        .then(message => {
            message = `Backend says: '${message}'`
            res.json({
                message,
            })
        })
        .catch(err => {
            res.statusCode = 500
            res.json({
                error: err,
                message: "Unable to reach service at " + backendEndpoint,
            })
        });
});

app.get('/current/temp', (req, res) => {
    // Query the backend and return the response
    request.get(backendEndpoint + "/weather/london")
        .then(message => {
            message = `Backend says: '${message}'`
            res.json({
                message,
            })
        })
        .catch(err => {
            res.statusCode = 500
            res.json({
                error: err,
                message: "Unable to reach service at " + backendEndpoint,
            })
        });
});

module.exports = { app }
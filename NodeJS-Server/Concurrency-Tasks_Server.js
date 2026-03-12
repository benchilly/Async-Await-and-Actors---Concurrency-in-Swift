const express = require('express');
const app = express();
const score = randomIntFromInterval(600, 850);

function randomIntFromInterval(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

app.get('/experian/credit-score/:userId', (req, res) => {
    res.json({score: score});
});

app.get('/equifax/credit-score/:userId', (req, res) => {
    res.json({score: score});
});

app.listen(3000, () => {
    console.log('Server is running...');
});
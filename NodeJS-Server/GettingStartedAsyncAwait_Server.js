const express = require('express');
const app = express();

app.get('/current-date', (req, res) => {
    res.json({date: Date()});
});

app.listen(3000, () => {
    console.log('Server is running...');
});
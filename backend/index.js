const express = require('express')
const app = express()
const port = 3000
const usuarios = require('./usuarios')
app.get('/', (req, res) => {
    res.json(usuarios);
});
app.listen(port, () => console.log(`Example app listening on port port!`))
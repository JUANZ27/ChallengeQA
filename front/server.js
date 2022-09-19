const express = require('express')
const app = express()
const path = require('path')
const port = process.env.PORT || 4000

app.use('/static', express.static(__dirname + '/public'))

app.get('/register',(req, res) => {
    res.sendFile(path.join(__dirname+'/public/index.html'))
})


app.get('/login',(req, res) => {
    res.sendFile(path.join(__dirname+'/public/login.html'))
})



app.listen(port, () => {
    console.log('Server listen port: ', port)
})
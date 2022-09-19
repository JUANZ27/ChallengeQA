const registerButton = document.getElementById('register')
if (registerButton){ 
   
    registerButton.addEventListener('click', () => {
    const email = document.getElementById('email').value
    const password = document.getElementById('password').value
    const $msg = document.getElementById('msg')
    axios({
        method: 'post',
        url: 'http://localhost:3000/register',
        data: {
            email,
            password
        }
    }).then(function (response) {
        const { msg } = response.data
        $msg.innerHTML = msg
    }).catch(function (error) {
        const { msg } = error.response.data
        $msg.innerHTML = msg
    })
})

}
const loginButton = document.getElementById('login')
if (loginButton){ 

loginButton.addEventListener('click', () => {
    const email = document.getElementById('email').value
    const password = document.getElementById('password').value
    const $msg = document.getElementById('msg')
    axios({
        method: 'post',
        url: 'http://localhost:3000/login',
        data: {
            email,
            password
        }
    }).then(function (response) {
        const { msg } = response.data
        $msg.innerHTML = msg
    }).catch(function (error) {
        const { msg } = error.response.data
        $msg.innerHTML = msg
    })
})
}

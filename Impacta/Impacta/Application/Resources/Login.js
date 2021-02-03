var timeoutSeconds = 30;

var username = "%@";
var password = "%@";

var checkLogin = setInterval(checkLoginFields, 1000);
setTimeout(function() {
           clearInterval(checkLogin);
           }, timeoutSeconds * 1000);

function checkLoginFields() {
    var usernameInput = document.getElementById('deslogin');
    var passwordInput = document.getElementById('dessenhalogin');
    var signInButton = document.getElementsByClassName('btn btn-login')[0];
    var closeModalButton = document.getElementsByClassName('close')[6];
    
    usernameInput.value = username;
    passwordInput.value = password;
    signInButton.click();
    closeModalButton.click();
}

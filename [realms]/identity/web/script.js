window.addEventListener("DOMContentLoaded", function () {
    window.addEventListener("message", function (event) {
        let data = event.data;
        const main_container = document.getElementById('main_container');
    
        if (data.type === 'show') {
            main_container.style.opacity = 1;
        }
    
        if (data.type === 'hide') {
            main_container.style.opacity = 0;
        }
    });

    const form = document.getElementById('registrationForm');
    
    form.addEventListener('submit', function (event) {
        event.preventDefault(); 
        if (form.checkValidity()) {
            console.log("test")

            fetch(`https://${GetParentResourceName()}/register`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    prename: document.getElementById('prename').value,
                    name: document.getElementById('name').value,
                    dob: document.getElementById('dateofbirth').value,
                    height: document.getElementById('height').value
                })
            }).then(resp => resp.json()).then(resp => console.log(resp));
        }
    });
});
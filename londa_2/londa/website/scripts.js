function LoginEvents(event) {
    event.preventDefault(); // Prevent form submission

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const errorMessageDiv = document.getElementById('errorMessage');

    // API call to login
    fetch('http://localhost:9090/londa/login', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password }),
        credentials: 'omit' // Ensure credentials are not sent
    })
    .then(response => {
        // Check if the response is OK (status in the range 200-299)
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json(); // Corrected to response.json() to parse JSON response
    })
    .then(data => {
        if (data.status === 'success') {
            // Handle successful login (e.g., redirect to another page)
            window.location.href = 'home.html'; // Redirect to home page
        } else {
            // Display error message from the server
            errorMessageDiv.textContent = data.message;
            errorMessageDiv.style.display = 'block';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        errorMessageDiv.textContent = 'An error occurred during login. Please try again.';
        errorMessageDiv.style.display = 'block';
    });
}

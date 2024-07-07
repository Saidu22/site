<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Diagnosis System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f0f0; /* Light grey background */
            color: black;
        }

        .container {
            background-color: white; /* White background for containers */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(2, 2, 2, 0.1);
            width: 350px;
            margin-bottom: 20px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
        }

        button {
            margin: 10px;
            padding: 10px 20px;
            background-color: #007bff;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .dashboard {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
        }

        .dashboard button {
            width: 150px;
        }

        .hidden {
            display: none;
        }

        .report {
            background-color: white; /* White background for reports */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 350px;
            margin-top: 20px;
            text-align: center;
        }

        .report p {
            margin: 10px 0;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }

        .port-chooser {
            margin-top: 20px;
            text-align: left;
        }

        .port-chooser input {
            width: 100%;
            padding: 8px;
            margin-top: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        .port-chooser pre {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 4px;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div id="root"></div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/17.0.2/umd/react.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/17.0.2/umd/react-dom.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.26.0/babel.min.js"></script>

    <script type="text/babel">
        const { useState } = React;

        const PortChooser = () => {
            const [port, setPort] = useState(3000);
            return (
                <div className="port-chooser">
                    <label htmlFor="port">Local port</label>
                    <input
                        style={{ width: "5em" }}
                        type="number"
                        id="port"
                        name="port"
                        min="1"
                        max="65535"
                        value={port}
                        onChange={(event) => setPort(event.target.value)}
                    />
                    <p>
                        Use this command: <code>{`ssh -R 80:localhost:${port} localhost.run`}</code>
                    </p>
                </div>
            );
        };

        const App = () => {
            const [currentUser, setCurrentUser] = useState(null);

            const handleLogin = (event) => {
                event.preventDefault();
                const username = event.target.username.value;
                const email = event.target.email.value;
                const password = event.target.password.value;
                setCurrentUser({ username, email, password });
            };

            return (
                <div className="container">
                    {!currentUser ? (
                        <div id="mainContainer">
                            <h2>Register</h2>
                            <form id="registrationForm" onSubmit={handleLogin}>
                                <label htmlFor="username">Username:</label>
                                <input type="text" id="username" name="username" required /><br />
                                <label htmlFor="email">Email:</label>
                                <input type="email" id="email" name="email" required /><br />
                                <label htmlFor="password">Password:</label>
                                <input type="password" id="password" name="password" required /><br />
                                <button type="submit">Register</button>
                            </form>
                        </div>
                    ) : (
                        <div id="dashboardContainer">
                            <h2>Welcome to Medical Diagnosis System</h2>
                            <div className="dashboard">
                                <button>Dashboard</button>
                                <button>Diagnosis Test</button>
                                <button>Report</button>
                                <button>Certificate</button>
                                <button>Setting</button>
                            </div>
                            <PortChooser />
                        </div>
                    )}
                </div>
            );
        };

        ReactDOM.render(<App />, document.getElementById('root'));
    </script>
</body>
</html>

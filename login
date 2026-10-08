import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { API_URL } from '../api';

const Login = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleLogin =async (e) => {
        e.preventDefault();
        setError('');

        try {
            const response = await fetch(`${API_URL}/api/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, password })
            });

            const data = await response.json();

            if (response.ok) {
                const userId = data.userId ?? data.userID ?? data.id ?? data._id;
                if (userId === undefined || userId === null || userId === '') {
                    setError('Login succeeded, but the server did not return a user ID.');
                    return;
                }
                localStorage.setItem('user', JSON.stringify({ ...data, userId: String(userId) }));
                navigate('/home');
            } else {
                setError(typeof data === 'string' ? data : data?.message || 'Invalid username or password');
            }
        } catch (err) {
            setError(`Cannot connect to the login server at ${API_URL}. Start the backend or set REACT_APP_API_URL to its address.`);
        }
    };

    return (
        <main className="auth-page">
            <section className="auth-card">
                <h1>Log In</h1>
                <form onSubmit={handleLogin}>
                    <label>Username</label>
                    <input
                    type="text"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                    />

                    <label>Password</label>
                    <input 
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    />

                    <button className="auth-submit" type="submit">Log In</button>
                </form>

                {error && <p className="auth-error" role="alert">{typeof error === 'string' ? error : 'Invalid username or password'}</p>}

                <Link className="auth-link" to="/register">Sign up!</Link>
            </section>
        </main>
    );
};

export default Login;

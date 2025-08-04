const express = require('express');
const cors = require('cors');
const db = require('./db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (_, res) => {
  res.send({ status: 'Backend is running ✅' });
});

// Create table
app.post('/init', (req, res) => {
  const query = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(50) NOT NULL UNIQUE,
      password VARCHAR(100) NOT NULL
    )
  `;
  db.query(query, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Users table created' });
  });
});

// Register user
app.post('/register', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password)
    return res.status(400).json({ error: 'Missing fields' });

  const sql = `INSERT INTO users (username, password) VALUES (?, ?)`;
  db.query(sql, [username, password], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'User registered' });
  });
});

// List users (public, for testing)
app.get('/users', (_, res) => {
  db.query('SELECT id, username FROM users', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.listen(PORT, () => console.log(`🚀 Server on http://localhost:${PORT}`));

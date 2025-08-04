// db.js
const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 5,
  timezone: 'Z'
});

db.getConnection((err, conn) => {
  if (err) {
    console.error("DB connection failed:", err);
    process.exit(1);
  }
  conn.release();
  console.log("🌱 MySQL connected");
});

module.exports = db;

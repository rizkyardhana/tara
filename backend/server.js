import cors from 'cors';
import express from 'express';
import crypto from 'node:crypto';
import mysql from 'mysql2/promise';

const app = express();
const port = Number(process.env.PORT ?? 8000);
const database = mysql.createPool({
  host: process.env.DB_HOST ?? '127.0.0.1',
  port: Number(process.env.DB_PORT ?? 8889),
  user: process.env.DB_USER ?? 'root',
  password: process.env.DB_PASSWORD ?? 'root',
  database: process.env.DB_NAME ?? 'tara_db',
  waitForConnections: true,
  connectionLimit: 5,
});

app.use(cors());
app.use(express.json());

const id = () => crypto.randomUUID();
const now = () => new Date().toISOString();
const mysqlDateTime = (value) => value.slice(0, 19).replace('T', ' ');

async function currentUser(request) {
  const token = request.headers.authorization?.replace('Bearer ', '');
  if (!token?.startsWith('tara-')) return null;
  const [rows] = await database.execute(
    'SELECT id, name, email, role, status FROM users WHERE id = ? LIMIT 1',
    [token.slice(5)],
  );
  return rows[0] ?? null;
}

async function requireAdmin(request, response, next) {
  try {
    const user = await currentUser(request);
    if (!user || user.role !== 'admin' || user.status !== 'active') {
      return response.status(403).json({ message: 'Akses admin diperlukan' });
    }
    request.user = user;
    return next();
  } catch (error) {
    return response.status(500).json({ message: 'Gagal memeriksa akses admin' });
  }
}

app.get('/api/health', (_request, response) => {
  response.json({ status: 'ok', service: 'tara-backend' });
});

app.post('/api/auth/register', async (request, response) => {
  const { name, email, password, phone = '' } = request.body ?? {};
  if (!name || !email || !password) {
    return response.status(400).json({ message: 'name, email, dan password wajib diisi' });
  }
  const user = { id: id(), name, email, phone, createdAt: now(), isVerified: false };
  try {
    await database.execute(
      'INSERT INTO users (id, name, email, password, phone, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [user.id, name, email, password, phone, 'user', 'active'],
    );
    return response.status(201).json({ token: `tara-${user.id}`, user });
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return response.status(409).json({ message: 'Email sudah terdaftar' });
    }
    return response.status(500).json({ message: 'Gagal menyimpan pengguna' });
  }
});

app.post('/api/auth/login', async (request, response) => {
  const { email, password } = request.body ?? {};
  const [rows] = await database.execute(
    'SELECT id, name, email, password, phone, role, status, created_at AS createdAt FROM users WHERE email = ? LIMIT 1',
    [email],
  );
  const user = rows[0];
  if (!user || user.status !== 'active' || user.password !== password) {
    return response.status(401).json({ message: 'Email atau kata sandi salah' });
  }
  const { password: _password, ...publicUser } = user;
  return response.json({ token: `tara-${user.id}`, user: publicUser });
});

app.post('/api/auth/google', async (request, response) => {
  const { name, email, providerId } = request.body ?? {};
  if (!email || !providerId) {
    return response.status(400).json({ message: 'Identitas Google tidak lengkap' });
  }
  const normalizedEmail = email.toLowerCase().trim();
  const [existing] = await database.execute('SELECT * FROM users WHERE email = ? LIMIT 1', [normalizedEmail]);
  let user = existing[0];
  if (!user) {
    const userId = id();
    await database.execute(
      'INSERT INTO users (id, name, email, password, phone, role, status, google_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [userId, name || normalizedEmail.split('@')[0], normalizedEmail, '', '', 'user', 'active', providerId],
    );
    user = { id: userId, name: name || normalizedEmail.split('@')[0], email: normalizedEmail, role: 'user', status: 'active' };
  }
  if (user.status !== 'active') return response.status(403).json({ message: 'Akun sedang dinonaktifkan' });
  return response.json({ token: `tara-${user.id}`, user: { id: user.id, name: user.name, email: user.email, role: user.role, status: user.status } });
});

app.get('/api/profile', async (request, response) => {
  const [rows] = await database.execute(
    'SELECT id, name, email, phone, created_at AS createdAt, is_verified AS isVerified FROM users ORDER BY created_at DESC LIMIT 1',
  );
  const user = rows[0];
  if (!user) return response.status(404).json({ message: 'Belum ada pengguna' });
  return response.json(user);
});

app.put('/api/profile', async (request, response) => {
  const { currentEmail, name, email, phone = '' } = request.body ?? {};
  if (!currentEmail || !name || !email) {
    return response.status(400).json({ message: 'currentEmail, name, dan email wajib diisi' });
  }
  try {
    const [result] = await database.execute(
      'UPDATE users SET name = ?, email = ?, phone = ? WHERE email = ?',
      [name, email, phone, currentEmail],
    );
    if (result.affectedRows === 0) {
      return response.status(404).json({ message: 'Profil tidak ditemukan' });
    }
    const [rows] = await database.execute(
      'SELECT id, name, email, phone, created_at AS createdAt, is_verified AS isVerified FROM users WHERE email = ? LIMIT 1',
      [email],
    );
    return response.json(rows[0]);
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return response.status(409).json({ message: 'Email sudah digunakan' });
    }
    return response.status(500).json({ message: 'Gagal memperbarui profil' });
  }
});

app.post('/api/moods', (request, response) => {
  const mood = { id: id(), ...request.body, timestamp: now() };
  return database.execute(
    'INSERT INTO mood_checkins (id, user_id, mood_score, mood_emoji, factors, notes, checked_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [mood.id, mood.userId ?? null, mood.moodScore, mood.moodEmoji, JSON.stringify(mood.factors ?? []), mood.notes ?? null, mysqlDateTime(mood.timestamp)],
  ).then(() => response.status(201).json(mood)).catch(() => response.status(500).json({ message: 'Gagal menyimpan check-in' }));
});

app.get('/api/moods', async (_request, response) => {
  const [rows] = await database.execute(
    'SELECT id, user_id AS userId, mood_score AS moodScore, mood_emoji AS moodEmoji, factors, notes, checked_at AS timestamp FROM mood_checkins ORDER BY checked_at DESC',
  );
  return response.json(rows.map((row) => ({ ...row, factors: JSON.parse(row.factors ?? '[]') })));
});

app.post('/api/journals', async (request, response) => {
  const journal = { id: id(), ...request.body, createdAt: now(), updatedAt: now() };
  await database.execute(
    'INSERT INTO journals (id, user_id, title, content, mood_score, tags, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [journal.id, journal.userId ?? null, journal.title ?? null, journal.content ?? journal.notes ?? '', journal.moodScore ?? null, JSON.stringify(journal.tags ?? []), mysqlDateTime(journal.createdAt), mysqlDateTime(journal.updatedAt)],
  );
  return response.status(201).json(journal);
});

app.get('/api/journals', async (_request, response) => {
  const [rows] = await database.execute(
    'SELECT id, user_id AS userId, title, content, mood_score AS moodScore, tags, created_at AS createdAt, updated_at AS updatedAt FROM journals ORDER BY created_at DESC',
  );
  return response.json(rows.map((row) => ({ ...row, tags: JSON.parse(row.tags ?? '[]') })));
});

app.get('/api/journal-statistics', async (_request, response) => {
  const [summaryRows] = await database.execute(`
    SELECT COUNT(*) AS totalCheckIns,
      COALESCE(ROUND(AVG(mood_score), 1), 0) AS averageMood,
      COALESCE(MAX(mood_score), 0) AS bestMood,
      COUNT(DISTINCT DATE(checked_at)) AS activeDays
    FROM mood_checkins
  `);
  const [trend] = await database.execute(`
    SELECT DATE(checked_at) AS date, ROUND(AVG(mood_score), 1) AS score,
      COUNT(*) AS entries
    FROM mood_checkins
    WHERE checked_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY DATE(checked_at) ORDER BY date ASC
  `);
  const [factors] = await database.execute(`
    SELECT factor, COUNT(*) AS count FROM (
      SELECT TRIM(JSON_UNQUOTE(value)) AS factor
      FROM mood_checkins, JSON_TABLE(factors, '$[*]' COLUMNS(value JSON PATH '$')) AS values_table
    ) AS factor_values WHERE factor <> '' GROUP BY factor ORDER BY count DESC LIMIT 8
  `);
  return response.json({ summary: summaryRows[0], trend, factors });
});

app.post('/api/chat', (request, response) => {
  const message = { id: id(), ...request.body, isFromUser: true, timestamp: now() };
  const reply = {
    id: id(),
    userId: message.userId,
    content: 'Terima kasih sudah berbagi. Mari kita eksplorasi perasaan ini bersama.',
    isFromUser: false,
    timestamp: now(),
    messageType: 'text',
  };
  return database.execute(
    'INSERT INTO chat_messages (id, user_id, content, is_from_user, message_type, sent_at) VALUES (?, ?, ?, ?, ?, ?), (?, ?, ?, ?, ?, ?)',
    [message.id, message.userId ?? null, message.content, true, 'text', mysqlDateTime(message.timestamp), reply.id, reply.userId ?? null, reply.content, false, reply.messageType, mysqlDateTime(reply.timestamp)],
  ).then(() => response.status(201).json({ message, reply })).catch((error) => {
    console.error('Failed to save chat messages:', error.message);
    return response.status(500).json({ message: 'Gagal menyimpan percakapan' });
  });
});

app.get('/api/chat', async (_request, response) => {
  const [rows] = await database.execute(
    'SELECT id, user_id AS userId, content, is_from_user AS isFromUser, message_type AS messageType, sent_at AS timestamp FROM chat_messages ORDER BY sent_at ASC',
  );
  return response.json(rows);
});

app.get('/api/bisindo', async (_request, response) => {
  const [rows] = await database.execute(
    'SELECT id, title, description, category, video_url AS videoUrl, thumbnail_url AS thumbnailUrl, duration_seconds AS durationSeconds FROM bisindo_videos WHERE is_active = TRUE ORDER BY category, title',
  );
  return response.json(rows);
});

app.get('/api/admin/overview', requireAdmin, async (_request, response) => {
  const [[users]] = await database.query('SELECT COUNT(*) AS totalUsers, SUM(role = \'admin\') AS totalAdmins, SUM(status = \'active\') AS activeUsers FROM users');
  const [[moods]] = await database.query('SELECT COUNT(*) AS totalCheckIns, ROUND(AVG(mood_score), 1) AS averageMood FROM mood_checkins');
  const [[content]] = await database.query('SELECT (SELECT COUNT(*) FROM journals) AS totalJournals, (SELECT COUNT(*) FROM bisindo_videos WHERE is_active = TRUE) AS totalVideos');
  return response.json({ users, moods, content });
});

app.get('/api/admin/users', requireAdmin, async (_request, response) => {
  const [rows] = await database.execute('SELECT id, name, email, phone, role, status, created_at AS createdAt FROM users ORDER BY created_at DESC');
  return response.json(rows);
});

app.patch('/api/admin/users/:id', requireAdmin, async (request, response) => {
  const { role, status } = request.body ?? {};
  if (!['user', 'admin'].includes(role) || !['active', 'suspended'].includes(status)) return response.status(400).json({ message: 'Role atau status tidak valid' });
  if (request.params.id === request.user.id && role !== 'admin') return response.status(400).json({ message: 'Admin tidak dapat menurunkan role sendiri' });
  await database.execute('UPDATE users SET role = ?, status = ? WHERE id = ?', [role, status, request.params.id]);
  return response.json({ message: 'Akun diperbarui' });
});

app.delete('/api/admin/users/:id', requireAdmin, async (request, response) => {
  if (request.params.id === request.user.id) return response.status(400).json({ message: 'Admin aktif tidak dapat menghapus dirinya sendiri' });
  await database.execute('DELETE FROM users WHERE id = ?', [request.params.id]);
  return response.status(204).send();
});

app.post('/api/admin/bisindo', requireAdmin, async (request, response) => {
  const { title, description = '', category = 'Umum', videoUrl, thumbnailUrl = null, durationSeconds = 0 } = request.body ?? {};
  if (!title || !videoUrl) return response.status(400).json({ message: 'Judul dan URL video wajib diisi' });
  const videoId = id();
  await database.execute('INSERT INTO bisindo_videos (id, title, description, category, video_url, thumbnail_url, duration_seconds) VALUES (?, ?, ?, ?, ?, ?, ?)', [videoId, title, description, category, videoUrl, thumbnailUrl, durationSeconds]);
  return response.status(201).json({ id: videoId, title, description, category, videoUrl, thumbnailUrl, durationSeconds });
});

app.delete('/api/admin/bisindo/:id', requireAdmin, async (request, response) => {
  await database.execute('UPDATE bisindo_videos SET is_active = FALSE WHERE id = ?', [request.params.id]);
  return response.status(204).send();
});

app.get('/api/taman-pikiran', async (_request, response) => {
  const [rows] = await database.execute('SELECT COUNT(*) AS totalActivities FROM mood_checkins');
  return response.json({ growthLevel: 1, growthStage: 'Bertumbuh', totalActivities: rows[0].totalActivities, achievements: [] });
});

app.use((_request, response) => response.status(404).json({ message: 'Endpoint tidak ditemukan' }));

async function start() {
  await database.execute(`
    CREATE TABLE IF NOT EXISTS users (
      id CHAR(36) PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(150) UNIQUE NOT NULL,
      password VARCHAR(255) NOT NULL,
      phone VARCHAR(30),
      is_verified BOOLEAN NOT NULL DEFAULT FALSE,
      role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
      status ENUM('active', 'suspended') NOT NULL DEFAULT 'active',
      google_id VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `);
  try {
    await database.execute(
      'ALTER TABLE users ADD COLUMN is_verified BOOLEAN NOT NULL DEFAULT FALSE',
    );
  } catch (error) {
    if (error.code !== 'ER_DUP_FIELDNAME') throw error;
  }
  for (const statement of [
    "ALTER TABLE users ADD COLUMN role ENUM('user', 'admin') NOT NULL DEFAULT 'user'",
    "ALTER TABLE users ADD COLUMN status ENUM('active', 'suspended') NOT NULL DEFAULT 'active'",
    'ALTER TABLE users ADD COLUMN google_id VARCHAR(255)',
  ]) {
    try { await database.execute(statement); } catch (error) { if (error.code !== 'ER_DUP_FIELDNAME') throw error; }
  }
  await database.execute(
    "INSERT IGNORE INTO users (id, name, email, password, phone, role, status) VALUES ('admin-tara-kmti', 'Administrator TARA', 'admin@tara.kmti.com', 'AdminTara2026!', '', 'admin', 'active')",
  );
  await database.execute(`
    CREATE TABLE IF NOT EXISTS mood_checkins (
      id CHAR(36) PRIMARY KEY, user_id CHAR(36), mood_score TINYINT NOT NULL,
      mood_emoji VARCHAR(8) NOT NULL, factors JSON NOT NULL, notes TEXT,
      checked_at DATETIME NOT NULL, INDEX (checked_at)
    )
  `);
  await database.execute(`
    CREATE TABLE IF NOT EXISTS journals (
      id CHAR(36) PRIMARY KEY, user_id CHAR(36), title VARCHAR(200), content TEXT NOT NULL,
      mood_score TINYINT, tags JSON NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL,
      INDEX (created_at)
    )
  `);
  await database.execute(`
    CREATE TABLE IF NOT EXISTS chat_messages (
      id CHAR(36) PRIMARY KEY, user_id CHAR(36), content TEXT NOT NULL,
      is_from_user BOOLEAN NOT NULL, message_type VARCHAR(30), sent_at DATETIME NOT NULL,
      INDEX (sent_at)
    )
  `);
  await database.execute(`
    CREATE TABLE IF NOT EXISTS bisindo_videos (
      id VARCHAR(80) PRIMARY KEY, title VARCHAR(200) NOT NULL, description TEXT,
      category VARCHAR(80) NOT NULL, video_url VARCHAR(500) NOT NULL,
      thumbnail_url VARCHAR(500), duration_seconds INT DEFAULT 0,
      is_active BOOLEAN NOT NULL DEFAULT TRUE
    )
  `);
  await database.execute(`
    INSERT IGNORE INTO bisindo_videos
      (id, title, description, category, video_url, thumbnail_url, duration_seconds)
    VALUES
      ('bisindo-abjad', 'Wulangan 1 - Huruf ABJAD', 'Video pembelajaran huruf abjad dalam BISINDO.', 'Dasar', 'https://drive.google.com/uc?export=download&id=1OSrJerwZcrrg8k4Hq9IDd8xdLI26dOQn', NULL, 0),
      ('bisindo-perasaan', 'Perasaan', 'Kosakata BISINDO tentang emosi dan perasaan.', 'Emosi', 'https://www.youtube.com/results?search_query=BISINDO+perasaan+emosi', 'https://img.youtube.com/vi/0/mqdefault.jpg', 90),
      ('bisindo-kesehatan', 'Kesehatan', 'Kosakata yang berguna saat membicarakan kesehatan.', 'Kesehatan', 'https://www.youtube.com/results?search_query=BISINDO+kesehatan', 'https://img.youtube.com/vi/0/mqdefault.jpg', 120)
  `);
  await database.execute("DELETE FROM bisindo_videos WHERE video_url LIKE '%youtube.com/results%' OR video_url LIKE '%drive.google.com/drive/folders/%'");
  app.listen(port, '0.0.0.0', () => {
    console.log(`TARA backend running at http://localhost:${port}`);
  });
}

start().catch((error) => {
  console.error('Database connection failed:', error.message);
  process.exit(1);
});

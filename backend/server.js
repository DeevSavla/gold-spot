import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import mongoose from 'mongoose';

import challengeProgressRoutes from './routes/challenge-progress.routes.js';
import challengeRoutes from './routes/challenge.routes.js';
import userRoutes from './routes/user.routes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use((req, _res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', message: 'Backend is running' });
});

app.use(userRoutes);
app.use(challengeRoutes);
app.use(challengeProgressRoutes);

const startServer = async () => {
  try {
    if (!process.env.MONGO_URL) {
      throw new Error('MONGO_URL is missing. Add it to backend/.env.');
    }

    await mongoose.connect(process.env.MONGO_URL);
    console.log('Connected to MongoDB');

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Mongo connection failed:', err);
  }
};

startServer();

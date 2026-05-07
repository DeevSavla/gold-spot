import jwt from 'jsonwebtoken';

const BCRYPT_HASH_PREFIXES = ['$2a$', '$2b$', '$2x$', '$2y$'];

export function isBcryptHash(value) {
  return typeof value === 'string' && BCRYPT_HASH_PREFIXES.some((prefix) => value.startsWith(prefix));
}

export function createToken(user) {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET is missing. Add it to backend/.env.');
  }

  return jwt.sign(
    {
      sub: user._id.toString(),
      role: user.role,
      email: user.email,
    },
    process.env.JWT_SECRET,
    { expiresIn: '7d' },
  );
}

import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { randomUUID } from 'node:crypto';

const s3Client = new S3Client({
  region: process.env.AWS_REGION,
  credentials:
    process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY
      ? {
          accessKeyId: process.env.AWS_ACCESS_KEY_ID,
          secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
        }
      : undefined,
});

export async function uploadProfileImage(file, email) {
  if (!file) {
    return null;
  }

  const region = process.env.AWS_REGION;
  const bucket = process.env.AWS_S3_BUCKET;
  const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
  const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;

  if (!region || !bucket || !accessKeyId || !secretAccessKey) {
    throw new Error('AWS S3 environment variables are missing for profile upload.');
  }

  const safeEmail = email.replace(/[^a-z0-9]/gi, '-').toLowerCase();
  const extension = file.originalname?.includes('.') ? `.${file.originalname.split('.').pop()}` : '';
  const key = `profiles/${safeEmail}-${randomUUID()}${extension}`;

  await s3Client.send(
    new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: file.buffer,
      ContentType: file.mimetype || 'application/octet-stream',
    }),
  );

  return `https://${bucket}.s3.${region}.amazonaws.com/${key}`;
}

/*
  Warnings:

  - The values [GOOGLE] on the enum `Provider` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `createdAt` on the `Stream` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Stream` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `Upvote` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `role` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `Account` table. If the table is not empty, all the data it contains will be lost.
  - Changed the type of `type` on the `Stream` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Provider_new" AS ENUM ('Google');
ALTER TABLE "User" ALTER COLUMN "provider" TYPE "Provider_new" USING ("provider"::text::"Provider_new");
ALTER TYPE "Provider" RENAME TO "Provider_old";
ALTER TYPE "Provider_new" RENAME TO "Provider";
DROP TYPE "Provider_old" CASCADE;

COMMIT;
 
-- DropForeignKey
ALTER TABLE "Account" DROP CONSTRAINT "Account_userId_fkey";

-- DropForeignKey
ALTER TABLE "Upvote" DROP CONSTRAINT "Upvote_streamId_fkey";

-- DropIndex
DROP INDEX "Stream_userId_idx";

-- DropIndex
DROP INDEX "Upvote_streamId_idx";

-- DropIndex
DROP INDEX "Upvote_userId_idx";

-- AlterTable
ALTER TABLE "Stream" DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
ADD COLUMN     "bigImg" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "createAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "played" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "playedTs" TIMESTAMP(3),
ADD COLUMN     "smallImg" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "title" TEXT NOT NULL DEFAULT '',
DROP COLUMN "type",
ADD COLUMN     "type" "StreamType" NOT NULL;

-- AlterTable
ALTER TABLE "Upvote" DROP COLUMN "createdAt";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "createdAt",
DROP COLUMN "role",
DROP COLUMN "updatedAt";

-- DropTable
DROP TABLE "Account";

-- DropEnum
DROP TYPE "Role";

-- CreateTable
CREATE TABLE "CurrentStream" (
    "userId" TEXT NOT NULL,
    "streamId" TEXT,

    CONSTRAINT "CurrentStream_pkey" PRIMARY KEY ("userId")
);

-- CreateIndex
CREATE UNIQUE INDEX "CurrentStream_streamId_key" ON "CurrentStream"("streamId");

-- AddForeignKey
ALTER TABLE "CurrentStream" ADD CONSTRAINT "CurrentStream_streamId_fkey" FOREIGN KEY ("streamId") REFERENCES "Stream"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Upvote" ADD CONSTRAINT "Upvote_streamId_fkey" FOREIGN KEY ("streamId") REFERENCES "Stream"("id") ON DELETE CASCADE ON UPDATE CASCADE;

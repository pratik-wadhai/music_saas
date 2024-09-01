import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { prismaClient } from "@/app/lib/db";
import { AsyncResource } from "async_hooks";

const YT_REGEX = new RegExp(
  /^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+$/
);

const createStreamSchema = z.object({
  creatorId: z.string(),
  url: z.string(), /// youtube / spotify
});
export async function POST(req: NextRequest) {
  try {
    const data = createStreamSchema.parse(await req.json());
    const isYt = YT_REGEX.test(data.url);
    if (!isYt) {
      return NextResponse.json({ message: "Invalid URL" }, { status: 411 });
    }
    const extractedId = data.url.split("?v=")[1];

    const stream = await prismaClient.stream.create({
      data: {
        userId: data.creatorId,
        url: data.url,
        extractedId,
        type: "Youtube",
      },
    });
    return NextResponse.json({ stream }, { status: 201 });
  } catch (e) {
    return NextResponse.json({ error: e }, { status: 400 });
  }
}

export async function GET(req: NextRequest) {
  const creatorId = req.nextUrl.searchParams.get("creatorId");
  const streams = await prismaClient.stream.findMany({
    where: {
      userId: creatorId ?? " ",
    },
  });
  return NextResponse.json({ streams }, { status: 200 });
}

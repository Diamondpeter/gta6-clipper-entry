// main.ts -- entrypoint for the gta6-clipper-01 make.fun entry.
//
// The competition entry itself is a public YouTube Short; this program's
// single responsibility is to hand the graders a pointer to it. VIDEO.json
// sits in the bot directory next to this file, and the gate expects an
// exact copy of it inside the output directory after the run. Nothing
// fancier is wanted: no network, no clocks, no randomness -- the same
// input bytes must land in the output on every run.
//
// Locations come from the environment so the same file works inside the
// grading sandbox and in a plain checkout:
//   MAKEFUN_BOT_DIR    directory holding VIDEO.json (default "/bot")
//   MAKEFUN_OUTPUT_DIR directory that receives it    (default "/output")

import { mkdir, readFile, writeFile } from "node:fs/promises";
import * as path from "node:path";

const POINTER_NAME = "VIDEO.json";

// Resolve a directory setting: an unset or blank variable falls back to
// the sandbox default, and relative values are anchored at the cwd.
function directoryFromEnv(variable: string, fallback: string): string {
  const raw = process.env[variable];
  if (raw === undefined || raw.trim().length === 0) {
    return fallback;
  }
  return path.resolve(raw.trim());
}

// The gate only trusts a pointer whose url is a real YouTube video
// address: a Shorts link, a watch link, or a youtu.be short link, each
// carrying an 11-character video id. Validate before copying anything --
// a malformed pointer handed over silently would surface later as an
// invalid entry, so refuse loudly here instead.
const VIDEO_ID = "[A-Za-z0-9_-]{11}";
const ACCEPTED_URL = new RegExp(
  `^https://(?:(?:www|m)\\.youtube\\.com/(?:shorts/${VIDEO_ID}|watch\\?v=${VIDEO_ID})|youtu\\.be/${VIDEO_ID})(?:[?#].*)?$`,
);

function assertUsablePointer(payload: Buffer, originPath: string): void {
  let parsed: unknown;
  try {
    parsed = JSON.parse(payload.toString("utf8"));
  } catch {
    throw new Error(`${originPath} is not valid JSON`);
  }
  if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) {
    throw new Error(`${originPath} must hold a JSON object with a url`);
  }
  const url = (parsed as { url?: unknown }).url;
  if (typeof url !== "string" || !ACCEPTED_URL.test(url)) {
    throw new Error(
      `${originPath} url is not a YouTube video address: ${String(url)}`,
    );
  }
}

// Read the pointer file, recreate the output directory if it is missing,
// write the bytes across, then read back what landed and compare: a copy
// that does not match the source byte for byte is a failed run, not a
// partial success.
async function deliverPointer(): Promise<void> {
  const originDir = directoryFromEnv("MAKEFUN_BOT_DIR", "/bot");
  const landingDir = directoryFromEnv("MAKEFUN_OUTPUT_DIR", "/output");
  const originPath = path.join(originDir, POINTER_NAME);
  const landingPath = path.join(landingDir, POINTER_NAME);

  const payload: Buffer = await readFile(originPath);
  assertUsablePointer(payload, originPath);

  await mkdir(landingDir, { recursive: true });
  await writeFile(landingPath, payload);

  const landed: Buffer = await readFile(landingPath);
  if (!landed.equals(payload)) {
    throw new Error(
      `verification failed: ${landingPath} differs from ${originPath}`,
    );
  }
}

deliverPointer().catch((failure: unknown) => {
  const detail =
    failure instanceof Error ? failure.message : String(failure);
  console.error(`main.ts could not deliver ${POINTER_NAME}: ${detail}`);
  process.exitCode = 1;
});

"use client";

import { track } from "@vercel/analytics";

const DOWNLOAD_URL =
  "https://github.com/Evandabest/Radiant/releases/download/Beta-release/Radiant.zip";

export function DownloadButton({
  className,
  children,
}: {
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <a
      href={DOWNLOAD_URL}
      className={className}
      onClick={() => track("download_click")}
    >
      {children}
    </a>
  );
}

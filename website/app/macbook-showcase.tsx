"use client";

import { MacbookScroll } from "@/components/ui/macbook-scroll";

export function MacbookShowcase() {
  return (
    <div className="w-full overflow-hidden bg-black">
      <MacbookScroll
        title={
          <span className="text-4xl sm:text-5xl font-bold tracking-tight">
            See the difference
          </span>
        }
        src="/radiant-screenshot.png"
        showGradient={true}
      />
    </div>
  );
}

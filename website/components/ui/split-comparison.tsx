"use client";

export function SplitComparison() {
  return (
    <div className="relative w-full h-full overflow-hidden rounded-lg">
      {/* Without Radiant (right side, full background) */}
      <div className="absolute inset-0">
        <img
          src="/wallpaper.jpeg"
          alt=""
          className="w-full h-full object-cover brightness-[0.85] saturate-[0.9]"
          draggable={false}
        />
      </div>

      {/* With Radiant (left side, clipped) */}
      <div className="absolute inset-0 w-1/2 overflow-hidden">
        <img
          src="/wallpaper.jpeg"
          alt=""
          className="w-[200%] h-full object-cover brightness-[1.35] saturate-[1.2]"
          draggable={false}
        />
      </div>

      {/* Divider line */}
      <div className="absolute top-0 bottom-0 left-1/2 w-px bg-white/40" />

      {/* Brightness slider at max — macOS style */}
      <div className="absolute top-3 left-1/2 -translate-x-1/2 z-10">
        <div className="bg-black/70 backdrop-blur-xl rounded-2xl px-4 py-2 flex flex-col items-center gap-1.5 min-w-[180px]">
          <span className="text-[7px] font-medium text-white/80 self-start">Display</span>
          <div className="flex items-center gap-2 w-full">
            <svg className="w-2.5 h-2.5 text-white/60 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="4" />
              <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
            </svg>
            <div className="flex-1 h-1 bg-white/20 rounded-full overflow-hidden">
              <div className="h-full w-full bg-white rounded-full" />
            </div>
            <svg className="w-3.5 h-3.5 text-white shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="4" />
              <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
            </svg>
          </div>
        </div>
      </div>

      {/* Labels — moved lower */}
      <div className="absolute bottom-4 left-0 w-1/2 text-center">
        <span className="px-3 py-1 text-sm font-bold text-white drop-shadow-lg">
          With Radiant
        </span>
      </div>
      <div className="absolute bottom-4 right-0 w-1/2 text-center">
        <span className="px-3 py-1 text-sm font-bold text-white/70 drop-shadow-lg">
          Without Radiant
        </span>
      </div>
    </div>
  );
}

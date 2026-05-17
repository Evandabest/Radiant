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

      {/* Labels */}
      <div className="absolute top-4 left-0 w-1/2 text-center">
        <span className="px-3 py-1 text-sm font-bold text-white drop-shadow-lg">
          With Radiant
        </span>
      </div>
      <div className="absolute top-4 right-0 w-1/2 text-center">
        <span className="px-3 py-1 text-sm font-bold text-white/70 drop-shadow-lg">
          Without Radiant
        </span>
      </div>
    </div>
  );
}

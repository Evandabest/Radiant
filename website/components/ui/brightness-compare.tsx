"use client";

import {
  ReactCompareSlider,
  ReactCompareSliderImage,
} from "react-compare-slider";

function BrightnessSlider() {
  return (
    <div className="absolute top-2 right-2 z-10">
      <div className="bg-white/15 backdrop-blur-2xl rounded-xl px-3 py-1.5 flex flex-col gap-1 w-[120px] border border-white/25 shadow-lg">
        <span className="text-[8px] font-medium text-white/90">Display</span>
        <div className="flex items-center gap-1.5 w-full">
          <svg className="w-2.5 h-2.5 text-white/60 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="4" />
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
          </svg>
          <div className="flex-1 h-[3px] bg-white/20 rounded-full overflow-hidden">
            <div className="h-full w-full bg-white rounded-full" />
          </div>
          <svg className="w-3 h-3 text-white shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="4" />
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
          </svg>
        </div>
      </div>
    </div>
  );
}

export function BrightnessCompare() {
  return (
    <div className="relative w-full max-w-4xl mx-auto rounded-2xl overflow-hidden border border-white/10">
      <BrightnessSlider />
      <ReactCompareSlider
        itemOne={
          <div className="relative w-full h-full">
            <ReactCompareSliderImage
              src="/wallpaper.jpeg"
              alt="With Radiant"
              style={{
                filter: "brightness(1.35) saturate(1.2)",
              }}
            />
            <div className="absolute bottom-6 left-6">
              <span className="px-4 py-2 rounded-full bg-black/50 backdrop-blur-md text-sm font-semibold text-white">
                With Radiant
              </span>
            </div>
          </div>
        }
        itemTwo={
          <div className="relative w-full h-full">
            <ReactCompareSliderImage
              src="/wallpaper.jpeg"
              alt="Without Radiant"
              style={{
                filter: "brightness(0.85) saturate(0.9)",
              }}
            />
            <div className="absolute bottom-6 right-6">
              <span className="px-4 py-2 rounded-full bg-black/50 backdrop-blur-md text-sm font-semibold text-white">
                Without Radiant
              </span>
            </div>
          </div>
        }
        style={{ height: "500px" }}
      />
    </div>
  );
}

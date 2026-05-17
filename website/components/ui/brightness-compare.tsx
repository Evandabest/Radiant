"use client";

import {
  ReactCompareSlider,
  ReactCompareSliderImage,
} from "react-compare-slider";

export function BrightnessCompare() {
  return (
    <div className="w-full max-w-4xl mx-auto rounded-2xl overflow-hidden border border-white/10">
      <ReactCompareSlider
        itemOne={
          <div className="relative w-full h-full">
            <ReactCompareSliderImage
              src="/wallpaper.jpeg"
              alt="With Radiant"
              style={{
                filter: "brightness(1.15) saturate(1.15)",
              }}
            />
            <div className="absolute top-6 left-6">
              <span className="px-4 py-2 rounded-full bg-white/20 backdrop-blur-md text-sm font-semibold text-white">
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
                filter: "brightness(0.6) saturate(0.85)",
              }}
            />
            <div className="absolute top-6 right-6">
              <span className="px-4 py-2 rounded-full bg-black/40 backdrop-blur-md text-sm font-semibold text-white/70">
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

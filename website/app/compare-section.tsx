"use client";

import { BrightnessCompare } from "@/components/ui/brightness-compare";

export function CompareSection() {
  return (
    <section className="px-4 sm:px-6 pt-8 pb-16 sm:pb-24 border-t border-white/10">
      <div className="max-w-5xl mx-auto">
        <h2 className="text-2xl sm:text-3xl font-bold text-center mb-4">
          Drag to compare
        </h2>
        <p className="text-zinc-400 text-center mb-12">
          See how Radiant transforms your display brightness
        </p>
        <BrightnessCompare />
        <p className="text-xs text-zinc-600 text-center mt-4">
          Simulated effect for demo purposes only. Actual results can be seen on your display.
        </p>
      </div>
    </section>
  );
}

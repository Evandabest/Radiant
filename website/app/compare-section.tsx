"use client";

import { BrightnessCompare } from "@/components/ui/brightness-compare";

export function CompareSection() {
  return (
    <section className="px-6 py-24 border-t border-white/10">
      <div className="max-w-4xl mx-auto">
        <h2 className="text-3xl font-bold text-center mb-4">
          Drag to compare
        </h2>
        <p className="text-zinc-400 text-center mb-12">
          See how Radiant transforms your display brightness
        </p>
        <BrightnessCompare />
      </div>
    </section>
  );
}

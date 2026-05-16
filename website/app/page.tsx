import { MacbookShowcase } from "./macbook-showcase";

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen">
      <nav className="flex items-center justify-between px-6 py-4 border-b border-white/10">
        <span className="text-lg font-semibold tracking-tight">Radiant</span>
        <a
          href="#download"
          className="rounded-full bg-white text-black px-5 py-2 text-sm font-medium hover:bg-white/90 transition-colors"
        >
          Download
        </a>
      </nav>

      <main className="flex-1">
        <section className="flex flex-col items-center justify-center text-center px-6 pt-24 pb-8 gap-6">
          <div className="text-6xl">
            ☀
          </div>
          <h1 className="text-5xl sm:text-6xl font-bold tracking-tight max-w-2xl leading-tight">
            Unlock your display&apos;s full brightness
          </h1>
          <p className="text-lg sm:text-xl text-zinc-400 max-w-xl">
            Radiant pushes your MacBook Pro XDR display beyond the 500 nit SDR
            cap. Boost up to full HDR brightness or dim below minimum. Free and
            open source.
          </p>
          <div className="flex gap-4 mt-4">
            <a
              href="#download"
              className="rounded-full bg-white text-black px-8 py-3 text-base font-semibold hover:bg-white/90 transition-colors"
            >
              Download for Mac
            </a>
            <a
              href="https://github.com/evandabest/Radiant"
              className="rounded-full border border-white/20 px-8 py-3 text-base font-semibold hover:bg-white/5 transition-colors"
            >
              View Source
            </a>
          </div>
          <p className="text-sm text-zinc-500 mt-2">
            Requires MacBook Pro 14&quot; or 16&quot; with M1 Pro/Max, M2 Pro/Max, M3 Pro/Max, or M4 Pro/Max
          </p>
        </section>

        <MacbookShowcase />

        <section className="px-6 py-24 border-t border-white/10">
          <div className="max-w-5xl mx-auto">
            <h2 className="text-3xl font-bold text-center mb-16">
              Everything your display can do
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <FeatureCard
                icon="☀"
                title="XDR Boost"
                description="Push brightness past the macOS SDR limit. Your display can do 1000+ nits — Radiant lets it."
              />
              <FeatureCard
                icon="🌙"
                title="Eclipse Mode"
                description="Dim your screen below the system minimum. Perfect for dark rooms and late night work."
              />
              <FeatureCard
                icon="⌨"
                title="Keyboard Shortcut"
                description="Toggle brightness boost instantly with a global hotkey. No need to open the app."
              />
              <FeatureCard
                icon="🔋"
                title="Battery Aware"
                description="Automatically disables the boost when you unplug. Saves battery when you need it."
              />
              <FeatureCard
                icon="🎚"
                title="Variable Control"
                description="Fine-tune your brightness with a smooth slider from eclipse through normal to full boost."
              />
              <FeatureCard
                icon="🆓"
                title="Free Forever"
                description="No subscriptions, no trials, no paywalls. Radiant is completely free and open source."
              />
            </div>
          </div>
        </section>

        <section className="px-6 py-24 border-t border-white/10">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl font-bold text-center mb-16">
              How it works
            </h2>
            <div className="space-y-8 text-zinc-400">
              <div>
                <h3 className="text-white font-semibold text-lg mb-2">
                  Your display is already capable
                </h3>
                <p>
                  Apple&apos;s XDR displays can output up to 1,600 nits peak
                  brightness, but macOS caps everyday content at ~500 nits. The
                  extra brightness is reserved for HDR video. Radiant unlocks it
                  for everything.
                </p>
              </div>
              <div>
                <h3 className="text-white font-semibold text-lg mb-2">
                  No hacks, no private APIs
                </h3>
                <p>
                  Radiant uses Apple&apos;s own Extended Dynamic Range (EDR)
                  system to activate the display&apos;s HDR mode, then adjusts
                  the display&apos;s gamma response to boost all content. It
                  operates within the hardware&apos;s rated specifications.
                </p>
              </div>
              <div>
                <h3 className="text-white font-semibold text-lg mb-2">
                  Lightweight and unobtrusive
                </h3>
                <p>
                  Radiant lives in your menu bar. A single slider controls
                  everything from screen dimming to full brightness boost. It
                  uses minimal CPU and memory.
                </p>
              </div>
            </div>
          </div>
        </section>

        <section
          id="download"
          className="px-6 py-24 border-t border-white/10"
        >
          <div className="max-w-2xl mx-auto text-center">
            <h2 className="text-3xl font-bold mb-4">Download Radiant</h2>
            <p className="text-zinc-400 mb-8">
              Free for macOS. Requires a MacBook Pro 14&quot; or 16&quot; with
              Liquid Retina XDR display (M1 Pro/Max, M2 Pro/Max, M3 Pro/Max,
              or M4 Pro/Max) or Pro Display XDR.
            </p>
            <a
              href="#"
              className="inline-block rounded-full bg-white text-black px-10 py-4 text-lg font-semibold hover:bg-white/90 transition-colors"
            >
              Download v1.0
            </a>
            <p className="text-sm text-zinc-500 mt-4">macOS 14 Sonoma or later</p>
          </div>
        </section>

        <section className="px-6 py-24 border-t border-white/10">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl font-bold text-center mb-12">FAQ</h2>
            <div className="space-y-8">
              <FAQ
                question="Will this damage my display?"
                answer="No. Radiant operates within Apple's rated specifications for XDR displays. These displays are designed to sustain 1,000 nits full-screen brightness. macOS manages thermal limits automatically."
              />
              <FAQ
                question="Which Macs are supported?"
                answer="MacBook Pro 14-inch and 16-inch with M1 Pro/Max, M2 Pro/Max, M3 Pro/Max, or M4 Pro/Max (Liquid Retina XDR display), and the Pro Display XDR."
              />
              <FAQ
                question="Does it work on MacBook Air?"
                answer="No. MacBook Air displays max out at ~500 nits and lack XDR capability. There's no additional brightness to unlock."
              />
              <FAQ
                question="Does it affect battery life?"
                answer="Running the display at higher brightness uses more power. Radiant can automatically disable the boost when on battery."
              />
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t border-white/10 px-6 py-8" />
    </div>
  );
}

function FeatureCard({
  icon,
  title,
  description,
}: {
  icon: string;
  title: string;
  description: string;
}) {
  return (
    <div className="rounded-2xl border border-white/10 p-6">
      <div className="text-2xl mb-3">{icon}</div>
      <h3 className="font-semibold text-lg mb-2">{title}</h3>
      <p className="text-sm text-zinc-400">{description}</p>
    </div>
  );
}

function FAQ({ question, answer }: { question: string; answer: string }) {
  return (
    <div>
      <h3 className="text-white font-semibold mb-2">{question}</h3>
      <p className="text-zinc-400">{answer}</p>
    </div>
  );
}

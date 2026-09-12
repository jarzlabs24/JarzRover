'use client';

import { useEffect, useMemo, useState } from 'react';
import { Sparkles } from 'lucide-react';

import { CreatureAbility } from '@/components/creature-ability';

type GalleryCreature = {
  id: string;
  createdAt: string;
  name: string;
  type: string;
  description: string;
  ability: string;
  image: string;
};

export default function GalleryPage() {
  const [creatures, setCreatures] = useState<GalleryCreature[]>([]);
  const [activeId, setActiveId] = useState<string | null>(null);
  const [connected, setConnected] = useState(true);

  useEffect(() => {
    async function refresh() {
      try {
        const response = await fetch('/api/creatures', { cache: 'no-store' });
        if (!response.ok) throw new Error('Gallery server unavailable');
        const result = (await response.json()) as {
          creatures: GalleryCreature[];
        };
        setCreatures((current) => {
          if (result.creatures[0]?.id !== current[0]?.id) {
            setActiveId(result.creatures[0]?.id ?? null);
          }
          return result.creatures;
        });
        setConnected(true);
      } catch {
        setConnected(false);
      }
    }

    void refresh();
    const refreshTimer = window.setInterval(() => void refresh(), 2000);
    return () => window.clearInterval(refreshTimer);
  }, []);

  useEffect(() => {
    if (creatures.length < 2) return;
    const rotationTimer = window.setInterval(() => {
      setActiveId((currentId) => {
        const currentIndex = Math.max(
          0,
          creatures.findIndex((creature) => creature.id === currentId),
        );
        return creatures[(currentIndex + 1) % creatures.length].id;
      });
    }, 8000);
    return () => window.clearInterval(rotationTimer);
  }, [creatures]);

  const activeCreature = useMemo(
    () =>
      creatures.find((creature) => creature.id === activeId) ?? creatures[0],
    [activeId, creatures],
  );

  return (
    <main className="min-h-screen bg-slate-950 p-5 text-white sm:p-8">
      <div className="mx-auto flex min-h-[calc(100vh-2.5rem)] max-w-7xl flex-col">
        <header className="mb-5 flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.24em] text-cyan-300">
              Jarz Rover
            </p>
            <h1 className="text-3xl font-black tracking-tight sm:text-5xl">
              Recent Creature Discoveries
            </h1>
          </div>
          <div
            className={`rounded-full px-4 py-2 text-sm font-bold ${connected ? 'bg-emerald-400/15 text-emerald-300' : 'bg-rose-400/15 text-rose-300'}`}
          >
            {connected ? '● Live' : '● Reconnecting'}
          </div>
        </header>

        {activeCreature ? (
          <div className="grid min-h-0 flex-1 gap-5 lg:grid-cols-[minmax(0,1fr)_minmax(320px,0.7fr)]">
            <section className="grid min-h-0 place-items-center overflow-hidden rounded-[2rem] bg-white p-4 shadow-2xl shadow-violet-950/40">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                key={activeCreature.id}
                src={activeCreature.image}
                alt={`${activeCreature.name}, a Jarz creature`}
                className="max-h-[68vh] w-full object-contain"
              />
            </section>

            <section className="flex flex-col rounded-[2rem] border border-violet-300/20 bg-violet-950/55 p-6 sm:p-8">
              <Sparkles
                className="mb-4 size-10 text-amber-300"
                aria-hidden="true"
              />
              <h2 className="text-4xl font-black tracking-tight sm:text-6xl">
                {activeCreature.name}
              </h2>
              <p className="mt-2 text-xl font-bold text-cyan-300">
                {activeCreature.type}
              </p>
              <p className="mt-6 text-lg leading-relaxed text-violet-100">
                {activeCreature.description}
              </p>
              <div className="mt-6 rounded-2xl bg-white/10 p-5 text-lg text-violet-50">
                <span className="text-amber-300">
                  <CreatureAbility ability={activeCreature.ability} />
                </span>
              </div>
              <p className="mt-auto pt-8 text-sm font-semibold text-violet-300">
                New discoveries appear automatically
              </p>
            </section>
          </div>
        ) : (
          <section className="grid flex-1 place-items-center rounded-[2rem] border-2 border-dashed border-violet-300/30 bg-violet-950/30 p-8 text-center">
            <div>
              <Sparkles
                className="mx-auto mb-5 size-16 animate-pulse text-amber-300"
                aria-hidden="true"
              />
              <h2 className="text-3xl font-black sm:text-5xl">
                Waiting for a discovery…
              </h2>
              <p className="mt-3 text-lg text-violet-200">
                The next creature generated by Jarz Rover will appear here.
              </p>
            </div>
          </section>
        )}

        {creatures.length > 1 && (
          <nav
            className="mt-5 flex gap-3 overflow-x-auto pb-1"
            aria-label="Recent creatures"
          >
            {creatures.map((creature) => (
              <button
                key={creature.id}
                type="button"
                onClick={() => setActiveId(creature.id)}
                className={`flex shrink-0 items-center gap-3 rounded-2xl border p-2 pr-4 text-left transition ${creature.id === activeCreature?.id ? 'border-cyan-300 bg-cyan-300/15' : 'border-white/10 bg-white/5'}`}
              >
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={creature.image}
                  alt=""
                  className="size-14 rounded-xl bg-white object-contain"
                />
                <span className="font-black">{creature.name}</span>
              </button>
            ))}
          </nav>
        )}
      </div>
    </main>
  );
}

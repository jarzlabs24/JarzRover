const MAX_RECENT_CREATURES = 20;

export type RecentCreature = {
  id: string;
  createdAt: string;
  name: string;
  type: string;
  description: string;
  ability: string;
  image: string;
};

type CreatureProfile = Omit<RecentCreature, 'id' | 'createdAt' | 'image'>;

type CreatureLabGlobal = typeof globalThis & {
  jarzRecentCreatures?: RecentCreature[];
};

function recentCreatures() {
  const sharedGlobal = globalThis as CreatureLabGlobal;
  sharedGlobal.jarzRecentCreatures ??= [];
  return sharedGlobal.jarzRecentCreatures;
}

export function saveRecentCreature(image: string, profile: CreatureProfile) {
  const creature: RecentCreature = {
    id: crypto.randomUUID(),
    createdAt: new Date().toISOString(),
    image,
    ...profile,
  };

  recentCreatures().unshift(creature);
  recentCreatures().splice(MAX_RECENT_CREATURES);
  return creature;
}

export function listRecentCreatures() {
  return [...recentCreatures()];
}

export function CreatureAbility({ ability }: { ability: string }) {
  const separator = ability.indexOf(':');
  if (separator < 1) return <span>{ability}</span>;

  return (
    <>
      <span className="font-black">{ability.slice(0, separator + 1)}</span>
      {ability.slice(separator + 1)}
    </>
  );
}

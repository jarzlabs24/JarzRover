export const runtime = 'nodejs';

const CREATURE_PROMPT = `Transform the single object in this photograph into one original, family-friendly fantasy creature for the Jarz Creature Lab.

Subject requirements:
- The intended subject is the non-human object centered in the photograph.
- Treat any person, face, hand, arm, or body part as unwanted background context, never as the creature subject.
- Make a new living creature inspired by the object, not a drawing of the original object with eyes. At first glance it must read as a creature; the source object should become apparent second.
- Translate two or three of the object's most interesting traits—such as material, color, texture, function, or one distinctive shape—into creature anatomy, markings, armor, or powers. Invent the rest freely.
- Do not preserve the complete outline or construction of the original object. Break apart and reinterpret its features instead.
- Build the creature around an imaginative body plan rather than forcing the whole source object to become its torso.
- Purposeful limbs or other locomotion anatomy are recommended. Prefer two to four legs, arms, wings, fins, tentacles, roots, or similar appendages unless a limbless, radial, or floating form is clearly the stronger creature idea.
- Do not automatically add two arms, two legs, ears, or a tail. Every appendage must have a clear visual reason connected to the source object.
- Integrate a readable, expressive face into a natural surface or feature of the object; a conventional head is optional.
- Make it playful, imaginative, polished, and suitable for children at a Maker Faire.
- Use an original creature design. Do not imitate Pokemon or any existing copyrighted character.
- Show only one creature, centered, in a dynamic three-quarter pose.
- Do not include people, hands, or extra objects from the source photograph.`;

const CREATURE_ART_DIRECTION = `

Art direction:
- Create a polished, original 2D creature design with the clean look of late-1990s and early-2000s Japanese game-guide anime art.
- Use a clear, instantly readable silhouette built from simple rounded forms and compact, slightly stubby proportions, with one or two sharper accents for energy.
- Make the silhouette distinctive and creature-like. It may be tall, compact, serpentine, quadrupedal, radial, floating, or asymmetric according to the concept.
- Draw smooth, confident, medium-thin dark outlines with gentle line-weight variation. Keep edges crisp, closed, and easy to read.
- Use large, simple, expressive eyes with small geometric highlights, plus a minimal nose and mouth.
- Use clean, mostly flat base colors. Keep the object's recognizable palette, balanced and moderately saturated rather than neon.
- Shade sparingly: use one soft cel-shadow shape per major form, a few small highlights, and only very subtle tonal blending where needed for volume.
- Use a plain clean white background with at most a very faint neutral contact shadow beneath the creature.
- No watercolor washes, paper texture, visible brush texture, colored-pencil grain, sketch lines, painterly rendering, dramatic lighting, heavy gradients, glossy 3D surfaces, or photorealism.
- No photograph fragments, text, symbols, logos, cards, borders, scenery, or additional characters.`;

const PROFILE_PROMPT = `Identify the single non-human object centered in this photograph and design one original, family-friendly creature inspired by that specific object. Ignore every person, face, hand, arm, or body part completely; those are never the subject.

First invent a creature concept, then decide how to translate only two or three object traits into its anatomy, armor, markings, and powers. The final design must read as a living creature rather than the unchanged object with a face. For tools and manufactured objects, reinterpret their function: a working end might inspire a horn, claw, arm, tail, or ability; a grip might inspire torso armor or skin markings. Do not use the entire tool as the creature's body.

Purposeful locomotion anatomy is recommended. Prefer two to four legs, arms, wings, fins, tentacles, roots, or similar appendages unless a limbless, radial, or floating design is clearly more expressive. Consider serpentine, quadruped, many-legged, radial, floating, aquatic, plant-like, mechanical, asymmetric, and bipedal forms. Avoid repeatedly defaulting to the same upright two-arm, two-leg, ears-and-tail mascot.

Return a short creature profile and private design directions. The name, creature type, description, special ability, body plan, and defining visual features must clearly relate to recognizable features, purpose, material, color, or shape of the photographed object. Do not mention Pokemon or imitate an existing character.`;

type CreatureProfile = {
  name: string;
  type: string;
  description: string;
  ability: string;
  sourceObject: string;
  bodyPlan: string;
  definingFeatures: string[];
};

async function createProfile(apiKey: string, image: string): Promise<CreatureProfile> {
  const response = await fetch('https://api.openai.com/v1/responses', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-5.6-luna',
      input: [{
        role: 'user',
        content: [
          { type: 'input_text', text: PROFILE_PROMPT },
          { type: 'input_image', image_url: image, detail: 'high' },
        ],
      }],
      text: {
        format: {
          type: 'json_schema',
          name: 'creature_profile',
          strict: true,
          schema: {
            type: 'object',
            additionalProperties: false,
            properties: {
              name: { type: 'string' },
              type: { type: 'string' },
              description: { type: 'string' },
              ability: { type: 'string' },
              sourceObject: { type: 'string' },
              bodyPlan: { type: 'string' },
              definingFeatures: {
                type: 'array',
                items: { type: 'string' },
                minItems: 2,
                maxItems: 4,
              },
            },
            required: [
              'name',
              'type',
              'description',
              'ability',
              'sourceObject',
              'bodyPlan',
              'definingFeatures',
            ],
          },
        },
      },
    }),
    signal: AbortSignal.timeout(20_000),
  });

  const result = (await response.json()) as {
    output?: Array<{ content?: Array<{ type?: string; text?: string }> }>;
    error?: { message?: string };
  };
  const outputText = result.output
    ?.flatMap((item) => item.content ?? [])
    .find((item) => item.type === 'output_text')?.text;

  if (!response.ok || !outputText) {
    throw new Error(result.error?.message ?? 'The object could not be analyzed.');
  }

  return JSON.parse(outputText) as CreatureProfile;
}

async function createImage(apiKey: string, image: string, profile: CreatureProfile) {
  const sourceImage = await fetch(image).then((response) => response.blob());
  const form = new FormData();
  form.append('model', 'gpt-image-2');
  form.append('image[]', sourceImage, 'jarz-object.jpg');
  form.append(
    'prompt',
    `${CREATURE_PROMPT}${CREATURE_ART_DIRECTION}

Object-specific design decision:
- Source object: ${profile.sourceObject}
- Chosen body plan: ${profile.bodyPlan}
- Object traits to reinterpret—not copy literally: ${profile.definingFeatures.join('; ')}

Follow this chosen body plan, but transform and redistribute the object traits across a genuinely new living creature. Do not output the original object with a face, and do not replace the plan with a generic upright mascot.`,
  );
  form.append('size', '1024x1024');
  form.append('quality', 'low');

  const response = await fetch('https://api.openai.com/v1/images/edits', {
    method: 'POST',
    headers: { Authorization: `Bearer ${apiKey}` },
    body: form,
    signal: AbortSignal.timeout(55_000),
  });

  const result = (await response.json()) as {
    data?: Array<{ b64_json?: string }>;
    error?: { message?: string };
  };

  if (!response.ok || !result.data?.[0]?.b64_json) {
    throw new Error(result.error?.message ?? 'Creature generation did not complete.');
  }

  return `data:image/png;base64,${result.data[0].b64_json}`;
}

export async function POST(request: Request) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return Response.json(
      { code: 'missing_api_key', error: 'The OpenAI API key is not configured.' },
      { status: 503 },
    );
  }

  try {
    const { image } = (await request.json()) as { image?: string };
    if (!image?.startsWith('data:image/')) {
      return Response.json({ error: 'A valid captured image is required.' }, { status: 400 });
    }

    const profile = await createProfile(apiKey, image);
    const creatureImage = await createImage(apiKey, image, profile);

    return Response.json({
      image: creatureImage,
      profile: {
        name: profile.name,
        type: profile.type,
        description: profile.description,
        ability: profile.ability,
      },
    });
  } catch (error) {
    const timedOut = error instanceof Error && error.name === 'TimeoutError';
    return Response.json(
      {
        error: timedOut
          ? 'Generation took too long. Please try again.'
          : error instanceof Error
            ? error.message
            : 'Could not generate the creature.',
      },
      { status: timedOut ? 504 : 500 },
    );
  }
}

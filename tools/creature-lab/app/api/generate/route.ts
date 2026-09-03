export const runtime = 'nodejs';

const CREATURE_PROMPT = `Transform the single object in this photograph into one original, family-friendly fantasy creature for the Jarz Creature Lab.

Requirements:
- Preserve the object's main colors, material, shape, and at least two recognizable physical features.
- Give the creature a friendly expressive face and a complete body.
- Make it playful, imaginative, polished, and suitable for children at a Maker Faire.
- Use an original creature design. Do not imitate Pokemon or any existing copyrighted character.
- Show only one creature, centered, in a dynamic three-quarter pose.
- Use a clean, softly lit studio background with no words, logos, labels, borders, or cards.
- Do not include people, hands, or extra objects from the source photograph.`;

export async function POST(request: Request) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return Response.json({ error: 'The OpenAI API key is not configured.' }, { status: 503 });
  }

  try {
    const { image } = (await request.json()) as { image?: string };
    if (!image?.startsWith('data:image/')) {
      return Response.json({ error: 'A valid captured image is required.' }, { status: 400 });
    }

    const sourceImage = await fetch(image).then((response) => response.blob());
    const form = new FormData();
    form.append('model', 'gpt-image-2');
    form.append('image[]', sourceImage, 'jarz-object.jpg');
    form.append('prompt', CREATURE_PROMPT);
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
      const message = result.error?.message ?? 'Creature generation did not complete.';
      return Response.json({ error: message }, { status: response.status || 502 });
    }

    return Response.json({ image: `data:image/png;base64,${result.data[0].b64_json}` });
  } catch (error) {
    const timedOut = error instanceof Error && error.name === 'TimeoutError';
    return Response.json(
      { error: timedOut ? 'Generation took longer than 55 seconds.' : 'Could not generate the creature.' },
      { status: timedOut ? 504 : 500 },
    );
  }
}

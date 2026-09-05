'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { Camera, RotateCcw, ScanLine, Sparkles } from 'lucide-react';

import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

type CameraState = 'starting' | 'ready' | 'error';
type GenerationMode = 'ai' | 'demo';
type Creature = {
  image: string;
  name: string;
  type: string;
  description: string;
  ability: string;
};

async function inspectObject(photo: string) {
  const source = new Image();
  source.src = photo;
  await source.decode();

  const sample = document.createElement('canvas');
  sample.width = 6;
  sample.height = 6;
  const sampleContext = sample.getContext('2d');
  if (!sampleContext) throw new Error('Could not inspect the object.');

  sampleContext.drawImage(source, 0, 0, 6, 6);
  const pixels = sampleContext.getImageData(0, 0, 6, 6).data;
  let red = 0;
  let green = 0;
  let blue = 0;
  for (let index = 0; index < pixels.length; index += 4) {
    red += pixels[index];
    green += pixels[index + 1];
    blue += pixels[index + 2];
  }

  const count = pixels.length / 4;
  return {
    source,
    red: Math.round(red / count),
    green: Math.round(green / count),
    blue: Math.round(blue / count),
  };
}

function createCreatureDetails(red: number, green: number, blue: number) {
  const brightness = (red + green + blue) / 3;
  const strongest = Math.max(red, green, blue);
  const colorFamily =
    strongest === red ? 'Ember' : strongest === green ? 'Moss' : 'Tide';
  const temperament = brightness > 175 ? 'Glow' : brightness < 85 ? 'Shadow' : 'Spark';
  const seed = (red * 3 + green * 5 + blue * 7) % 4;
  const endings = ['ling', 'aroo', 'bit', 'horn'];
  const types = {
    Ember: 'Flame',
    Moss: 'Forest',
    Tide: 'Water',
  } as const;
  const abilities = {
    Ember: 'Confetti Comet',
    Moss: 'Giggle Garden',
    Tide: 'Bubble Bounce',
  } as const;

  return {
    name: `${temperament}${endings[seed]}`,
    type: `${types[colorFamily]} creature`,
    description: `A curious ${colorFamily.toLowerCase()} explorer that turns ordinary objects into tiny adventures.`,
    ability: abilities[colorFamily],
  };
}

async function createDemoCreature(photo: string) {
  const { source, red, green, blue } = await inspectObject(photo);

  const canvas = document.createElement('canvas');
  canvas.width = 1024;
  canvas.height = 1024;
  const context = canvas.getContext('2d');
  if (!context) throw new Error('Could not prepare the demo creature.');

  const color = `rgb(${red} ${green} ${blue})`;
  const darkColor = `rgb(${Math.max(20, red - 65)} ${Math.max(20, green - 65)} ${Math.max(20, blue - 65)})`;

  const background = context.createRadialGradient(512, 420, 80, 512, 512, 700);
  background.addColorStop(0, 'rgb(255 255 255)');
  background.addColorStop(1, `rgb(${Math.min(255, red + 110)} ${Math.min(255, green + 110)} ${Math.min(255, blue + 110)})`);
  context.fillStyle = background;
  context.fillRect(0, 0, 1024, 1024);

  context.save();
  context.shadowColor = 'rgb(30 41 59 / 30%)';
  context.shadowBlur = 45;
  context.fillStyle = color;
  context.beginPath();
  context.ellipse(512, 555, 300, 330, 0, 0, Math.PI * 2);
  context.fill();
  context.restore();

  context.save();
  context.beginPath();
  context.ellipse(512, 555, 280, 310, 0, 0, Math.PI * 2);
  context.clip();
  const scale = Math.max(560 / source.width, 620 / source.height);
  const width = source.width * scale;
  const height = source.height * scale;
  context.drawImage(source, 512 - width / 2, 555 - height / 2, width, height);
  context.fillStyle = `rgb(${red} ${green} ${blue} / 18%)`;
  context.fillRect(210, 235, 604, 650);
  context.restore();

  context.fillStyle = color;
  context.strokeStyle = darkColor;
  context.lineWidth = 18;
  for (const [x, rotation] of [[330, -0.45], [694, 0.45]] as const) {
    context.save();
    context.translate(x, 280);
    context.rotate(rotation);
    context.beginPath();
    context.moveTo(0, 80);
    context.quadraticCurveTo(-75, -15, 0, -120);
    context.quadraticCurveTo(75, -15, 0, 80);
    context.fill();
    context.stroke();
    context.restore();
  }

  for (const x of [405, 619]) {
    context.fillStyle = 'white';
    context.beginPath();
    context.ellipse(x, 455, 78, 92, 0, 0, Math.PI * 2);
    context.fill();
    context.strokeStyle = darkColor;
    context.lineWidth = 14;
    context.stroke();
    context.fillStyle = darkColor;
    context.beginPath();
    context.arc(x + 10, 472, 30, 0, Math.PI * 2);
    context.fill();
    context.fillStyle = 'white';
    context.beginPath();
    context.arc(x + 20, 460, 9, 0, Math.PI * 2);
    context.fill();
  }

  context.strokeStyle = darkColor;
  context.lineWidth = 18;
  context.lineCap = 'round';
  context.beginPath();
  context.arc(512, 580, 95, 0.2, Math.PI - 0.2);
  context.stroke();

  context.fillStyle = color;
  for (const x of [365, 659]) {
    context.beginPath();
    context.roundRect(x - 85, 820, 170, 90, 44);
    context.fill();
    context.strokeStyle = darkColor;
    context.lineWidth = 16;
    context.stroke();
  }

  context.fillStyle = 'rgb(255 255 255 / 90%)';
  for (const [x, y, size] of [[170, 300, 18], [840, 390, 25], [830, 720, 15], [190, 680, 22]] as const) {
    context.save();
    context.translate(x, y);
    context.rotate(Math.PI / 4);
    context.fillRect(-size / 2, -size * 2, size, size * 4);
    context.fillRect(-size * 2, -size / 2, size * 4, size);
    context.restore();
  }

  await new Promise((resolve) => window.setTimeout(resolve, 1400));
  return {
    image: canvas.toDataURL('image/png'),
    ...createCreatureDetails(red, green, blue),
  };
}

export default function Home() {
  const videoRef = useRef<HTMLVideoElement>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const [cameraState, setCameraState] = useState<CameraState>('starting');
  const [photo, setPhoto] = useState<string | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [creature, setCreature] = useState<Creature | null>(null);
  const [generationMode, setGenerationMode] = useState<GenerationMode | null>(null);
  const [generating, setGenerating] = useState(false);
  const [generationError, setGenerationError] = useState<string | null>(null);

  const startCamera = useCallback(async () => {
    setCameraState('starting');
    setPhoto(null);
    setAccepted(false);
    setCreature(null);
    setGenerationMode(null);
    setGenerationError(null);

    try {
      streamRef.current?.getTracks().forEach((track) => track.stop());
      const stream = await navigator.mediaDevices.getUserMedia({
        audio: false,
        video: { width: { ideal: 1280 }, height: { ideal: 720 } },
      });

      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        await videoRef.current.play();
      }
      setCameraState('ready');
    } catch {
      setCameraState('error');
    }
  }, []);

  useEffect(() => {
    const frame = window.requestAnimationFrame(() => void startCamera());
    return () => {
      window.cancelAnimationFrame(frame);
      streamRef.current?.getTracks().forEach((track) => track.stop());
    };
  }, [startCamera]);

  function takePhoto() {
    const video = videoRef.current;
    if (!video || video.videoWidth === 0 || video.videoHeight === 0) return;

    const canvas = document.createElement('canvas');
    const cropSize = Math.min(video.videoWidth, video.videoHeight) * 0.8;
    const cropX = (video.videoWidth - cropSize) / 2;
    const cropY = (video.videoHeight - cropSize) / 2;
    canvas.width = 1024;
    canvas.height = 1024;
    const context = canvas.getContext('2d');
    if (!context) return;

    context.drawImage(
      video,
      cropX,
      cropY,
      cropSize,
      cropSize,
      0,
      0,
      canvas.width,
      canvas.height,
    );
    setPhoto(canvas.toDataURL('image/jpeg', 0.9));
    setAccepted(false);
  }

  function retakePhoto() {
    setPhoto(null);
    setAccepted(false);
    setCreature(null);
    setGenerationMode(null);
    setGenerationError(null);
  }

  async function createCreature() {
    if (!photo || generating) return;
    setAccepted(true);
    setGenerating(true);
    setGenerationError(null);

    try {
      const response = await fetch('/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ image: photo }),
      });
      const result = (await response.json()) as {
        image?: string;
        profile?: Omit<Creature, 'image'>;
        code?: string;
        error?: string;
      };
      if (response.ok && result.image && result.profile) {
        setCreature({ image: result.image, ...result.profile });
        setGenerationMode('ai');
      } else if (result.code === 'missing_api_key') {
        setCreature(await createDemoCreature(photo));
        setGenerationMode('demo');
      } else {
        throw new Error(result.error ?? 'Creature generation failed.');
      }
    } catch (error) {
      setAccepted(false);
      setGenerationError(error instanceof Error ? error.message : 'Creature generation failed.');
    } finally {
      setGenerating(false);
    }
  }

  return (
    <main className="min-h-screen px-4 py-6 sm:px-8 sm:py-10">
      <div className="mx-auto w-full max-w-5xl">
        <header className="mb-6 flex items-center gap-3 sm:mb-8">
          <div className="grid size-11 place-items-center rounded-2xl bg-primary text-primary-foreground shadow-lg shadow-primary/20">
            <ScanLine className="size-6" aria-hidden="true" />
          </div>
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">Jarz Rover</p>
            <h1 className="text-2xl font-black tracking-tight sm:text-3xl">Creature Lab</h1>
          </div>
        </header>

        <div className="grid gap-5 lg:grid-cols-[minmax(0,1fr)_300px]">
          <Card className="border-2 border-white/70 bg-card/90 py-0 shadow-2xl shadow-slate-950/10">
            <div className="relative aspect-video overflow-hidden bg-slate-950">
              <video
                ref={videoRef}
                className={`h-full w-full object-cover ${photo ? 'invisible' : ''}`}
                playsInline
                muted
                aria-label="Live computer camera"
              />

              {photo && (
                // eslint-disable-next-line @next/next/no-img-element
                <img src={photo} alt="Captured object" className="absolute inset-0 h-full w-full object-cover" />
              )}

              {!photo && cameraState === 'starting' && (
                <div className="absolute inset-0 grid place-items-center text-center text-white">
                  <div>
                    <Camera className="mx-auto mb-3 size-9 animate-pulse" />
                    <p className="font-semibold">Starting camera…</p>
                  </div>
                </div>
              )}

              {!photo && cameraState === 'error' && (
                <div className="absolute inset-0 grid place-items-center p-6 text-center text-white">
                  <div>
                    <Camera className="mx-auto mb-3 size-9" />
                    <p className="text-lg font-bold">Camera access is blocked</p>
                    <p className="mt-1 max-w-sm text-sm text-slate-300">Allow camera access in your browser, then try again.</p>
                    <Button className="mt-5" onClick={() => void startCamera()}>Try again</Button>
                  </div>
                </div>
              )}

              {!photo && cameraState === 'ready' && (
                <div className="pointer-events-none absolute inset-y-[10%] left-1/2 aspect-square -translate-x-1/2 rounded-3xl border-2 border-dashed border-white/85 shadow-[0_0_0_999px_rgb(2_6_23/28%)]">
                  <span className="absolute bottom-3 left-1/2 -translate-x-1/2 whitespace-nowrap rounded-full bg-slate-950/75 px-3 py-1 text-sm font-bold text-white">
                    Keep only the object in this box
                  </span>
                </div>
              )}

              {generating && (
                <div className="absolute inset-0 grid place-items-center bg-indigo-950/80 p-6 text-center text-white backdrop-blur-sm">
                  <div>
                    <div className="mx-auto mb-4 grid size-16 place-items-center rounded-full bg-violet-300 text-violet-950">
                      <Sparkles className="size-9 animate-pulse" />
                    </div>
                    <p className="text-2xl font-black">Creating your creature…</p>
                    <p className="mt-2 text-violet-100">This usually takes 20–40 seconds.</p>
                  </div>
                </div>
              )}
            </div>

            <div className="flex flex-col gap-3 border-t bg-white/75 p-4 sm:flex-row sm:items-center sm:justify-between sm:p-5">
              <p className="text-sm font-medium text-muted-foreground">
                {photo ? 'Is the object clear with no people visible?' : 'Only the boxed area will be used.'}
              </p>

              <div className="flex gap-2">
                {photo ? (
                  <>
                    <Button variant="outline" size="lg" className="h-11 flex-1 px-4 sm:flex-none" onClick={retakePhoto}>
                      <RotateCcw data-icon="inline-start" /> Retake
                    </Button>
                    <Button size="lg" className="h-11 flex-1 px-5 sm:flex-none" onClick={() => void createCreature()} disabled={accepted || generating}>
                      <Sparkles data-icon="inline-start" /> Create creature
                    </Button>
                  </>
                ) : (
                  <Button size="lg" className="h-12 w-full px-7 text-base sm:w-auto" onClick={takePhoto} disabled={cameraState !== 'ready'}>
                    <Camera data-icon="inline-start" /> Take photo
                  </Button>
                )}
              </div>
              {generationError && (
                <p className="w-full text-sm font-semibold text-destructive sm:text-right" role="alert">
                  {generationError}
                </p>
              )}
            </div>
          </Card>

          <Card className="border-white/70 bg-card/75 shadow-xl shadow-slate-950/5">
            <CardHeader>
              <CardTitle className="text-lg font-black">{creature ? 'Creature discovered!' : 'Step 2 of 3'}</CardTitle>
              <CardDescription>{creature ? 'Your first AI transformation worked.' : 'Capture and transform one object.'}</CardDescription>
            </CardHeader>
            <CardContent>
              <ol className="space-y-4 text-sm">
                <li className="flex gap-3"><span className="step-number">1</span><span>Hold an object in front of the camera.</span></li>
                <li className="flex gap-3"><span className="step-number">2</span><span>Keep your hands and face outside the frame.</span></li>
                <li className="flex gap-3"><span className="step-number">3</span><span>Take the picture and check that it is clear.</span></li>
              </ol>
              {creature ? (
                <div className="mt-6 overflow-hidden rounded-2xl border-2 border-violet-200 bg-white p-2">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={creature.image} alt={`${creature.name}, a discovered Jarz creature`} className="aspect-square w-full rounded-xl object-cover" />
                  {generationMode === 'demo' && (
                    <p className="px-2 pb-1 pt-3 text-center text-xs font-bold uppercase tracking-wider text-violet-700">
                      Local demo creature
                    </p>
                  )}
                  <div className="px-2 pb-2 pt-3">
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <h2 className="text-xl font-black tracking-tight">{creature.name}</h2>
                        <p className="text-sm font-bold text-violet-700">{creature.type}</p>
                      </div>
                      <Sparkles className="mt-1 size-5 shrink-0 text-violet-600" aria-hidden="true" />
                    </div>
                    <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{creature.description}</p>
                    <div className="mt-3 rounded-xl bg-violet-100 px-3 py-2 text-sm text-violet-950">
                      <span className="font-black">Special ability:</span> {creature.ability}
                    </div>
                  </div>
                  <Button className="mt-2 h-11 w-full" onClick={() => void startCamera()}>
                    <RotateCcw data-icon="inline-start" /> New discovery
                  </Button>
                </div>
              ) : (
                <div className="mt-6 rounded-2xl bg-secondary p-4 text-sm text-secondary-foreground">
                  <p className="font-bold">Today’s goal</p>
                  <p className="mt-1 opacity-75">Create our first real AI creature from a camera photo.</p>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </main>
  );
}

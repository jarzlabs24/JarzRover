'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { Camera, Check, RotateCcw, ScanLine, Sparkles } from 'lucide-react';

import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

type CameraState = 'starting' | 'ready' | 'error';

export default function Home() {
  const videoRef = useRef<HTMLVideoElement>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const [cameraState, setCameraState] = useState<CameraState>('starting');
  const [photo, setPhoto] = useState<string | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [creature, setCreature] = useState<string | null>(null);
  const [generating, setGenerating] = useState(false);
  const [generationError, setGenerationError] = useState<string | null>(null);

  const startCamera = useCallback(async () => {
    setCameraState('starting');
    setPhoto(null);
    setAccepted(false);
    setCreature(null);
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
    void startCamera();
    return () => streamRef.current?.getTracks().forEach((track) => track.stop());
  }, [startCamera]);

  function takePhoto() {
    const video = videoRef.current;
    if (!video || video.videoWidth === 0 || video.videoHeight === 0) return;

    const canvas = document.createElement('canvas');
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const context = canvas.getContext('2d');
    if (!context) return;

    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    setPhoto(canvas.toDataURL('image/jpeg', 0.9));
    setAccepted(false);
  }

  function retakePhoto() {
    setPhoto(null);
    setAccepted(false);
    setCreature(null);
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
      const result = (await response.json()) as { image?: string; error?: string };
      if (!response.ok || !result.image) throw new Error(result.error ?? 'Creature generation failed.');
      setCreature(result.image);
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
                <div className="pointer-events-none absolute inset-[10%] rounded-3xl border-2 border-dashed border-white/75 shadow-[0_0_0_999px_rgb(2_6_23/12%)]" />
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
                {photo ? 'Is the object clear and centered?' : 'Place one object inside the frame.'}
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
                  <img src={creature} alt="AI-generated Jarz creature" className="aspect-square w-full rounded-xl object-cover" />
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

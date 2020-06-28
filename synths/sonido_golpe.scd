SynthDef(\sonido_golpe, {
    |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, ruido;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    ruido = WhiteNoise.ar(env1);
    ruido = HPF.ar(ruido, 1000);
    ruido = LPF.ar(ruido, 7600);
    ruido = BPF.ar(ruido, 1230, 0.7, 0.7);

    //snd = noise1 + noise2;
	snd = ruido;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).play;
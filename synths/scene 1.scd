Server.default = s = Server.internal.boot;

{ SinOsc.ar(440) + SinOsc.ar(630) + SinOsc.ar(1033) }.play


//sonido del golpe

SynthDef(\golpe, { |out, freq = 400, sustain = 1, amp = 0.3|
    Out.ar(out,
        SinOsc.ar(freq, 0, 0.5) * Line.kr(amp, 0, sustain, doneAction: Done.freeSelf)
    )
}).load(s);

Synth("golpe");


(
SynthDef('kick', {

    var osc, env, output;

    osc = {SinOsc.ar(60)};
    env = {Line.ar(1, 0, 1, doneAction: 2)};

    output = osc * env;

    Out.ar(0,
        Pan2.ar(output, 0)
    )

}).load(s);
)

Synth('kick');

//sonido del ambiente

SynthDef(\viento, {
	arg inbus;
	var w1, w2;								//two identical functions, one left, one right
	w1=RLPF.ar(
		WhiteNoise.ar(1), 					//normal level, out level comes later
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,//filter controlled by global envelope.
												//Beware of low cutoff when using RLPF
		LFNoise1.kr(0.4, 0.45, 0.55),  // 0.55 to 1 varying reciprocal Q
		0.1*In.kr(inbus, 1)			//low level, controlled by global envelope
	);
	w2=RLPF.ar(
		WhiteNoise.ar(1),
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,
		LFNoise1.kr(0.4, 0.45, 0.55),
		0.1*In.kr(inbus, 1)
	);
	Out.ar(0,[w1, w2] )
}).load(s);

Synth("viento");



//sonido del palo




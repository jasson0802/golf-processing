//Caso 5 - Sintesis de Sonido
//Jose Pablo Mayorga
//Gabriel Calvo
//Jasson Gonzalez


//Bola rebotando
// Env controla velocidad de la bola
//NetAddr.localAddr;


//Direccion osc de processing, puerto
n=NetAddr("192.168.0.3", 12000); //JP

//Definicion de mensaje osc
OSCFunc({|msg|
  msg.postln;  //debug
  n.sendMsg(*msg);
}, '/moveBallX');


//Definicion de mensaje osc
OSCFunc({|msg|
  msg.postln;  //debug
  n.sendMsg(*msg);
}, '/ballFall');

//Definicion de mensaje osc
OSCFunc({|msg|
  msg.postln;  //debug
  n.sendMsg(*msg);
}, '/moveClub');


(SynthDef(\movimiento,
{
		arg time = 1.2, freq = 1000;
		var sig, ratio, output, movementTime;
		sig = PinkNoise.ar(0.5);
		ratio = 0.1;
		movementTime = Line.ar(10, 0, time, doneAction:2);
		output = Resonz.ar(sig, freq, ratio)*movementTime;
		SendReply.ar(output, '/moveClub', movementTime);
		Out.ar([0,1], output);
}).add;)

//Synth que simula bola en movimiento
(SynthDef(\bolaRodando, {
	var t, envPaneo, paneoPos, output;
	envPaneo = Env.new([-1, 1], [3, 2, 4]);
	t = TBall.ar(in: LFNoise0.ar(50), g:5, damp:0.01, friction: 0.01);
	paneoPos = EnvGen.kr(envPaneo, doneAction: 2);
	output = Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), paneoPos);

	//Parametros de SendReply trigger, nombre del mensaje, valores flotantes
	SendReply.ar(output, '/moveBallX', paneoPos);

	output = Delay1.ar(in: output, mul: 1, add: 0);
	Out.ar(0, output);
}).add;)

//Crowd noise
(SynthDef(\crowd,
{

		Out.ar([0,1],
			BPF.ar(WhiteNoise.ar, Rand(800, 1200), Rand(0.1,0.9))*LFCub.ar(Rand(0.02,0.2), 0.5)
		)
}).add;
)

//Fall noise
(SynthDef(\drop,
{
		var output, dropEnv;
		e=Env.new([10, 9, 7, 3, 0],[0.5, 1, 2, 3], \linear);
		dropEnv=EnvGen.kr(e, doneAction: 2);
		output = dropEnv*SinOsc.ar(Line.kr(1000, 50, 6.5), mul:0.1);
		SendReply.ar(output, '/ballFall', dropEnv);
		Out.ar(0, output);
}).add;
)


//Golpe
(SynthDef(\sonido_golpe, {
    |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, ruido;

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

	snd = ruido;
    snd = snd * 2;
    snd = snd.softclip;
	snd = GVerb.ar(snd, roomsize: 10, revtime: 3, damping: 0.5, inputbw: 0.5, spread: 15, drylevel: 1, earlyreflevel: 0.7, taillevel: 0.5, maxroomsize: 300, mul: 1, add: 0);

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;)

(
{
	Synth(\movimiento, [\time, 2, \freq, 400]);
	1.5.wait;
	Synth(\sonido_golpe);
	1.wait;
	Synth(\bolaRodando);
	Synth(\crowd);
	4.0.wait;
	Synth(\drop);
	1.0.wait;
}.fork;
)









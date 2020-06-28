//Caso 5 - Sintesis de Sonido
//Jose Pablo Mayorga
//Gabriel Calvo
//Jasson Gonzalez


//Bola rebotando
// Env controla velocidad de la bola
//NetAddr.localAddr;


//Direccion osc de processing, puerto
//n=NetAddr("127.0.0.1" 57120); //JP

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


(SynthDef(\golpe,
{
		var time, sig, freq, ratio, output;
		time = 1.2;
		sig = PinkNoise.ar(0.5);
		ratio = 0.1;
		freq = 1000;
		output = Resonz.ar(sig, freq, ratio)*Line.ar(10, 0, time, doneAction:2);
		Out.ar([0,1], output);
}).add;)

//Synth que simula bola en movimiento
SynthDef(\bolaRodando, {
	var t, envPaneo, paneoPos, output;
	envPaneo = Env.new([-1, 1], [3, 2, 4]);
	t = TBall.ar(in: LFNoise0.ar(50), g:5, damp:0.01, friction: 0.01);
	paneoPos = EnvGen.kr(envPaneo, doneAction: 2);
	output = Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), paneoPos);

	//Parametros de SendReply trigger, nombre del mensaje, valores flotantes
	SendReply.ar(output, '/moveBallX', paneoPos);

	Out.ar(0, output);
}).add;

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


(
{
	Synth(\golpe);
	Synth(\crowd);

	Synth(\bolaRodando);

	4.0.wait;

	Synth(\drop);

	1.0.wait;

	//Synth(\event);

	//1.0.wait;

	//Synth(\event);
}.fork;
)







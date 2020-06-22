//Caso 5 - Sintesis de Sonido
//Jose Pablo Mayorga
//Gabriel Calvo
//Jasson Gonzalez


//Bola rebotando
// Env controla velocidad de la bola

/*(
c = Bus.control(s, 1);

r = Routine({
	inf.do({
		var val = c.getSynchronous;
		n.sendMsg(\posicionBolaX, val.postln);
		0.1.wait;
	});
});
)*/

NetAddr.localAddr;
n=NetAddr("192.168.0.3", 12000);

OSCFunc({|msg|
  msg.postln;  //debug
  n.sendMsg(*msg);
}, '/moveBallX');


SynthDef(\bolaRodando, {|bus|
	var t, envPaneo, paneoPos, output;
	envPaneo = Env.new([-1, 1], [3, 2, 4]);
	t = TBall.ar(in: LFNoise0.ar(50), g:5, damp:0.01, friction: 0.01);
	paneoPos = EnvGen.kr(envPaneo, doneAction: 2);
	output = Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), paneoPos);
	SendReply.ar(output, '/moveBallX', paneoPos);//60 is updaterate (fps)

	Out.ar(0, output);
}).add;




b = Synth(\bolaRodando, [\bus, c]);

r.play;

//Crowd noise
(SynthDef(\crowd,
{

		Out.ar([0,1],
			BPF.ar(WhiteNoise.ar, Rand(800, 1200), Rand(0.1,0.9))*LFSaw.ar(Rand(0.2,0.8), 0.5)
		)
}).play;)

3.do(Synth(\crowd))

//Fall noise
(SynthDef(\drop,
{
		e=Env.new([10, 9, 7, 3, 0],[0.5, 1, 2, 3], \linear);
		{EnvGen.kr(e, doneAction: 2)*SinOsc.ar(Line.kr(1000, 50, 6.5), mul:0.1)}.play
}
).play;
)
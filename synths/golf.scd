//Caso 5 - Sintesis de Sonido
//Jose Pablo Mayorga
//Gabriel Calvo
//Jasson Gonzalez



//Synths
SynthDef(\bolaMovimiento,
{

//Bola rebotando
// mouse x controls switch of level
// mouse y controls gravity
    var t, sf;
    sf = K2A.ar(MouseX.kr > 0.5) > 0;
    t = TBall.ar(sf, MouseY.kr(0.01, 1.0, 1), 0.01);
		Out.ar(0, Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), MouseX.kr(-1,1)));
}).load(s);

10.do(Synth("miSynth"));


//Bola rebotando
// mouse x controls switch of level
// mouse y controls gravity
(
{
    var t, sf;
    sf = K2A.ar(MouseX.kr > 0.5) > 0;
    t = TBall.ar(sf, MouseY.kr(0.01, 1.0, 1), 0.01);
    Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), MouseX.kr(-1,1));
}.play;
)

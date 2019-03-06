# Quantum Penny Flip
<p align=justify>
Quantum Penny Flip (QPF) is the first of the Quantum Serious Games (QSG) series, developed by the Group of Research in Interactive Technologies (GTI) @ Universidad Nacional de Mar del Plata, Argentina.

The aim of this series is to provide interactive experiences to visualize quantum effects, specially those applicable to quantum computing. These can aid education, research and development in the quantum computing field.
</p>

## The Videogame
<p align=justify>
The game consists in flipping falling black and white coins so that they all end up black when they reach the bottom of the screen. 

The game is set in a simple Tetris-like interface. There's a forbidden zone in the center of the field, marked red. In this  one, the player cannot flip the coin, but the computer can. 

From time to time a power up may appear, in the shape of a blue circle with an "H" inside - this item establishes barriers at both sides of the zone that sets the coins in a superposition (half black, half white) state. It seems clear after a while that the first barrier sets the superposition, and the second one turns things back into normal.
</p>

## The Objective
<p align=justify>
The hidden objective behind this apparently innocent game is to show some quantum concepts relevant to quantum computing:

1. The coins represent qubits, with its colors accounting for the states |0> and |1>. 

2. Touching the qubit equals applying a NOT gate, thus inverting its state. 

3. The blue "H" power up is the Hadamard gate, which sets the qubit in a superposition state. Since the Hadamard gate is its own reverse, the double application of the gate returns the qubit to its original state.

The game is also based on an actual quantum game theory algorithm, so it is useful towards its understanding.
</p>

## The Background (Wikipedia)
<p align=justify>
Quantum computing is the use of quantum-mechanical phenomena such as superposition and entanglement to perform computation. A quantum computer is used to perform such computation, which can be implemented theoretically or physically (1).

Quantum game theory is an extension of classical game theory to the quantum domain. Its roots stretch back to a paper published in 1999 by mathematician David Meyer of the University of California, San Diego (2). 

In the Quantum Penny Flip game, Meyer showed how a quantum approach always beats a classical strategy in a simple game where two players flip a coin. This is because the laws of quantum mechanics allow the coin to exist in a state that is a combination of heads-up and tails-up at the same time, so the person playing by classical rules will always be outmanoeuvred.

A serious game or applied game is a game designed for a primary purpose other than pure entertainment (3). The "serious" adjective is generally prepended to refer to video games used by industries like defense, education, scientific exploration, health care, emergency management, city planning, engineering, and politics (4). Serious games are a subgenre of serious storytelling, where storytelling is applied "outside the context of entertainment, where the narration progresses as a sequence of patterns impressive in quality ... and is part of a thoughtful progress" (5). The idea shares aspects with simulation generally, including flight simulation and medical simulation, but explicitly emphasizes the added pedagogical value of fun and competition. 
</p>

## The Authors
<p align=justify>
QPF was designed at GTI, and coded by Juan Pablo Cardoso, a student in computer engineering at the University.
</p>

## The Licence
<p align=justify>
Care was taken to achieve results consistent with open source standards, making the game available for use and modifications with no strings attached to propietary media or tools.

The game is distributed under the GNU Licence. Its source code and exports to different platforms are available at https://github.com/estebanzapirain/qpenny-flip.

The game was coded in Godot, an open source, cross-platform videogame development engine created by Juan Linietsky (godotengine.org).

Media used in the game are under Creative Commons licences.
</p>

## The Sources
<p align=justify>
(1) The National Academies of Sciences, Engineering, and Medicine (2019). Grumbling, Emily; Horowitz, Mark, eds. Quantum Computing : Progress and Prospects (2018). Washington, DC: National Academies Press. p. I-5. doi:10.17226/25196. ISBN 978-0-309-47969-1. OCLC 1081001288.

(2) Meyer, D. A. Phys. Rev. Lett. 82, 1052–1055 (1999).

(3) Djaouti, Damien; Alvarez, Julian; Jessel, Jean-Pierre. "Classifying Serious Games: the G/P/S model" (PDF). Retrieved 26 June 2015.

(4) "Serious Games". cs.gmu.edu. Retrieved 26 June 2015.

(5) Lugmayr, Artur; Suhonen, Jarkko; Hlavacs, Helmut; Montero, Calkin; Suutinen, Erkki; Sedano, Carolina (2016). "Serious storytelling - a first definition and review". Multimedia Tools and Applications. 76 (14): 15707–15733. doi:10.1007/s11042-016-3865-5.
</p>

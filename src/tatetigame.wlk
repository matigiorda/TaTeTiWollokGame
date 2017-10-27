object tablero{
	const imagen = "tablero.png"
	const position = game.origin()
	var rival = rivalFacil
	const jugadores = [jugador2, rival] //El jugador 2 siempre juega (y es una persona)
	//La coleccion esta para resetear las jugadas de ambos jugadores al finalizar
	var posicionesDelJuego = [1,2,3,4,5,6,7,8,9]
	var turno = 1
	method posicionesDelJuego() = posicionesDelJuego
	method elegirRival(jugador)
	{
		rival = jugador
	}
	method turno() = turno
	method cambiarTurno()
	{
		turno += 1
	}
	method iniciar()
	{
		game.width(9)
		game.height(9)
		game.start()
		//game.addVisual(self)
	}
	method jugarTurno(jugador, posicion)
	{
		if(not jugador.correspondeJugar(turno)) error.throwWithMessage("No es el turno del jugador")
		game.addVisualIn(jugador.icono(), posicionesDelTablero.positions().get(posicion - 1))
		posicionesDelJuego.remove(posicion)
		jugador.aniadirJugada(posicion)
		self.cambiarTurno()
		if(jugador.esGanador())
		{
			//jugador.mensajeVictoria()
			self.reset()
		}
		if(self.estaLleno()) 
		{
			//Enviar mensaje de empate
			self.reset()
		}
	}
	method posicionHabilitada(posicion)
	{
		return posicionesDelJuego.contains(posicion)
	}
	method reset()
	{
		posicionesDelJuego = [1,2,3,4,5,6,7,8,9]
		turno = 1
		jugadores.forEach({unJugador => unJugador.volverAEmpezar()})
		//Aviso de reset
		game.clear()
		game.addVisual(self)
	}
	method estaVacio()
	{
		return posicionesDelJuego.size() == 9
	}
	method estaLleno()
	{
		return posicionesDelJuego.isEmpty()
	}
	}

//Clase abstracta
class Jugador
{
	var jugada = #{}
	method jugar(posicion)
	{
		if(not tablero.posicionHabilitada(posicion)) error.throwWithMessage("Posicion no habilitada")
		tablero.jugarTurno(self, posicion)
	}
	method aniadirJugada(posicion)
	{
		jugada.add(posicion)
	}
	method esGanador()
	{
		//Verifica que alguna de las combinaciones ganadoras coincida con la jugada del jugador (self)
		return combinacionesGanadoras.combinaciones().any({combinacion => self.matchea(combinacion)})
	}
	// Verifica que todos los elementos de una combinacion ganadora este incluida dentro de la jugada actual
	method matchea(combinacionGanadora) = combinacionGanadora.all({elemento => jugada.contains(elemento)})
	method volverAEmpezar()
	{
		jugada = #{}
	}
}

class Jugador1 inherits Jugador
{
	const icono = cruz
	method icono() = icono
	method correspondeJugar(turno)
	{
		return turno.odd()
	}
	method mensajeVictoria()
	{
		game.say(tablero,"El ganador es el Jugador1")
	}
}

object jugador2 inherits Jugador
{
	const icono = circulo
	method icono() = icono
	method correspondeJugar(turno)
	{
		return turno.even()
	}
		
	method mensajeVictoria()
	{	
		game.say(tablero,"El ganador es el Jugador2")
	}
}

object rivalFacil inherits Jugador1
{
	method jugar()
	{
		//Juega en cualquier posicion
		tablero.jugarTurno(self, tablero.posicionesDelJuego().anyOne())
	}
}

object combinacionesGanadoras
{
	const combinaciones = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,6,9],[3,5,7],[4,5,6],[7,8,9]]
	method combinaciones() = combinaciones
}

object posicionesDelTablero
//Para que el tablero no tenga multiples referencias de posicion
{
	const positions = [game.at(0,6), game.at(3,6), game.at(6,6), game.at(0,3), game.at(3,3), game.at(6,3), game.at(0,0), game.at(3,0), game.at(6,0)]
	method positions() = positions
}

object cruz
{
	const imagen = "cruz.png"
}

object circulo
{
	const imagen = "circulo.png"
}
object tablero{
	const tablero = "tablero.png"
	const jugadores = [jugador2] //El jugador 2 siempre juega (y es una persona)
	var posicionesDelJuego = [1,2,3,4,5,6,7,8,9]
	//const posicionesDelTablero = [xx, xx, xx, xx, xx, xx, xx, xx, xx]
	var turno = 1
	method posicionesDelJuego() = posicionesDelJuego
	method aniadirJugador(jugador)
	{
		if(jugadores.size() == 2) error.throwWithMessage("Solo puede haber 2 jugadores como maximo")
		jugadores.add(jugador)
	}
	method cambiarTurno()
	{
		turno += 1
	}
	method jugarTurno(jugador, posicion)
	{
		if(not jugador.correspondeJugar(turno)) error.throwWithMessage("No es el turno del jugador")
		//Mostrar mensaje "Se ha jugado en (posicion)"
		//game.addVisualIn(jugador.icono(), posicionesDelTablero.get(posicion))
		posicionesDelJuego.remove(posicion)
		jugador.aniadirJugada(posicion)
		self.cambiarTurno()
		if(jugador.esGanador())
		{
			//Enviar mensaje ganador
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
		//game.clean()
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
	const icono = "cruz.png"
	method correspondeJugar(turno)
	{
		return turno.odd()
	}
}

object jugador2 inherits Jugador
{
	const icono = "circulo.png"
	method correspondeJugar(turno)
	{
		return turno.even()
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


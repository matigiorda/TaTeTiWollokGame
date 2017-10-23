object tablero{
	const tablero = "tablero.png"
	var posicionesDelJuego = [1,2,3,4,5,6,7,8,9]
	//const posicionesDelTablero = [xx, xx, xx, xx, xx, xx, xx, xx, xx]
	var turno = 1
	method cambiarTurno()
	{
		turno++
	}
	method jugarTurno(jugador, posicion)
	{
		//game.addVisualIn(jugador.icono(), posicionesDelTablero.get(posicion))
		posicionesDelJuego.remove(posicion)
		jugador.esGanador()
	}
	method posicionHabilitada(posicion)
	{
		return posicionesDelJuego.contains(posicion)
	}
	method reset()
	{
		posicionesDelJuego = [1,2,3,4,5,6,7,8,9]
		turno = 1
	}

}

object jugador
{
	var turno
	var jugada = #{}
	method jugar(posicion)
	{
		if(not tablero.posicionHabilitada(posicion)) error.throwWithMessage("Posicion no habilitada")
		tablero.jugarTurno(self, posicion)
		jugada.add(posicion)
	}
	method esGanador()
	{
		//Verifica que alguna de las combinaciones ganadoras coincida con la jugada del jugador(self)
		return combinacionesGanadoras.combinaciones().any({combinacion => self.matchea(combinacion)})
	}
	// Verifica que una combinacion ganadora coincida con la jugada actual
	method matchea(combinacion) = combinacion.all({elemento => jugada.contains(elemento)})
	
}

object combinacionesGanadoras
{
	const combinaciones = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,6,9],[3,5,7],[4,5,6],[7,8,9]]
	method combinaciones() = combinaciones
}
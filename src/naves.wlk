class Nave{
	var property velocidad
	var property direccion = 0
	var property combustible
	
	method acelerar(nuevaVel){velocidad = 100000.min(velocidad+nuevaVel)}
	method desacelerar(nuevaVel){velocidad = 0.max(velocidad-nuevaVel)}
	method irHaciaElSol(){direccion=10}
	method escaparDelSol(){direccion=-10}
	method ponerseParaleloAlSol(){direccion=0}
	method acercarseUnPocoAlSol(){direccion= 10.min(direccion+1)}
	method alejarseUnPocoDelSol(){direccion=(-10).max(direccion-1)}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method cargarCombustible(valor){combustible+=valor}
	method descargarCombustible(valor){combustible-=0.max(combustible-valor)}
	method estaTranquila() = combustible>=4000 and velocidad<=12000
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	method estaRelajada() = self.estaTranquila() and self.tienePocaActividad()
	method tienePocaActividad()
}

class NaveBaliza inherits Nave{
	var color
	var cambioDeColor = false
	
	method color() = color
	method cambiarColor(nuevoColor){
		color=nuevoColor
		cambioDeColor = true
	}
	override method prepararViaje(){
		super()
		self.cambiarColor("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila() = super() and color!="rojo"
	override method escapar(){self.irHaciaElSol()}
	override method avisar(){self.cambiarColor("rojo")}
	override method tienePocaActividad() = cambioDeColor
}

class NavePasajeros inherits Nave{
	var property pasajeros
	var property racionesComida = 0
	var property racionesBebida = 0
	var comidaServida = 0
	
	method cargarComida(valor){racionesComida=valor}
	method descargarComida(valor){
		racionesComida-=0.max(racionesComida-valor)
		comidaServida+=valor
	}
	method cargarBebida(valor){racionesBebida=valor}
	method descargarBebida(valor){racionesBebida-=0.max(racionesBebida-valor)}
	override method prepararViaje(){
		super()
		self.cargarComida(4*pasajeros)
		self.cargarBebida(6*pasajeros)
		self.acercarseUnPocoAlSol()
	}
	override method escapar(){self.acelerar(velocidad*2)}
	override method avisar(){
		self.descargarComida(1*pasajeros)
		self.descargarBebida(2*pasajeros)
	}
	override method tienePocaActividad() = comidaServida<50
}

class NaveHospital inherits NavePasajeros{
	var property quirofanosListos
	
	override method estaTranquila() = super() and not quirofanosListos
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
	method prepararQuirofanos(){quirofanosListos=true}
}

class NaveCombate inherits Nave{
	var estaVisible = true
	var misilesDesplegados = false
	const mensajesEmitidos = []
	
	method estaVisible() = estaVisible
	method ponerseVisible(){estaVisible=true}
	method ponerseInvisible(){estaVisible=false}
	method misilesDesplegados() = misilesDesplegados
	method desplegarMisiles(){misilesDesplegados=true}
	method replegarMisiles(){misilesDesplegados=false}
	method mensajesEmitidos() = mensajesEmitidos
	method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
	method primerMensaje() = mensajesEmitidos.first()
	method ultimoMensaje() = mensajesEmitidos.last()
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
	method esEscueta() = mensajesEmitidos.all({m=>m.size()<=30})
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("saliendo en mision")
	}
	override method estaTranquila() = super() and not misilesDesplegados
	override method escapar(){
		self.alejarseUnPocoDelSol()
		self.alejarseUnPocoDelSol()
	}
	override method avisar(){self.emitirMensaje("amenaza recibida")}
	override method tienePocaActividad() = self.esEscueta()
}

class NaveCombateSigilosa inherits NaveCombate{
	override method estaTranquila() = super() and estaVisible
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}
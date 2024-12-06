<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Banco UTN - Gestión de Préstamos</title>
<style>
.resumen-prestamo {
	background-color: #e6f7f9;
	border: 1px solid #d1e7dd;
	border-radius: 5px;
	padding: 15px;
	margin-top: 15px;
}

form {
    padding: 10px; 
}

label {
    display: block; 
    margin-bottom: 8px; 
    
}

input,
select {
    margin-bottom: 15px; 
}

label + label {
    margin-top: 20px; 
}

.btn-container {
	text-align: right;
	margin-top: 1rem;
}

.btn {
	margin-right: 0.5rem;
}

.contenedor-principal {
	width: 50%;
}

.btn-seccion {
	text-align: right;
	margin-top: 2rem;
}

</style>
</head>
<body>

	<%@ include file="Componentes/Head.jsp"%>
	<jsp:include page="Componentes/Navbar.jsp"></jsp:include>

	<div class="d-flex flex-column justify-content-center align-items-center vh-100">
		<div class="contenedor-principal p-4 bg-light border rounded">
			<form>
				<div class="form-group">
					<label for="monto">Monto</label> 
					<input type="text" class="form-control" id="monto" placeholder="$10000.00">
				</div>
				<div class="form-group">
					<label for="tipo-prestamo">Tipo de préstamo</label> 
					<select class="form-control" id="tipo-prestamo">
						<option value="personal">Personal</option>
						<option value="hipotecario">Hipotecario</option>
						<option value="automotriz">Automotriz</option>
					</select>
				</div>
				<div class="form-group">
					<label for="plazo-cuotas">Plazo en cuotas</label> 
					<select class="form-control" id="plazo-cuotas">
						<option value="12">12 meses</option>
						<option value="24">24 meses</option>
						<option value="36">36 meses</option>
					</select>
				</div>
				<div class="form-group">
					<label for="cuenta-acreditacion">Cuenta para acreditación</label> 
					<select class="form-control" id="cuenta-acreditacion">
						<option value="cuenta1">Cuenta 1</option>
						<option value="cuenta2">Cuenta 2</option>
						<option value="cuenta3">Cuenta 3</option>
					</select>
				</div>
				<div class="resumen-prestamo">
					<label>Resumen del préstamo</label>
					<p>
						Monto solicitado: <span id="monto-solicitado"></span>
					</p>
					<p>
						Plazo: <span id="plazo"></span> cuotas
					</p>
					<p>
						Cuota mensual con interés: <span id="cuota-mensual"></span>
					</p>
				</div>
			</form>
		</div>

		<!-- Botones fuera del contenedor -->
		<div class="btn-seccion contenedor-principal">
			<a href="ClientePanelSv" class="btn btn-secondary">Cancelar</a>
			<button type="button" class="btn btn-primary" onclick="solicitar()">Solicitar</button>
		</div>
	</div>

	<script>
	const montoInput = document.getElementById('monto');
	const tipoPrestamo = document.getElementById('tipo-prestamo');
	const plazoCuotas = document.getElementById('plazo-cuotas');
	const montoSolicitado = document.getElementById('monto-solicitado');
	const plazo = document.getElementById('plazo');
	const cuotaMensual = document.getElementById('cuota-mensual');

	function calcularCuotaMensual() {
	  const monto = parseFloat(montoInput.value.replace('$', ''));
	  const plazoMeses = parseInt(plazoCuotas.value);
	  let tasaInteres = 0.05; // Tasa de interés del 5% por defecto

	  // Actualizar la tasa de interés según el tipo de préstamo
	  switch (tipoPrestamo.value) {
	    case 'personal':
	      tasaInteres = 0.08; // 8% para préstamos personales
	      break;
	    case 'hipotecario':
	      tasaInteres = 0.06; // 6% para préstamos hipotecarios
	      break;
	    case 'automotriz':
	      tasaInteres = 0.07; // 7% para préstamos automotrices
	      break;
	  }

	  const cuotaMensualCalc = monto * (tasaInteres / 12) / (1 - Math.pow(1 + tasaInteres / 12, -plazoMeses));
	  return cuotaMensualCalc;
	}

	function actualizarResumen() {
	  const monto = parseFloat(montoInput.value.replace('$', ''));
	  const plazoMeses = parseInt(plazoCuotas.value);
	  const cuotaMensualCalc = calcularCuotaMensual();

	  montoSolicitado.textContent = monto.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
	  plazo.textContent = plazoMeses;
	  cuotaMensual.textContent = cuotaMensualCalc.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
	}

	function cancelar() {
	  console.log('Cancelando solicitud de préstamo...');
	}

	function solicitar() {
	  console.log('Enviando solicitud de préstamo...');
	}

	// Actualizar el resumen del préstamo cada vez que se cambia el monto, tipo de préstamo o plazo en cuotas
	montoInput.addEventListener('input', actualizarResumen);
	tipoPrestamo.addEventListener('change', actualizarResumen);
	plazoCuotas.addEventListener('change', actualizarResumen);
	</script>
</body>
</html>
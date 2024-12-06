<%@ page import="entidad.TipoPrestamo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

input, select {
	margin-bottom: 15px;
}

label+label {
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
<%@ include file="Componentes/Head.jsp"%>
</head>
<body>

	<jsp:include page="Componentes/Navbar.jsp"></jsp:include>
	<form action="ClienteSolicitudPrestamoSv" method="post">
		<div
			class="d-flex flex-column justify-content-center align-items-center vh-100">
			<div class="contenedor-principal p-4 bg-light border rounded">
				<div class="form-group">
					<label for="monto">Monto</label> <input type="text"
						class="form-control" id="monto" placeholder="$10000.00">
				</div>
				<div class="form-group">
					<label for="tipo-prestamo" class="form-label">Tipo de préstamo</label>
					<select name="tipo-prestamo" class="form-select" id="tipo-prestamo">
						<%
							ArrayList<TipoPrestamo> listaTipoPrestamos = (ArrayList<TipoPrestamo>) request.getAttribute("listaTipoPrestamos");
							for (TipoPrestamo tipoPrestamo : listaTipoPrestamos) {
						%>
						<option value="<%= tipoPrestamo.getIdTipoPrestamo() %>"><%= tipoPrestamo.getNombreTipoPrestamo() %></option>
						<%
							}
						%>
					</select>
				</div>
				<div class="form-group">
					<label for="plazo-cuotas">Plazo en cuotas</label> <select
						class="form-control" id="plazo-cuotas">
						<option value="12">12 meses</option>
						<option value="24">24 meses</option>
						<option value="36">36 meses</option>
					</select>
				</div>
				<div class="form-group">
					<label for="cuenta-acreditacion">Cuenta para acreditación</label> <select
						class="form-control" id="cuenta-acreditacion">
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
			</div>

			<!-- Botones fuera del contenedor -->
			<div class="btn-seccion contenedor-principal">
				<a href="ClientePanelSv" class="btn btn-secondary">Cancelar</a>
				<button type="button" class="btn btn-primary" onclick="solicitar()">Solicitar</button>
			</div>
		</div>
	</form>

	<script>
	const montoInput = document.getElementById('monto');
	const tipoPrestamo = document.getElementById('tipo-prestamo');
	const plazoCuotas = document.getElementById('plazo-cuotas');
	const montoSolicitado = document.getElementById('monto-solicitado');
	const plazo = document.getElementById('plazo');
	const cuotaMensual = document.getElementById('cuota-mensual');
	const tipoPrestamoResumen = document.createElement('p'); // Crear un nuevo elemento para el tipo de préstamo

	// Agregar el tipo de préstamo al resumen
	tipoPrestamoResumen.id = "tipo-prestamo-resumen";
	document.querySelector(".resumen-prestamo").appendChild(tipoPrestamoResumen);

	function calcularCuotaMensualFija(monto, plazoMeses, tasaInteres) {
		  const montoTotal = monto + (monto * tasaInteres); // Calcular monto total con interés
		  return montoTotal / plazoMeses; // Dividir entre el número de cuotas
		}

	function obtenerTasaInteres() {
	  const tipo = tipoPrestamo.options[tipoPrestamo.selectedIndex]?.text; // Obtener el texto del tipo seleccionado
	  switch (tipo) {
	    case 'Personal': return 0.25;
	    case 'Hipotecario': return 0.05;
	    case 'Automotriz': return 0.10;
	    case 'Vacaciones': return 0.15;
	    case 'Comercial': return 0.20;
	    case 'Agrícola': return 0.18;
	    default: return 0; // Tasa de interés por defecto si no hay tipo seleccionado
	  }
	}

	function actualizarResumen() {
		  const monto = parseFloat(montoInput.value.replace(/[^\d.]/g, '')) || 0; // Convertir el monto a número
		  const plazoMeses = parseInt(plazoCuotas.value) || 0;
		  const tasaInteres = obtenerTasaInteres();
		  const cuotaMensualCalc = calcularCuotaMensualFija(monto, plazoMeses, tasaInteres);

		  // Actualizar el resumen con los valores calculados
		  montoSolicitado.textContent = monto.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
		  plazo.textContent = plazoMeses;
		  cuotaMensual.textContent = cuotaMensualCalc.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

		  // Mostrar el tipo de préstamo seleccionado
		  const tipo = tipoPrestamo.options[tipoPrestamo.selectedIndex]?.text || 'No seleccionado';
		  tipoPrestamoResumen.textContent = `Tipo de préstamo: ${tipo}`;
		}

	// Actualizar el resumen al cambiar los valores
	montoInput.addEventListener('input', actualizarResumen);
	tipoPrestamo.addEventListener('change', actualizarResumen);
	plazoCuotas.addEventListener('change', actualizarResumen);

	</script>
</body>
</html>


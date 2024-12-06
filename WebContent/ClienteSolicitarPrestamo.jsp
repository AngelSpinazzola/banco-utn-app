<%@ page import="entidad.TipoPrestamo"%>
<%@ page import="entidad.Cuenta"%>
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
					<label for="monto">Monto</label> 
					<input type="text" class="form-control" name="monto" placeholder="$10000.00">
				</div>
				<div class="form-group">
					<label for="tipo-prestamo" class="form-label">Tipo de préstamo</label>
					<select class="form-select" name="idTipoPrestamo">
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
					<label for="plazo-cuotas" class="form-label">Plazo en cuotas</label> 
					<select class="form-select" id="plazo-cuotas" name="plazo">
						<option value="6">6 meses</option>
						<option value="12">12 meses</option>
						<option value="24">24 meses</option>
						<option value="36">36 meses</option>
					</select>
				</div>
				<div class="form-group">
					<label for="cuentas" class="form-label">Seleccioná la cuenta en la que deseas recibir el dinero</label>
					<select class="form-select" name="idCuenta">
						<%
							ArrayList<Cuenta> listaCuentas = (ArrayList<Cuenta>) request.getAttribute("listaCuentas");
							for (Cuenta cuenta : listaCuentas) {
						%>
						<option value="<%= cuenta.getIdCuenta() %>">N° Cuenta <%= cuenta.getNumeroCuenta() + " - " + cuenta.getTipoCuenta().getTipo() %></option>
						<%
							}
						%>
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
				<button type="submit" class="btn btn-primary">Solicitar</button>
			</div>
		</div>
	</form>

	<script>
       // Verificar si hay un mensaje de error
       <% 
       String errorMonto = (String) request.getAttribute("errorMonto");
       if (errorMonto != null && !errorMonto.isEmpty()) { 
       %>
           Swal.fire({
               icon: 'error',
               title: 'Error',
               text: '<%= errorMonto %>',
               confirmButtonText: 'Aceptar'
           });
       <% } %>
   </script>
</body>
</html>


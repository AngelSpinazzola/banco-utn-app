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
		
		<div class="d-flex flex-column justify-content-center align-items-center vh-100">
			<div class="contenedor-principal p-4 bg-light border rounded">
				  <div class="form-group">
                    <label for="monto">Monto</label> 
                    <input type="range" class="form-range" id="monto-slider" name="monto" min="10000" max="25000000" step="10000" value="10000">
                    <small style="font-size: 0.9em; color: gray; display: block;">
                        Podés solicitar desde $10.000 hasta $25.000.000
                    </small>
                    <p id="monto-display"></p>
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
							if (listaCuentas != null && !listaCuentas.isEmpty()) {
								for (Cuenta cuenta : listaCuentas) {
						%>
						<option value="<%= cuenta.getIdCuenta() %>">N° Cuenta <%= cuenta.getNumeroCuenta() + " - " + cuenta.getTipoCuenta().getTipo() %></option>
						<%      }
            				} else {
        				%>
				        <option value="">No hay cuentas disponibles</option>
				        <% } %>
					</select>
				</div>
				<div class="resumen-prestamo">
					<label>Resumen del préstamo</label>
					<p>	Monto solicitado: <span id="monto-solicitado"></span></p>
					<p>Plazo: <span id="plazo"></span></p>
					<p>Cuota mensual con interés: <span id="cuota-mensual"></span></p>
					<p>Tipo de préstamo: <span id="tipo-prestamo"></span></p>
				</div>
			</div>

			<div class="btn-seccion contenedor-principal">
				<a href="ClientePanelSv" class="btn btn-secondary">Cancelar</a>
				<button type="submit" class="btn btn-primary">Solicitar</button>
			</div>
		</div>
	</form>

	<script>
	    function calcularCuotaMensual(monto, plazo, tasaAnual) {
	    	monto = monto.replace(/[^\d.]/g, ''); 
	        
	        const montoNumerico = parseFloat(monto) || 0;
	        const plazoNumerico = parseInt(plazo) || 1;
	        
	        const tasaInteres = tasaAnual / 100; 
	        const montoTotal = montoNumerico * (1 + tasaInteres);
	        const cuota = montoTotal / plazoNumerico;
	
	        return cuota.toFixed(2);
	    }
	
	    function actualizarResumen() {
	        const montoInput = document.querySelector('input[name="monto"]');
	        const tipoPrestamo = document.querySelector('select[name="idTipoPrestamo"]');
	        const plazoSelect = document.querySelector('select[name="plazo"]');
	
	        const monto = montoInput.value || '$0';
	        const plazo = plazoSelect.value;
	        const montoNumerico = parseFloat(monto.replace(/[^\d.]/g, '')) || 0;

	        const selectedTipoPrestamo = tipoPrestamo.options[tipoPrestamo.selectedIndex];
	        const tipoPrestamoText = selectedTipoPrestamo.text;
	        const tipoPrestamoId = selectedTipoPrestamo.value;
	
	        const tnaPorTipoPrestamo = {
	            <% 
	            for (int i = 0; i < listaTipoPrestamos.size(); i++) { 
	                TipoPrestamo tp = listaTipoPrestamos.get(i);
	            %>
	                <%= tp.getIdTipoPrestamo() %>: <%= tp.getTna() %><%= i < listaTipoPrestamos.size() - 1 ? "," : "" %>
	            <% } %>
	        };
	
	        const tna = tnaPorTipoPrestamo[tipoPrestamoId];
	
	        document.getElementById('monto-solicitado').textContent = '$' + monto;
	        document.getElementById('plazo').textContent = plazo + ' cuotas';
	        document.getElementById('tipo-prestamo').textContent = tipoPrestamoText + ' - ' + tna + '% TNA';
	        
	        const cuotaMensual = calcularCuotaMensual(monto, plazo, tna);
	        document.getElementById('cuota-mensual').textContent = '$' + cuotaMensual;
	    }
	
	    document.querySelector('input[name="monto"]').addEventListener('input', actualizarResumen);
	    document.querySelector('select[name="idTipoPrestamo"]').addEventListener('change', actualizarResumen);
	    document.querySelector('select[name="plazo"]').addEventListener('change', actualizarResumen);
	
	    document.addEventListener('DOMContentLoaded', actualizarResumen);
	    
	    <% 
	    String errorPrestamo = (String) request.getAttribute("errorPrestamo");
	    if (errorPrestamo != null && !errorPrestamo.isEmpty()) { 
		%>
		    Swal.fire({
		        icon: 'error', 
		        title: 'Error',
		        text: '<%= errorPrestamo %>',
		        confirmButtonText: 'Aceptar'
		    }).then((result) => {
		        if (result.isConfirmed) {
		            window.location.href = "ClientePanelSv"; 
		        }
		    });
		<% } %>
		
	    <% 
	   	String successPrestamo = (String) request.getAttribute("successPrestamo");
	   	if (successPrestamo != null && !successPrestamo.isEmpty()) { 
	    %>
	        Swal.fire({
	            icon: 'success', 
	            title: 'Éxito',
	            text: '<%= successPrestamo %>',
	            confirmButtonText: 'Aceptar'
	        }).then((result) => {
	            if (result.isConfirmed) {
	                window.location.href = "ClientePanelSv"; 
	            }
	        });
	    <% } %>
	</script>
</body>
</html>


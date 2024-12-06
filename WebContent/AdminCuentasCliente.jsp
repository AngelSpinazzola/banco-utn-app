<%@ page import="entidad.Cliente"%>
<%@ page import="entidad.Cuenta"%>
<%@ page import="entidad.Prestamo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<%@ include file="Componentes/Head.jsp"%>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Banco UTN</title>
<style>
body {
	background-color: #f9f9f9;
}

.main-container {
	max-width: 1300px;
	margin: 0 auto;
	padding: 20px;
	margin-top: 40px;
}

h3, h5 {
	color: #333;
}

.cliente-info {
	background-color: white;
	padding: 10px 15px;
	border-radius: 8px;
	max-width: 98%;
	margin: 0 auto;
}

.cliente-info .cliente-info-item {
	margin: 0;
	display: flex;
	align-items: center;
	font-size: 1rem;
}

.cliente-info .d-flex {
	margin-bottom: 5px; 
}
.cliente-info .cliente-info-item.cliente-text {
	font-size: 1.1rem; 
	font-weight: bold; 
	color: #2c3e50; 
}

.cliente-info .d-flex:last-child {
	margin-bottom: 0; 
}

.cliente-info .justify-content-end {
	text-align: right; 
}

.cliente-info .cliente-info-estado i {
	margin-left: 10px;
}

.cuenta-card {
	border: 1px solid #ddd;
	border-radius: 8px;
	transition: transform 0.2s;
	background-color: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.cuenta-card:hover {
	transform: scale(1.03);
}

.card-header {
	font-weight: bold;
}

.card-footer {
	background-color: white;
	border-top: none;
	box-shadow: none;
	padding: 0.5rem;
}

.card-footer button {
	min-width: 90px;
}

.card-body p {
	margin: 0;
	line-height: 1.5;
}

.card-footer .btn-eliminar {
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #dc3545 !important;
	color: #fff !important;
	border: none !important;
	border-radius: 5px !important;
	width: 35px !important;
	height: 35px !important;
	min-width: 35px !important;
	max-width: 35px !important;
	padding: 0 !important;
	box-sizing: border-box;
}

.card-footer .btn-eliminar i {
	font-size: 16px !important;
	line-height: 1 !important;
}

.card-footer .btn-eliminar:hover {
	background-color: #c82333 !important;
}

.card.cuenta-card .card-footer .btn-eliminar {
	width: 20px;
	height: 30px;
}

.card.cuenta-card .card-footer .btn-eliminar i {
	font-size: 14px;
}

.seccion-cartas .col-12.col-md-4 {
	width: 30%;
}

.seccion-cartas {
	margin-right: -15px;
}

.crear-cuenta, .cliente-info {
	background-color: white;
	border-radius: 8px;
	padding: 15px;
}

.crear-cuenta select {
	margin-bottom: 1rem;
}

.container-cards {
	display: flex;
	justify-content: space-between;
	gap: 20px;
}

.crear-cuenta {
	background-color: white;
	border-radius: 8px;
	padding: 15px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	margin: 20px auto;
	max-width: 98%;
}

.card-footer .btn-outline-primary, .card-footer .btn-outline-success {
	color: black !important;
	border: 1px solid black !important;
}

.card-footer .btn-outline-primary:hover, .card-footer .btn-outline-success:hover
	{
	background-color: black !important;
	color: white !important;
}
</style>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

</head>

<body>

	<%@ include file="Componentes/NavbarAdmin.jsp"%>
	<form action="AdminCuentasClienteSv" method="post" class="row g-3">
		<%
			Cliente cliente = (Cliente) request.getAttribute("cliente");
			ArrayList<Cuenta> cuentas = (ArrayList<Cuenta>) request.getAttribute("cuentas");
			int totalPrestamos = (int) request.getAttribute("totalPrestamos");
		%>
		<input id="idCliente" name="idCliente"
			value="<%=cliente.getIdCliente()%>" type="hidden">
		<div class="main-container">
			<h3 class="mb-4">Gestioná las cuentas del cliente</h3>
			<div class="mb-4 cliente-info">
				<div class="d-flex justify-content-start align-items-center">
					<p class="cliente-info-item cliente-text">
						<i></i> Cliente:
						<%=cliente.getNombre() + " " + cliente.getApellido()%>
					</p>
				</div>
				<div class="d-flex justify-content-start align-items-center">
					<p class="cliente-info-item">
						<i></i> Préstamos:
						<%
							if (totalPrestamos > 0) {
						%>
						<%=totalPrestamos%>
						<%
							} else {
						%>
						No se registraron préstamos activos para el cliente.
						<%
							}
						%>
					</p>
				</div>
				<div class="d-flex justify-content-start align-items-center">
					<p class="cliente-info-item cliente-info-estado">
						Estado:
						<%=cliente.isEstado() ? "Activo" : "Inactivo"%>
						<i class="<%=cliente.isEstado() ? "fas fa-check-circle" : "fas fa-times-circle"%>" style="color: <%=cliente.isEstado() ? "#28a745" : "#dc3545"%>;"></i>
					</p>
				</div>
			</div>


			<div class="container-cards mb-4">
				<%
					if (cuentas != null && !cuentas.isEmpty()) {
						for (Cuenta cuenta : cuentas) {
				%>
				<div class="card cuenta-card w-100">
					<div
						class="card-header <%=cuenta.getTipoCuenta().getTipo().equalsIgnoreCase("Caja de Ahorro")
							? "text-primary"
							: "text-success"%>">
						<%=cuenta.getTipoCuenta().getTipo().equalsIgnoreCase("Caja de Ahorro")
							? "Caja de Ahorro"
							: "Cuenta corriente"%>
					</div>
					<div class="card-body">
						<p>
							<strong>N° Cuenta:</strong>
							<%=cuenta.getNumeroCuenta()%>
						</p>
						<p>
							<strong>CBU:</strong>
							<%=cuenta.getCbu()%>
						</p>
						<p>
							<strong>Saldo:</strong> $<%= cuenta.getSaldo() %>
						</p>
					</div>
					<div class="card-footer d-flex justify-content-between">
						<form action="AdminCuentasClienteSv" method="post">
							<input type="hidden" name="action" value="eliminarCuenta">
							<input type="hidden" name="idCuenta" value="<%=cuenta.getIdCuenta() %>"> 
							<input type="hidden" name="idCliente" value="<%=cliente.getIdCliente()%>">
							<button type="submit" class="btn btn-eliminar">
								<i class="fas fa-trash"></i>
							</button>
						</form>
						<button type="button" class="btn btn-outline-primary btn-modificar-saldo"><i>Modificar saldo</i></button>
					</div>
				</div>
				<%
					}
					} else {
				%>
				<p>No se encontraron cuentas para este cliente.</p>
				<%
					}
				%>
			</div>


			<div class="crear-cuenta p-3 border rounded">
				<h5>Crear cuenta</h5>
				<div class="mb-3">
					<label for="tipoCuenta" class="form-label">Seleccioná un
						tipo de cuenta</label> <select id="tipoCuenta" class="form-select">
						<option value="cajaAhorro" selected>Caja de ahorro</option>
						<option value="cuentaCorriente">Cuenta corriente</option>
					</select>
				</div>
				<button class="btn btn-success w-100 btn-general">Crear
					cuenta</button>
			</div>
		</div>
	</form>
	
	<!-- Modal para Modificar Saldo -->
	<div class="modal fade" id="modalModificarSaldo" tabindex="-1"
		aria-labelledby="tituloModalModificarSaldo" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered"
			style="margin-top: -20px;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="tituloModalModificarSaldo">Modificar
						saldo de cuenta</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Cerrar"></button>
				</div>
				<div class="modal-body">
					<form id="formModificarSaldo" action="AdminCuentasClienteSv"
						method="post">
						<input type="hidden" id="idCuentaModificar" name="idCuenta">
						<input type="hidden" id="idClienteModificar" name="idCliente"
							value="<%=cliente.getIdCliente()%>">

						<div class="mb-3">
							<label for="saldoActual" class="form-label">Saldo actual</label>
							<input type="text" class="form-control" id="saldoActual" readonly>
						</div>
						<div class="mb-3">
							<label for="nuevoSaldo" class="form-label">Nuevo saldo</label> <input
								type="number" class="form-control" id="nuevoSaldo"
								name="nuevoSaldo" required>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Cancelar</button>
					<button type="button"
						class="btn btn-primary bg-success border-success"
						id="btnGuardarModificacion">Guardar Cambios</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal para Eliminar Cuenta -->
	<div class="modal fade" id="modalEliminarCuenta" tabindex="-1"
		aria-labelledby="tituloModalEliminarCuenta" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered"
			style="margin-top: -20px;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="tituloModalEliminarCuenta">Eliminar
						Cuenta</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Cerrar"></button>
				</div>
				<div class="modal-body">
					<p>¿Estás seguro que deseas eliminar esta cuenta?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Cancelar</button>
					<button type="button" class="btn btn-danger"
						id="btnConfirmarEliminar">Eliminar Cuenta</button>
				</div>
			</div>
		</div>
	</div>





</body>
<!-- Scripts necesarios -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
        document.addEventListener('DOMContentLoaded', function () {
        	// Obtengo el parámetro 'resultado' de la URL
            const urlParams = new URLSearchParams(window.location.search);
            const resultado = urlParams.get('resultado');

            // Muestro el mensaje según el resultado
            if (resultado !== null) {
                switch (parseInt(resultado)) {
                    case 0:
                        Swal.fire({
                            icon: 'success',
                            title: 'Cuenta eliminada',
                            text: 'La cuenta se eliminó correctamente.',
                            confirmButtonText: 'Aceptar'
                        });
                        break;
                    case 1:
                        Swal.fire({
                            icon: 'warning',
                            title: 'Cuenta con préstamos activos',
                            text: 'No se puede eliminar la cuenta porque tiene préstamos activos.',
                            confirmButtonText: 'Aceptar'
                        });
                        break;
                    case 2:
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Ocurrió un error al intentar eliminar la cuenta.',
                            confirmButtonText: 'Aceptar'
                        });
                        break;
                    default:
                        console.warn('Resultado no esperado:', resultado);
                }
            }
        	
        	const modalModificarSaldo = new bootstrap.Modal(document.getElementById('modalModificarSaldo'));
            const botonesModificar = document.querySelectorAll('.btn-outline-primary, .btn-outline-success');
            const botonesEliminar = document.querySelectorAll('.btn-eliminar');
            const nuevoSaldoInput = document.getElementById('nuevoSaldo');
            const btnGuardarModificacion = document.getElementById('btnGuardarModificacion');
            const formModificarSaldo = document.getElementById('formModificarSaldo');

            botonesModificar.forEach(boton => {
                boton.addEventListener('click', function (event) {
                    event.preventDefault();
                    const cardBody = this.closest('.cuenta-card').querySelector('.card-body');
                    const numeroCuenta = cardBody.querySelector('p:nth-child(1)').textContent.split(':')[1].trim();
                    const saldoActual = parseFloat(cardBody.querySelector('p:nth-child(3)').textContent.split('$')[1].trim());

                    document.getElementById('saldoActual').value = saldoActual.toFixed(2);
                    document.getElementById('nuevoSaldo').value = saldoActual.toFixed(2);
                    document.getElementById('idCuentaModificar').value = numeroCuenta;
                    document.getElementById('idClienteModificar').value = <%=cliente.getIdCliente()%>;

                    modalModificarSaldo.show();
                });
            });

            // Validación del campo de saldo
            nuevoSaldoInput.addEventListener('input', function () {
                this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');
            });

            nuevoSaldoInput.addEventListener('keypress', function (event) {
                if (event.key === '+' || event.key === '-') {
                    event.preventDefault();
                }
            });

            btnGuardarModificacion.addEventListener('click', function () {
                if (formModificarSaldo.checkValidity()) {
                    // Campo oculto para el action
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'modificarSaldo';
                    formModificarSaldo.appendChild(actionInput);

                    Swal.fire({
                        icon: 'success',
                        title: '¡Cambios guardados!',
                        text: 'Se modificó el saldo de la cuenta correctamente.',
                        confirmButtonText: 'Aceptar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            formModificarSaldo.submit();
                        }
                    });
                } else {
                    formModificarSaldo.reportValidity();
                }
            });

            botonesEliminar.forEach(boton => {
                boton.addEventListener('click', function (event) {
                    event.preventDefault();
                    const cardBody = this.closest('.cuenta-card').querySelector('.card-body');
                    const idCuenta = this.closest('.cuenta-card').querySelector('input[name="idCuenta"]').value;
					
                    const urlParams = new URLSearchParams(window.location.search);
                    const resultado = urlParams.get('resultado');
                    
                    Swal.fire({
                        title: '¿Estás seguro que deseas eliminar esta cuenta?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Sí, eliminar cuenta',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const form = document.createElement('form');
                            form.method = 'post';
                            form.action = 'AdminCuentasClienteSv';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'eliminarCuenta';
                            form.appendChild(actionInput);

                            const idCuentaInput = document.createElement('input');
                            idCuentaInput.type = 'hidden';
                            idCuentaInput.name = 'idCuenta';
                            idCuentaInput.value = idCuenta;
                            form.appendChild(idCuentaInput);

                            const idClienteInput = document.createElement('input');
                            idClienteInput.type = 'hidden';
                            idClienteInput.name = 'idCliente';
                            idClienteInput.value = '<%=cliente.getIdCliente()%>';
                            form.appendChild(idClienteInput);

                            document.body.appendChild(form);
                            form.submit();
                        }
                    });
                });
            });
        });
    </script>

</html>
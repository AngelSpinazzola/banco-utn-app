<%@page import="entidad.Usuario"%>
<%@page import="java.time.Year"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
	<%@ include file="Componentes/Head.jsp"%>
</head>

<body>
	<%@ include file="Componentes/NavbarAdmin.jsp"%>
	<div class="container mt-4">
		<div class="row">
			<div class="col-12">
			</div>
		</div>

		<div class="row mb-4">
			<div class="col-md-3">
	            <div class="card card-superior">
	                <div class="card-body">
	                    <h6 class="card-subtitle mb-2 text-muted">Total dinero otorgado</h6>
	                    <h4 class="card-title">
	                        $<%= request.getAttribute("totalOtorgadoEnPrestamos") != null 
	                            ? ((java.math.BigDecimal) request.getAttribute("totalOtorgadoEnPrestamos")).toPlainString() 
	                            : "0.00" %>
	                    </h4>
	                </div>
	            </div>
        	</div>

			<div class="col-md-3">
				<div class="card card-superior">
					  <div class="card-body">
			            <h6 class="card-subtitle mb-2 text-muted">Total clientes</h6>
			            <h4 class="card-title">${totalClientes}</h4>
			        </div>
				</div>
			</div>

			<div class="col-md-3">
				<div class="card card-superior">
					<div class="card-body">
						<h6 class="card-subtitle mb-2 text-muted">Cuentas activas</h6>
						<h4 class="card-title">${totalCuentas}</h4>
					</div>
				</div>
			</div>

			<div class="col-md-3">
				<div class="card card-superior">
					<div class="card-body">
						<h6 class="card-subtitle mb-2 text-muted">Préstamos activos</h6>
						<h4 class="card-title">${totalPrestamosActivos}</h4>
					</div>
				</div>
			</div>
		</div>
		<!-- Nuevas secciones para gráficos -->
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header">
						<h5 class="card-title">Análisis Financiero</h5>
						<form id="graficosForm" method="get" action="DashboardServlet">
							<div class="form-group">
								<label for="anioSelect">Seleccionar Año:</label>
								<select name="anio" id="anioSelect" class="form-control">
									<% 
									int anioActual = Year.now().getValue();
									for (int i = anioActual; i >= anioActual - 5; i--) { 
									%>
										<option value="<%= i %>" <%= i == anioActual ? "selected" : "" %>><%= i %></option>
									<% } %>
								</select>
							</div>
						</form>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<canvas id="prestamosTransferenciasChart" height="300"></canvas>
							</div>
							<div class="col-md-6">
								<canvas id="clientesPorProvinciaChart" height="300"></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
	<script>
		$(document).ready(function() {
			// Gráfico de Préstamos y Transferencias
			const prestamosTransferenciasChart = new Chart(document.getElementById('prestamosTransferenciasChart'), {
				type: 'bar',
				data: {
					labels: ['Préstamos Solicitados', 'Transferencias Realizadas'],
					datasets: [{
						label: 'Cantidad',
						data: [
							<%= request.getAttribute("prestamosSolicitadosCantidad") != null ? request.getAttribute("prestamosSolicitadosCantidad") : 0 %>,
							<%= request.getAttribute("transferenciasRealizadasCantidad") != null ? request.getAttribute("transferenciasRealizadasCantidad") : 0 %>
						],
						backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(54, 162, 235, 0.6)']
					}, {
						label: 'Monto Total',
						data: [
							<%= request.getAttribute("prestamosSolicitadosMonto") != null ? request.getAttribute("prestamosSolicitadosMonto") : 0 %>,
							<%= request.getAttribute("transferenciasRealizadasMonto") != null ? request.getAttribute("transferenciasRealizadasMonto") : 0 %>
						],
						backgroundColor: ['rgba(255, 99, 132, 0.6)', 'rgba(255, 206, 86, 0.6)']
					}]
				},
				options: {
					responsive: true,
					plugins: {
						title: {
							display: true,
							text: 'Préstamos vs Transferencias ' + ${anioActual}
						}
					},
					scales: {
						y: {
							beginAtZero: true
						}
					}
				}
			});

			// Gráfico de Clientes por Provincia
			const clientesPorProvinciaChart = new Chart(document.getElementById('clientesPorProvinciaChart'), {
				type: 'pie',
				data: {
					labels: [
						<% 
						String[] provincias = (String[]) request.getAttribute("provincias");
						if (provincias != null) {
							for (String provincia : provincias) {
								out.print("'" + provincia + "',");
							}
						}
						%>
					],
					datasets: [{
						data: [
							<% 
							Integer[] clientesPorProvincia = (Integer[]) request.getAttribute("clientesPorProvincia");
							if (clientesPorProvincia != null) {
								for (Integer cantidad : clientesPorProvincia) {
									out.print(cantidad + ",");
								}
							}
							%>
						],
						backgroundColor: [
							'rgba(255, 99, 132, 0.6)',
							'rgba(54, 162, 235, 0.6)',
							'rgba(255, 206, 86, 0.6)',
							'rgba(75, 192, 192, 0.6)',
							'rgba(153, 102, 255, 0.6)'
						]
					}]
				},
				options: {
					responsive: true,
					plugins: {
						title: {
							display: true,
							text: 'Clientes por Provincia'
						}
					}
				}
			});

			// Evento para cambiar gráficos al seleccionar año
			$('#anioSelect').change(function() {
				$('#graficosForm').submit();
			});
		});
	</script>
</body>
</html>
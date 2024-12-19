<%@page import="entidad.Usuario"%>
<%@ page import="java.math.BigDecimal" %>
<%@page import="java.time.Year"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
	<%@ include file="Componentes/Head.jsp"%>
<style>
	
</style>
</head>
	

<body>
	<%@ include file="Componentes/NavbarAdmin.jsp"%>
	<div class="container mt-4">
		<div class="alert alert-info" role="alert">
	        Bienvenido admin. Aquí está el resumen de hoy.
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

		<div class="container mt-4" style="margin-bottom: 100px">
			<div class="row">
				<div class="col-12">
					<div class="card">
						<div class="card-header">
						   <h5 class="card-title">Análisis Financiero</h5>
						   <form id="graficosForm" method="get" action="DashboardServlet">
                            <div class="form-group">
                                <label for="anioSelect">Seleccionar Año:</label>
                                <select name="anio" id="anioSelect" class="form-control">
							    <% 
							    List<Integer> aniosConDatos = (List<Integer>) request.getAttribute("aniosConDatos");
							    int anioSeleccionado = (Integer) request.getAttribute("anioActual");
							    
							    for (Integer anio : aniosConDatos) { 
							    %>
							        <option value="<%= anio %>" <%= anio == anioSeleccionado ? "selected" : "" %>><%= anio %></option>
							    <% } %>
							</select>
                            </div>
                        </form>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-md-12">
									<canvas id="financialTrendsChart" class="chart-container"></canvas>
								</div>
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
	    $("#anioSelect").change(function() {
	        $("#graficosForm").submit();
	    });

	    const anioActual = <%= request.getAttribute("anioActual") %>;
	    
	    const prestamosMensuales = [
	        <% 
	            BigDecimal[] prestamos = (BigDecimal[]) request.getAttribute("prestamosArray");
	            for (int i = 0; i < prestamos.length; i++) {
	                out.print(prestamos[i] + (i < prestamos.length - 1 ? "," : ""));
	            }
	        %>
	    ];
	    
	    const transferenciasMensuales = [
	        <% 
	            BigDecimal[] transferencias = (BigDecimal[]) request.getAttribute("transferenciasArray");
	            for (int i = 0; i < transferencias.length; i++) {
	                out.print(transferencias[i] + (i < transferencias.length - 1 ? "," : ""));
	            }
	        %>
	    ];

	    // Gráfico de Tendencias Financieras
	    const financialTrendsChart = new Chart(document.getElementById('financialTrendsChart'), {
	        type: 'line',
	        data: {
	            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
	            datasets: [
	                {
	                    label: 'Préstamos solicitados monto ($)',
	                    data: prestamosMensuales,
	                    borderColor: 'rgb(255, 99, 132)',
	                    tension: 0.1
	                },
	                {
	                    label: 'Transferencias monto ($)',
	                    data: transferenciasMensuales,
	                    borderColor: 'rgb(255, 206, 86)',
	                    tension: 0.1
	                }
	            ]
	        },
	        options: {
	            responsive: true,
	            plugins: {
	                title: {
	                    display: true,
	                    text: `Tendencias Financieras Mensuales - Año ${anioActual}`
	                }
	            }
	        }
	    });
	});
</script>
</body>
</html>
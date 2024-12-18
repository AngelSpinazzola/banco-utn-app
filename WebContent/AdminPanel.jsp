<%@page import="entidad.Usuario"%>
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

	</div>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
	
</body>
</html>
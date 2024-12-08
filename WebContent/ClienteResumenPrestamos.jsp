<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mis préstamos</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	background-color: #f5f5f5;
}

.container {
	max-width: 1200px;
	margin: 2rem auto;
	padding: 0 1rem;
}

.card {
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	padding: 2rem;
}

h1 {
	font-size: 1.5rem;
	margin-bottom: 2rem;
	color: #333;
}

.tabs {
	display: flex;
	gap: 1rem;
	margin-bottom: 2rem;
}

.tab-button {
	padding: 0.75rem 1.5rem;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 1rem;
	background-color: #e0e0e0;
}

.tab-button.active {
	background-color: #26a69a;
	color: white;
}

.loans-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 1rem;
}

.loans-table th, .loans-table td {
	padding: 1rem;
	text-align: left;
	border-bottom: 1px solid #eee;
}

.loans-table th {
	background-color: #f8f9fa;
	font-weight: bold;
	color: #333;
}

.status {
	padding: 0.25rem 0.75rem;
	border-radius: 12px;
	font-size: 0.875rem;
	font-weight: 500;
}

.status-approved {
	background-color: #e8f5e9;
	color: #2e7d32;
}

.status-pending {
	background-color: #fff3e0;
	color: #f57c00;
}

.pagination {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 1rem;
}

.pagination-info {
	color: #666;
}

.pagination-controls {
	display: flex;
	gap: 0.5rem;
}

.pagination-button {
	padding: 0.5rem 1rem;
	border: 1px solid #ddd;
	background-color: white;
	cursor: pointer;
	border-radius: 4px;
}

.pagination-button.active {
	background-color: #1976d2;
	color: white;
	border-color: #1976d2;
}

.pagination-button:hover:not (.active ) {
	background-color: #f5f5f5;
}

.pagination-button:disabled {
	background-color: #f5f5f5;
	cursor: not-allowed;
	color: #999;
}
</style>
</head>
<body>
	<%@ include file="Componentes/Head.jsp"%>
	<jsp:include page="Componentes/Navbar.jsp"></jsp:include>
	
	
	<div class="container">
	<h2>Resumen de tus préstamos</h2>
		<div class="card">
			<table class="loans-table">
				<thead>
					<tr>
						<th>Fecha</th>
						<th>Cuenta</th>
						<th>Importe</th>
						<th>Importe total</th>
						<th>Cuota mensual</th>
						<th>Plazo</th>
						<th>Progreso</th>
						<th>Estado</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>10-8-2024</td>
						<td>CA - 100005</td>
						<td>$100.000,00</td>
						<td>$120.000,00</td>
						<td>$12.000,00</td>
						<td>12</td>
						<td>3/12</td>
						<td><span class="status status-approved">Aprobado</span></td>
					</tr>
					<tr>
						<td>9-5-2024</td>
						<td>CA - 100005</td>
						<td>$200.000,00</td>
						<td>$240.000,00</td>
						<td>$24.000,00</td>
						<td>24</td>
						<td>-</td>
						<td><span class="status status-pending">Pendiente</span></td>
					</tr>
					<tr>
						<td>15-9-2024</td>
						<td>CA - 100005</td>
						<td>$50.000,00</td>
						<td>$60.000,00</td>
						<td>$10.000,00</td>
						<td>6</td>
						<td>2/6</td>
						<td><span class="status status-approved">Aprobado</span></td>
					</tr>
				</tbody>
			</table>

			<div class="pagination">
				<div class="pagination-info">Mostrando página 1 de 3</div>
				<div class="pagination-controls">
					<button class="pagination-button" disabled>Anterior</button>
					<button class="pagination-button active">1</button>
					<button class="pagination-button">2</button>
					<button class="pagination-button">3</button>
					<button class="pagination-button">Siguiente</button>
				</div>
			</div>
		</div>
	</div>

	<script>
        // Manejo de la paginación
        const paginationButtons = document.querySelectorAll('.pagination-button');
        
        paginationButtons.forEach(button => {
            if (!button.disabled) {
                button.addEventListener('click', function() {
                    // Remover clase active de todos los botones
                    paginationButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // Agregar clase active al botón clickeado si es un número
                    if (!isNaN(this.textContent)) {
                        this.classList.add('active');
                    }
                });
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Banco UTN - Movimientos</title>
<%@ include file="Componentes/Head.jsp"%>
	<style>
		body {
			background-color: #f5f5f5;
			margin: 0;
			padding: 0;
		}
		
		.container {
			display: flex;
			flex-direction: column;
			align-items: center;
		}
		
		.section-title {
			font-size: 24px;
			color: #333;
			margin-top: 20px;
			text-align: center;
		}
		
		.section-content {
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			width: 100%;
			margin-top: 10px;
		}
		
		.account-cards {
			display: flex;
			gap: 20px;
			justify-content: center;
			margin-top: 20px;
		}
		
		.form-select {
			width: 300px;
			padding: 8px;
			/* A�adido para que el select sea m�s alto y mejor alineado */
			font-size: 14px;
			margin-top: 5px;
			/* Un peque�o margen para separar el texto y el select */
		}
		
		.account-card {
			border: 1px solid #d1d1d1;
			border-radius: 20px;
			padding: 20px;
			width: 382px;
			text-align: left;
			background-color: #fff;
		}
		
		.account-card h3 {
			margin: 0;
			font-size: 18px;
			color: #333;
		}
		
		.account-card p {
			margin: 5px 0;
			font-size: 14px;
		}
		
		.account-card button {
			background-color: #0066cc;
			color: white;
			border: none;
			padding: 5px 10px;
			border-radius: 5px;
			cursor: pointer;
		}
		
		.transactions-table {
			width: 80%;
			margin: 20px auto;
			background-color: #fff;
			border-collapse: collapse;
			border-radius: 5px;
			overflow: hidden;
		}
		
		.transactions-table th, .transactions-table td {
			padding: 10px;
			text-align: center;
			border: 1px solid #ddd;
		}
		
		.transactions-table th {
			background-color: #e0e0e0;
			font-size: 16px;
		}
		
		.transactions-table .negative {
			color: red;
		}
		
		.transactions-table .positive {
			color: green;
		}
		
		.pagination {
			display: flex;
			justify-content: center;
			gap: 10px;
			margin-top: 20px;
		}
		
		.pagination a {
			padding: 8px 16px;
			border: 1px solid #ddd;
			border-radius: 5px;
			text-decoration: none;
			color: #333;
		}
		
		.pagination a:hover {
			background-color: #0066cc;
			color: white;
		}
		
		.pagination a.active {
			background-color: #0066cc;
			color: white;
		}
		.container{
			margin-top: 30px;
		}
	</style>
</head>
<body>
	<%@ include file="Componentes/Navbar.jsp"%>

	<div class="container">
		<div class="section-content">
			<h4>Mi cuenta</h4>
			<select class="form-select">
				<option>CA - 100001</option>
				<option>CC - 880001</option>
			</select>
		</div>

		<div class="section-title">�ltimos movimientos</div>
		<table class="transactions-table">
			<thead>
				<tr>
					<th>Fecha</th>
					<th>Concepto</th>
					<th>Cuenta</th>
					<th>Monto</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>15-12-24</td>
					<td>Transferencia a Ignacio D.</td>
					<td>CA - 100005</td>
					<td class="negative">- $7,000.00</td>
				</tr>
				<tr>
					<td>23-9-24</td>
					<td>Pago pr�stamo</td>
					<td>CC - 880001</td>
					<td class="negative">- $25,000.00</td>
				</tr>
				<tr>
					<td>10-8-24</td>
					<td>Transferencia de Mario G.</td>
					<td>CA - 100020</td>
					<td class="positive">+ $10,000.00</td>
				</tr>
				<tr>
					<td>2-8-24</td>
					<td>Transferencia de Pedro C.</td>
					<td>CC - 885503</td>
					<td class="positive">+ $27,000.00</td>
				</tr>
				<tr>
					<td>2-8-24</td>
					<td>Transferencia a Juan B.</td>
					<td>CA - 100005</td>
					<td class="negative">- $5,000.00</td>
				</tr>
			</tbody>
		</table>

		<div class="pagination">
			<a href="#" class="active">1</a> <a href="#">2</a> <a href="#">3</a>
			<a href="#">...</a> <a href="#">Siguiente</a>
		</div>
	</div>
</body>
</html>
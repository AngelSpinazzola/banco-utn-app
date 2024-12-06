<%@ page import="entidad.Cliente"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Información personal</title>
    <%@ include file="Componentes/Head.jsp"%>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .form-container {
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 30px 30px;
            color: #333;
            transition: all 0.3s ease;
        }

        .form-title {
            text-align: left;
            margin-left: 520px;
            margin-top: 40px;
            margin-bottom: 30px;
            font-size: 1.5rem;
            color: #333333;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            position: relative; 
        }
        
        .form-group input[readonly], .form-group select[disabled] {
		    padding: 10px;
		    font-size: 1rem;
		    border: 1px solid #dcdcdc; 
		    border-radius: 6px; 
		    background-color: #f8f9fa;
		    color: #495057;
		    cursor: not-allowed;
		    outline: none;
		    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
		    transition: background-color 0.3s, border-color 0.3s; 
		}
		
		.form-group input[readonly]:hover, .form-group select[disabled]:hover {
		    background-color: #e9ecef;
		    border-color: #adb5bd;
		    box-shadow: 0px 4px 10px rgba(0, 123, 255, 0.4); 
		}

        .form-group label {
            font-size: 0.9rem;
            color: black;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }

        .form-group input[readonly], .form-group select[disabled] {
            padding: 10px;
            font-size: 1rem;
            border: none;
            background-color: #f1f3f5;
            color: black;
            cursor: not-allowed;
            outline: none;
        }

        .form-group input[readonly] {
            border-bottom: 1px solid #dcdcdc;
        }

        .volver-btn {
		    width: 20%; 
		    font-size: 1rem;
		    padding: 8px;
		    margin-right: 550px; 
		}
	
        .text-end {
		    display: flex; 
		    justify-content: flex-end;
		    font-size: 0.8rem;
		}
		.form-row {
    		display: flex; 
    		gap: 10px; 
		}
		.form-group {
    		flex: 1; 
		}
		.input-small {
		    width: 170px; 
		}

    </style>
</head>
<body>
    <jsp:include page="Componentes/Navbar.jsp"></jsp:include>
    
    <h2 class="form-title">Información personal</h2>
    <div class="form-container">
        <form action="ClienteInfoPersonalSv" method="post">
            <%
                Cliente cliente = (Cliente) request.getAttribute("cliente");
            %>
                <div class="form-grid">
                	<div class="form-group">
                        <label for="nombre-usuario">Nombre de usuario</label> 
                        <input type="text" id="nombre-usuario" value="<%= cliente.getNombreUsuario() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="nombre">Nombre</label> 
                        <input type="text" id="nombre" value="<%= cliente.getNombre() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="apellido">Apellido</label> 
                        <input type="text" id="apellido" value="<%= cliente.getApellido() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="dni">DNI</label> 
                        <input type="text" id="dni" value="<%= cliente.getDni() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="cuil">Cuil</label> 
                        <input type="text" id="cuil" value="<%= cliente.getCuil() %>" readonly>
                    </div>
                    <div class="form-row">
					    <div class="form-group">
					        <label for="sexo">Sexo</label> 
					        <input type="text" id="sexo" class="input-small" value="<%= cliente.getSexo() %>" readonly>
					    </div>
					    <div class="form-group">
					        <label for="fecha-nacimiento">Fecha de Nacimiento</label> 
					        <input type="date" id="fecha-nacimiento" class="input-small" value="<%= cliente.getFechaNacimiento() %>" readonly>
					    </div>
					</div>
					<div class="form-row">
						<div class="form-group">
						    <label for="email">Email</label> 
						    <input type="email" id="email" value="<%= cliente.getEmail() %>" readonly>
						</div>
					</div>
				    <div class="form-group">
				        <label for="nacionalidad">Nacionalidad</label> 
				        <input type="text" id="nacionalidad" value="<%= cliente.getNacionalidad().getNacionalidad() %>" readonly>
				    </div>

                    <div class="form-group">
                        <label for="provincia">Provincia</label> 
                        <input type="text" id="provincia" value="<%= cliente.getDireccion().getProvincia().getNombre() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="localidad">Localidad</label> 
                        <input type="text" id="localidad" value="<%= cliente.getDireccion().getLocalidad().getNombre() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="calle">Calle</label> 
                        <input type="text" id="calle" value="<%= cliente.getDireccion().getCalle() %>" readonly>
                    </div>
                    <div class="form-row">
	                    <div class="form-group">
	                        <label for="codigo-postal">Código Postal</label> 
	                        <input type="text" id="codigo-postal" class="input-small" value="<%= cliente.getDireccion().getCodigoPostal() %>" readonly>
	                    </div>
	                    <div class="form-group">
	                        <label for="numero-calle">Número de Calle</label> 
	                        <input type="text" id="numero-calle" class="input-small" value="<%= cliente.getDireccion().getNumero() %>" readonly>
	                    </div>
                    </div>
                </div>
        </form>
    </div>
    <div class="text-end">
        <a href="ClientePanelSv" class="btn btn-secondary volver-btn">Volver</a>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="Componentes/Head.jsp"%>
<head>
</head>
<body>
    <%@ include file="Componentes/Navbar.jsp"%>
    <div class="form-wrapper" style="margin-top: 70px;">
        <div class="content-wrapper">
            <div class="text-center mt-4">
                <h2 style="margin-top: 60px;">Ingresá a tu cuenta</h2>
            </div>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="ServletLogin" method="post">
                <div class="container d-flex justify-content-center" style="margin-top: 30px;">
                    <div class="form-container-custom mt-4">
                        <div class="mb-3">
                            <label for="username" class="form-label">Nombre de usuario</label>
                            <div class="input-icon-container">
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Contraseña</label>
                            <div class="input-icon-container">
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-customContinuar">Iniciar Sesión</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import negocio.IClienteNegocio;
import negocioImpl.ClienteNegocioImpl;

@WebServlet("/BajaClienteSv")
public class BajaClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
    IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();

    public BajaClienteSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idCliente = Integer.parseInt(request.getParameter("idCliente"));
       
        boolean eliminado = iClienteNegocio.eliminarCliente(idCliente);
        
        if (eliminado) {
            request.getSession().setAttribute("mensajeExito", "Cliente eliminado correctamente");
        } else {
            request.getSession().setAttribute("mensajeError", "No se pudo eliminar el cliente");
        }
        response.sendRedirect("ListarClientesSv");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

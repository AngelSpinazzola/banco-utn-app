package servlets;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocioImpl.ClienteNegocioImpl;

@WebServlet("/ClienteInfoPersonalSv")
public class ClienteInfoPersonalSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
       
    public ClienteInfoPersonalSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		
		request.setAttribute("cliente", cliente);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteDatos.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

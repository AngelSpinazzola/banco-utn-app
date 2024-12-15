package servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Prestamo;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;

@WebServlet("/ClientePrestamosSv")
public class ClientePrestamosSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
    private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    
    public ClientePrestamosSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
		
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
        int idCliente = cliente.getIdCliente();
		
		ArrayList<Prestamo> listaPrestamos = iPrestamoNegocio.getPrestamosPorCliente(idCliente, page, pageSize);
		
		int totalPrestamos = iPrestamoNegocio.getTotalPrestamosPorCliente(idCliente);
		
		int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);
		
		request.setAttribute("totalPrestamos", totalPrestamos);
		request.setAttribute("totalPaginas", totalPaginas);
		request.setAttribute("listaPrestamos", listaPrestamos);
		request.setAttribute("paginaActual", page);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClientePrestamos.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

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
import entidad.Cuenta;
import entidad.Movimiento;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IMovimientoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.MovimientoNegocioImpl;


@WebServlet("/ClientePanelSv")
public class ClientePanelSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	private ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
	private IMovimientoNegocio iMovimientoNegocio = new MovimientoNegocioImpl();

    public ClientePanelSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		
		String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
        
        ArrayList<Movimiento> movimientos = iMovimientoNegocio.getMovimientosPorCliente(cliente.getIdCliente(), page, pageSize);
		
        int totalMovimientos = iMovimientoNegocio.getTotalMovimientos(cliente.getIdCliente());
        int totalPaginas = (int) Math.ceil((double) totalMovimientos / pageSize);
       
        
		request.setAttribute("cliente", cliente);
		request.setAttribute("cuentas", cuentas);
		request.setAttribute("movimientos", movimientos);
	    request.setAttribute("totalMovimientos", totalMovimientos);
	    request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("paginaActual", page);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClientePanel.jsp");
	    dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
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
import entidad.Prestamo;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;

@WebServlet("/DetalleClienteSv")
public class DetalleClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
	private ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();

	public DetalleClienteSv() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String idCliente = request.getParameter("idCliente");
	    
	    String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 3;
	    
        Cliente cliente = iClienteNegocio.getDetalleCliente(Integer.parseInt(idCliente));
	    
	    ArrayList<Prestamo> prestamos = iPrestamoNegocio.getPrestamosPorCliente(Integer.parseInt(idCliente), page, pageSize);
	    ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(Integer.parseInt(idCliente));
	    
	    int totalPrestamos = iPrestamoNegocio.getPrestamosCountPorCliente(Integer.parseInt(idCliente));
        
	    int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);
        
	    request.setAttribute("cliente", cliente);
	    request.setAttribute("prestamos", prestamos);
	    request.setAttribute("cuentas", cuentas); 
	    request.setAttribute("totalPrestamos", totalPrestamos);
	    request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("paginaActual", page);

	    RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminDetallesCliente.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
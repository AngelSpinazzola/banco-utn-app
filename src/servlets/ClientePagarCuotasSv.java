package servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Cliente;
import entidad.Cuenta;
import entidad.Cuota;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.ICuotaNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.CuotaNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;

@WebServlet("/ClientePagarCuotasSv")
public class ClientePagarCuotasSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ICuotaNegocio iCuotaNegocio = new CuotaNegocioImpl();
    private ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
    private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
	
    public ClientePagarCuotasSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String pageParam = request.getParameter("page");
	    String pageSizeParam = request.getParameter("pageSize");
	    Integer idPrestamo = (Integer) request.getSession().getAttribute("idPrestamo");

	    int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
	    int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
	    
	    ArrayList<Cuota> listaCuotas = iCuotaNegocio.getCuotasPorPrestamo(idPrestamo, page, pageSize);
	    
	    Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());

	    int totalCuotas = iCuotaNegocio.getTotalCuotasCount(idPrestamo);
	    int totalPaginas = (int) Math.ceil((double) totalCuotas / pageSize);
	    
	    request.setAttribute("cuentas", cuentas);
	    request.setAttribute("totalCuotas", totalCuotas);
	    request.setAttribute("totalPaginas", totalPaginas);
	    request.setAttribute("listaCuotas", listaCuotas);
	    request.setAttribute("paginaActual", page);
	    
	    RequestDispatcher dispatcher = request.getRequestDispatcher("/ClientePagarCuotas.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		if ("pagar".equals(action)) {
			int idCuenta = Integer.parseInt(request.getParameter("idCuenta"));
			String[] selectedCuotas = request.getParameterValues("selectedCuotas");
			String idsCuotas = String.join(",", selectedCuotas);
			
			BigDecimal saldoCliente = iCuentaNegocio.getSaldoCuentaCliente(idCuenta);
			BigDecimal montoTotalCuotas = iCuotaNegocio.getMontoTotalCuotasAPagar(idsCuotas);
			
			if (saldoCliente.compareTo(montoTotalCuotas) < 0) {
				request.setAttribute("saldoInsuficiente", true); 
			} else {
				iPrestamoNegocio.pagarCuotasPrestamo(idCuenta, idsCuotas);
				request.setAttribute("pagoRealizado", true); 
			}
		}
		
		int idPrestamo = Integer.parseInt(request.getParameter("idPrestamo"));
		request.getSession().setAttribute("idPrestamo", idPrestamo);
		
		String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
		
		int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 6;
        
        ArrayList<Cuota> listaCuotas = iCuotaNegocio.getCuotasPorPrestamo(idPrestamo, page, pageSize);
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
        
        int totalCuotas = iCuotaNegocio.getTotalCuotasCount(idPrestamo);
        int totalPaginas = (int) Math.ceil((double) totalCuotas / pageSize);
        
        request.setAttribute("cuentas", cuentas);
        request.setAttribute("totalCuotas", totalCuotas);
		request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("listaCuotas", listaCuotas);
        request.setAttribute("paginaActual", page);
        
        
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClientePagarCuotas.jsp");
	    dispatcher.forward(request, response);
	}


}

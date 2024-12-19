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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
        ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());

        // Par�metros de paginaci�n
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 5;

        // Obtiene par�metros de filtrado
        String searchTerm = request.getParameter("searchTerm");
        String montoDesdeStr = request.getParameter("montoDesde");
        String montoHastaStr = request.getParameter("montoHasta");

        // Convierte montos a Double
        Double montoDesde = null;
        Double montoHasta = null;
        try {
            if (montoDesdeStr != null && !montoDesdeStr.isEmpty()) {
                montoDesde = Double.parseDouble(montoDesdeStr);
            }
            if (montoHastaStr != null && !montoHastaStr.isEmpty()) {
                montoHasta = Double.parseDouble(montoHastaStr);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error al parsear los montos: " + e.getMessage());
        }

        // Obtiene movimientos filtrados
        ArrayList<Movimiento> movimientos = iMovimientoNegocio.getMovimientosFiltrados(
            cliente.getIdCliente(),
            searchTerm,
            montoDesde,
            montoHasta,
            page,
            pageSize
        );

        int totalMovimientos = iMovimientoNegocio.getTotalMovimientosFiltrados(
            cliente.getIdCliente(),
            searchTerm,
            montoDesde,
            montoHasta
        );
        
        int totalPaginas = (int) Math.ceil((double) totalMovimientos / pageSize);

        request.setAttribute("cliente", cliente);
        request.setAttribute("cuentas", cuentas);
        request.setAttribute("movimientos", movimientos);
        request.setAttribute("totalMovimientos", totalMovimientos);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("paginaActual", page);

        // Mantener los valores de filtro en el request para mostrarlos en el formulario
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("montoDesde", montoDesdeStr);
        request.setAttribute("montoHasta", montoHastaStr);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/ClientePanel.jsp");
        dispatcher.forward(request, response);
    }
	
	
	
}
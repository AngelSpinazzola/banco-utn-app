package servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Year;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.DatosDashboard;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IMovimientoNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.MovimientoNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;


@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    IMovimientoNegocio iMovimientoNegocio = new MovimientoNegocioImpl(); 
    IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
    IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
    
    public DashboardServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	BigDecimal totalOtorgadoEnPrestamos = BigDecimal.ZERO;
        int totalClientes = iClienteNegocio.getTotalClientesCount();
        int totalCuentas = iCuentaNegocio.getTotalCuentasActivas();
        int totalPrestamosActivos = iPrestamoNegocio.getPrestamosActivosCount();
        
        totalOtorgadoEnPrestamos = iPrestamoNegocio.totalOtorgadoEnPrestamos();
        
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("totalOtorgadoEnPrestamos", totalOtorgadoEnPrestamos);
        request.setAttribute("totalCuentas", totalCuentas);
        request.setAttribute("totalPrestamosActivos", totalPrestamosActivos);
        

        
        List<Integer> aniosPrestamos = iPrestamoNegocio.getAniosConPrestamos();
        List<Integer> aniosTransferencias = iMovimientoNegocio.getAniosConTransferencias();
        
        // Combina los años sin duplicados
        Set<Integer> todosLosAnios = new HashSet<>();
        todosLosAnios.addAll(aniosPrestamos);
        todosLosAnios.addAll(aniosTransferencias);
        
        // Convierte a lista y ordena descendentemente
        List<Integer> aniosConDatos = new ArrayList<>(todosLosAnios);
        Collections.sort(aniosConDatos, Collections.reverseOrder());
        
        // Si no hay años con datos, usa el año actual
        int anioActual = Year.now().getValue();
        if (aniosConDatos.isEmpty()) {
            aniosConDatos.add(anioActual);
        }
        
        // Obtiene el año seleccionado (por defecto el más reciente)
        int anioSeleccionado = anioActual;
        String anioParam = request.getParameter("anio");
        try {
            if (anioParam != null && !anioParam.isEmpty()) {
                anioSeleccionado = Integer.parseInt(anioParam);
            } else {
                anioSeleccionado = aniosConDatos.get(0); // El año más reciente
            }
        } catch (NumberFormatException e) {
            anioSeleccionado = aniosConDatos.get(0);
        }

        request.setAttribute("aniosConDatos", aniosConDatos);
        request.setAttribute("anioActual", anioSeleccionado);
        
        List<BigDecimal> prestamosMensuales = iPrestamoNegocio.getPrestamosMensualesPorAnio(anioSeleccionado);
        List<BigDecimal> transferenciasMensuales = iMovimientoNegocio.getTransferenciasMensualesPorAnio(anioSeleccionado);
        
        BigDecimal[] prestamosArray = prestamosMensuales.toArray(new BigDecimal[0]);
        BigDecimal[] transferenciasArray = transferenciasMensuales.toArray(new BigDecimal[0]);

        request.setAttribute("prestamosArray", prestamosArray);
        request.setAttribute("transferenciasArray", transferenciasArray);
        
        
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminPanel.jsp");
	    dispatcher.forward(request, response);
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

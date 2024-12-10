package servlets;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import excepciones.TransferenciaException;
import negocio.ICuentaNegocio;
import negocioImpl.CuentaNegocioImpl;

@WebServlet("/ClienteConfirmarTransferenciaSv")
public class ClienteConfirmarTransferenciaSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
    ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();

    public ClienteConfirmarTransferenciaSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cbuOrigen = request.getParameter("cbuOrigen");
        String cbuDestino = request.getParameter("cbuDestino");
        String monto = request.getParameter("monto");

        boolean transferenciaExitosa = iCuentaNegocio.realizarTransferencia(cbuOrigen, cbuDestino, monto);
        	
        try {
            if (transferenciaExitosa) {
                request.setAttribute("successTransferencia", "La transferencia se realizó con éxito.");
            } else {
                throw new TransferenciaException("Ocurrió un error al realizar la transferencia.");
            }
        } catch (TransferenciaException e) {
            request.setAttribute("errorTransferencia", e.getMessage());
        }


        request.setAttribute("cbuOrigen", cbuOrigen);
        request.setAttribute("cbuDestino", cbuDestino);
        request.setAttribute("monto", monto);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteConfirmarTransferencia.jsp");
        dispatcher.forward(request, response);
	}

}
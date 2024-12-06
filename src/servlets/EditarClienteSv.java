package servlets;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Direccion;
import entidad.Provincia;
import excepciones.ClienteNegocioException;
import negocio.IClienteNegocio;
import negocio.ILocalidadNegocio;
import negocio.INacionalidadNegocio;
import negocio.IProvinciaNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.LocalidadNegocioImpl;
import negocioImpl.NacionalidadNegocioImpl;
import negocioImpl.ProvinciaNegocioImpl;

@WebServlet("/EditarClienteSv")
public class EditarClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	private IProvinciaNegocio iProvinciaNegocio = new ProvinciaNegocioImpl();
	private ILocalidadNegocio iLocalidadNegocio = new LocalidadNegocioImpl();
	private INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();

	public EditarClienteSv() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cliente cliente = iClienteNegocio.getDetalleCliente(Integer.parseInt(request.getParameter("idCliente")));
		ArrayList<Nacionalidad> listaNacionalidades = iNacionalidadNegocio.listarNacionalidades();
		ArrayList<Provincia> listaProvincias = iProvinciaNegocio.listarProvincias();
		ArrayList<Localidad> listaLocalidades = iLocalidadNegocio.listarLocalidades();

		request.setAttribute("cliente", cliente);
		request.setAttribute("listaProvincias", listaProvincias);
	    request.setAttribute("listaLocalidades", listaLocalidades);
	    request.setAttribute("listaNacionalidades", listaNacionalidades);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("AdminEditarCliente.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int idCliente = Integer.parseInt(request.getParameter("idCliente"));
		String dni = request.getParameter("dni");
		String cuil = request.getParameter("cuil");
		String nombre = request.getParameter("nombre");
		String apellido = request.getParameter("apellido");
		String sexo = request.getParameter("sexo");
		String telefono = request.getParameter("telefono");
		String idNacionalidad = request.getParameter("nacionalidad");
		String fechaNacimiento = request.getParameter("fechaNacimiento");
		String email = request.getParameter("email");
		String codigoPostal = request.getParameter("codigoPostal");
		String calle = request.getParameter("calle");
		String numero = request.getParameter("numero");
		String idLocalidad = request.getParameter("localidad");
		String idProvincia = request.getParameter("provincia");

		Nacionalidad nacionalidad = iNacionalidadNegocio.obtenerNacionalidadPorId(Integer.parseInt(idNacionalidad));
		
		Cliente cliente = new Cliente();
		
		cliente.setIdCliente(idCliente);
		cliente.setNombre(nombre);
		cliente.setApellido(apellido);
		cliente.setDni(dni);
		cliente.setCuil(cuil);
		cliente.setSexo(sexo);
		cliente.setNumeroTelefono(telefono);
		cliente.setEmail(email);
		
		cliente.setFechaNacimiento(Date.valueOf(fechaNacimiento));

		cliente.setNacionalidad(nacionalidad);
		
		Direccion direccion = new Direccion();
		
		Provincia provincia = iProvinciaNegocio.obtenerProvinciaPorId(Integer.parseInt(idProvincia));
		Localidad localidad = iLocalidadNegocio.obtenerLocalidadPorId(Integer.parseInt(idLocalidad));
		
		direccion.setNumero(numero);
		direccion.setCalle(calle);
		direccion.setCodigoPostal(codigoPostal);
		direccion.setProvincia(provincia);
		direccion.setLocalidad(localidad);
		
		cliente.setDireccion(direccion);
		
		try {
            boolean resultado = iClienteNegocio.editarCliente(cliente);
            if (resultado) {
            	request.setAttribute("toastMessage", "Cliente editado correctamente.");
        		request.setAttribute("toastType", "success");
                response.sendRedirect("ListarClientesSv");
            }
        } catch (ClienteNegocioException e) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("AdminEditarCliente.jsp");
            dispatcher.forward(request, response);
        }
		
		

	}
}
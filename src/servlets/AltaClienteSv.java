package servlets;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import entidad.Cliente;
import entidad.Direccion;
import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Provincia;
import negocio.IClienteNegocio;
import negocio.ILocalidadNegocio;
import negocio.INacionalidadNegocio;
import negocio.IProvinciaNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.LocalidadNegocioImpl;
import negocioImpl.NacionalidadNegocioImpl;
import negocioImpl.ProvinciaNegocioImpl;

@WebServlet("/AltaClienteSv")
public class AltaClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();
	private IProvinciaNegocio iProvinciaNegocio = new ProvinciaNegocioImpl();
	private ILocalidadNegocio iLocalidadNegocio = new LocalidadNegocioImpl();
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	
    public AltaClienteSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProvinciaNegocioImpl provinciaNegocioImpl = new ProvinciaNegocioImpl();
		LocalidadNegocioImpl localidadNegocioImpl = new LocalidadNegocioImpl();
		INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();

		ArrayList<Provincia> listaProvincias = provinciaNegocioImpl.listarProvincias();
		ArrayList<Localidad> listaLocalidades = localidadNegocioImpl.listarLocalidades();
		ArrayList<Nacionalidad> listaNacionalidades = iNacionalidadNegocio.listarNacionalidades();
		
		request.setAttribute("listaProvincias", listaProvincias);
        request.setAttribute("listaLocalidades", listaLocalidades);
        request.setAttribute("listaNacionalidades", listaNacionalidades);
		
        RequestDispatcher dispatcher = request.getRequestDispatcher("AdminAltaCliente.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		session.removeAttribute("formData");
		
		String dni = request.getParameter("dni");
		String cuil = request.getParameter("cuil");
		String nombreUsuario = request.getParameter("nombreUsuario");
		String pass = request.getParameter("password");
		String email = request.getParameter("email");
		
		boolean existeDni = iClienteNegocio.existeDni(dni);
		boolean existeCuil = iClienteNegocio.existeCuil(cuil);
		boolean existeUsuario = iClienteNegocio.existeUsuario(nombreUsuario, pass);
		boolean existeEmail = iClienteNegocio.existeEmail(email);
		
		if (existeDni || existeCuil || existeUsuario || existeEmail) {
	    	ProvinciaNegocioImpl provinciaNegocioImpl = new ProvinciaNegocioImpl();
			LocalidadNegocioImpl localidadNegocioImpl = new LocalidadNegocioImpl();
			INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();

			ArrayList<Provincia> listaProvincias = provinciaNegocioImpl.listarProvincias();
			ArrayList<Localidad> listaLocalidades = localidadNegocioImpl.listarLocalidades();
			ArrayList<Nacionalidad> listaNacionalidades = iNacionalidadNegocio.listarNacionalidades();
			
			request.setAttribute("listaProvincias", listaProvincias);
	        request.setAttribute("listaLocalidades", listaLocalidades);
	        request.setAttribute("listaNacionalidades", listaNacionalidades);
	        
	        session.setAttribute("errorExisteDni", existeDni);
	        session.setAttribute("errorExisteCuil", existeCuil);
	        session.setAttribute("errorExisteUsuario", existeUsuario);
	        session.setAttribute("errorExisteEmail", existeEmail);

	        Map<String, String> formData = new HashMap<>();
	        formData.put("nombre", request.getParameter("nombre"));
	        formData.put("apellido", request.getParameter("apellido"));
	        formData.put("fechaNacimiento", request.getParameter("fechaNacimiento"));
	        formData.put("sexo", request.getParameter("sexo"));
	        formData.put("telefono", request.getParameter("telefono"));
	        formData.put("nacionalidad", request.getParameter("nacionalidad"));
	        formData.put("email", email);
	        formData.put("nombreUsuario", nombreUsuario);
	        formData.put("password", request.getParameter("password"));
	        formData.put("confirmPass", request.getParameter("confirmPassword"));
	        formData.put("provincia", request.getParameter("provincia"));
	        formData.put("localidad", request.getParameter("localidad"));
	        formData.put("codigoPostal", request.getParameter("codigoPostal"));
	        formData.put("calle", request.getParameter("calle"));
	        formData.put("numero", request.getParameter("numero"));
	        formData.put("dni", dni);
	        formData.put("cuil", cuil);
	        
	        session.setAttribute("formData", formData);
	        
	        RequestDispatcher dispatcher = request.getRequestDispatcher("AdminAltaCliente.jsp");
			dispatcher.forward(request, response);
	        return;
	    }
		
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String sexo = request.getParameter("sexo");
        String telefono = request.getParameter("telefono");
        String idNacionalidad = request.getParameter("nacionalidad");
        String idLocalidad = request.getParameter("localidad");
        String idProvincia = request.getParameter("provincia"); 
        String codigoPostal = request.getParameter("codigoPostal");
        String calle = request.getParameter("calle");
        String numero = request.getParameter("numero");
        
        Cliente nuevoCliente = new Cliente();
        Direccion nuevaDireccion = new Direccion(); 
        
        nuevoCliente.setNombre(nombre);
        nuevoCliente.setApellido(apellido);
        nuevoCliente.setDni(dni);
        nuevoCliente.setCuil(cuil);
        nuevoCliente.setSexo(sexo);
        nuevoCliente.setNumeroTelefono(telefono);
        nuevoCliente.setNombreUsuario(nombreUsuario);
        nuevoCliente.setEmail(email);
        nuevoCliente.setPassword(pass);
        nuevoCliente.setFechaNacimiento(Date.valueOf(fechaNacimiento));

        Nacionalidad nacionalidad = iNacionalidadNegocio.obtenerNacionalidadPorId(Integer.parseInt(idNacionalidad));
        nuevoCliente.setNacionalidad(nacionalidad);
             
        Provincia provincia = iProvinciaNegocio.obtenerProvinciaPorId(Integer.parseInt(idProvincia));
        Localidad localidad = iLocalidadNegocio.obtenerLocalidadPorId(Integer.parseInt(idLocalidad));
        nuevaDireccion.setCodigoPostal(codigoPostal);
        nuevaDireccion.setCalle(calle);
        nuevaDireccion.setNumero(numero);
        nuevaDireccion.setLocalidad(localidad); 
        nuevaDireccion.setProvincia(provincia);
        
        nuevoCliente.setDireccion(nuevaDireccion);        
        iClienteNegocio.agregarCliente(nuevoCliente);
        
        response.sendRedirect("ListarClientesSv");   
	}
}
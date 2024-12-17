package negocioImpl;

import java.util.ArrayList;
import java.util.Date;

import dao.IClienteDao;
import daoImpl.ClienteDaoImpl;
import entidad.Cliente;
import excepciones.ClienteNegocioException;
import negocio.IClienteNegocio;

public class ClienteNegocioImpl implements IClienteNegocio {
	private IClienteDao iClienteDao;

	public ClienteNegocioImpl() {
		this.iClienteDao = new ClienteDaoImpl();
	}

	@Override
	public boolean agregarCliente(Cliente cliente) {
		if (cliente == null) {
			System.out.println("El cliente no puede ser nulo");
			return false;
		}

		try {
		} catch (ClienteNegocioException e) {
			System.out.println("Error al verificar el cliente: " + e.getMessage());
			return false;
		}

		boolean resultado = iClienteDao.agregarCliente(cliente);

		return resultado;
	}
	
	@Override
	public boolean eliminarCliente(int idCliente) {
		boolean resultado = iClienteDao.eliminarCliente(idCliente);
		
		return resultado;
	}

	@Override
	public ArrayList<Cliente> listarClientes(int page, int pageSize) {
		ArrayList<Cliente> clientes = iClienteDao.listarClientes(page, pageSize);

		if (clientes == null || clientes.isEmpty()) {
			System.out.println("No hay clientes activos.");
			return new ArrayList<>();
		}

		return clientes;
	}

	@Override
	public int calcularTotalPaginas(int pageSize) {
		int totalClientes = getTotalClientesCount();
		return (int) Math.ceil((double) totalClientes / pageSize);
	}

	@Override
	public int getTotalClientesCount() {
		return iClienteDao.getTotalClientesCount();
	}

	@Override
	public Cliente getDetalleCliente(int idCliente) {
		return iClienteDao.getDetalleCliente(idCliente);
	}
	
	@Override
	public Cliente getClientePorIdUsuario(int idUsuario) {
		return iClienteDao.getClientePorIdUsuario(idUsuario);
	}

	@Override
	public void verificarCliente(Cliente cliente) throws ClienteNegocioException {
		// Validaci�n de campos vac�os y de formato de nombre y apellido
		if (cliente.getNombre() == null || cliente.getNombre().trim().isEmpty()) {
			throw new ClienteNegocioException("El nombre es obligatorio.");
		}
		// Validaci�n de que el nombre solo contenga letras, incluyendo letras con
		// acentos y la �
		if (!cliente.getNombre().matches("^[a-zA-Z������������\\s]+$")) {
			throw new ClienteNegocioException("El nombre s�lo puede contener letras.");
		}

		if (cliente.getApellido() == null || cliente.getApellido().trim().isEmpty()) {
			throw new ClienteNegocioException("El apellido es obligatorio.");
		}
		// Validaci�n de que el apellido solo contenga letras, incluyendo letras con
		// acentos y la �
		if (!cliente.getApellido().matches("^[a-zA-Z������������\\s]+$")) {
			throw new ClienteNegocioException("El apellido s�lo puede contener letras.");
		}

		if (cliente.getCuil() == null || cliente.getCuil().trim().isEmpty()) {
			throw new ClienteNegocioException("El CUIL es obligatorio.");
		}
		// Validaci�n de formato de CUIL (solo n�meros y formato XX-XXXXXXXX-X)
		if (!cliente.getCuil().matches("^[0-9]{2}-[0-9]{8}-[0-9]{1}$")) {
			throw new ClienteNegocioException("El CUIL debe tener 11 d�gitos en el formato XX-XXXXXXXX-X.");
		}

		if (cliente.getNumeroTelefono() == null || cliente.getNumeroTelefono().trim().isEmpty()) {
			throw new ClienteNegocioException("El tel�fono es obligatorio.");
		}
		// Validaci�n de que el tel�fono solo contenga n�meros
		if (!cliente.getNumeroTelefono().matches("^[0-9]+$")) {
			throw new ClienteNegocioException("El tel�fono solo puede contener n�meros.");
		}

		// Validaci�n de email
		if (cliente.getEmail() == null || cliente.getEmail().trim().isEmpty()) {
			throw new ClienteNegocioException("El email es obligatorio.");
		}
		if (!cliente.getEmail().matches("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")) {
			throw new ClienteNegocioException("El email ingresado no es v�lido.");
		}

		// Validaci�n de calle
		if (cliente.getDireccion() == null || cliente.getDireccion().getCalle() == null
				|| cliente.getDireccion().getCalle().trim().isEmpty()) {
			throw new ClienteNegocioException("La calle es obligatoria.");
		}
		if (!cliente.getDireccion().getCalle().matches("^[a-zA-Z0-9������������\\s]+$")) {
			throw new ClienteNegocioException("La calle solo puede contener letras, n�meros y espacios.");
		}

		// Validaci�n de altura
		if (cliente.getDireccion() == null || cliente.getDireccion().getNumero() == null
				|| cliente.getDireccion().getNumero().trim().isEmpty()) {
			throw new ClienteNegocioException("La altura es obligatoria.");
		}
		// Validaci�n de que la altura sea un n�mero y que est� entre 1 y 30 caracteres
		if (!cliente.getDireccion().getNumero().matches("^[0-9]+$")) {
			throw new ClienteNegocioException("La altura debe ser un valor num�rico.");
		}
		if (cliente.getDireccion().getNumero().length() < 1 || cliente.getDireccion().getNumero().length() > 30) {
			throw new ClienteNegocioException("La altura debe tener entre 1 y 30 d�gitos.");
		}

		// Validaci�n de c�digo postal
		if (cliente.getDireccion() == null || cliente.getDireccion().getCodigoPostal() == null
				|| cliente.getDireccion().getCodigoPostal().trim().isEmpty()) {
			throw new ClienteNegocioException("El c�digo postal es obligatorio.");
		}
		// Validaci�n del formato de c�digo postal (solo letras y n�meros)
		if (!cliente.getDireccion().getCodigoPostal().matches("^[a-zA-Z0-9]+$")) {
			throw new ClienteNegocioException("El c�digo postal debe contener solo letras y n�meros.");
		}
	}

	public boolean editarCliente(Cliente cliente) throws ClienteNegocioException {
		if (cliente == null) {
			System.out.println("El cliente no puede ser nulo.");
			return false;
		}
		
		try {
			verificarCliente(cliente);
			boolean resultado = iClienteDao.editarCliente(cliente);
			return resultado;
		} catch (ClienteNegocioException e) {
			throw new ClienteNegocioException(e.getMessage());
			
		}

	}
	
	@Override
	public boolean existeDni(String dni) {
		boolean existe = iClienteDao.existeDni(dni);
		
		return existe;
	}
	
	@Override
	public boolean existeCuil(String cuil) {
		boolean existe = iClienteDao.existeCuil(cuil);
		
		return existe;
	}
	
	@Override
	public boolean existeUsuario(String user, String pass) {
		boolean existe = iClienteDao.existeUsuario(user, pass);
		
		return existe;
	}
	
	@Override
	public boolean existeEmail(String email) {
		boolean existe = iClienteDao.existeEmail(email);
		
		return existe;
	}

}






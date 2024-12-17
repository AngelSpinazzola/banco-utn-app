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
	public boolean editarCliente(Cliente cliente) throws ClienteNegocioException {
		if (cliente == null) {
			System.out.println("El cliente no puede ser nulo.");
			return false;
		}
		
		try {
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


package negocio;

import java.util.ArrayList;
import entidad.Cliente;
import excepciones.ClienteNegocioException;

public interface IClienteNegocio {
	public boolean agregarCliente(Cliente cliente);
	public boolean editarCliente(Cliente cliente);
	public boolean eliminarCliente(int idCliente);
	public ArrayList<Cliente> listarClientes(int page, int pageSize);
	public int getTotalClientesCount();
	public int calcularTotalPaginas(int pageSize);
	public Cliente getDetalleCliente(int idCliente);
	public void verificarCliente(Cliente cliente) throws ClienteNegocioException;
	public Cliente getClientePorIdUsuario(int idUsuario);
	public boolean existeDni(String dni);
	public boolean existeCuil(String cuil);
	public boolean existeUsuario(String user, String pass);
	public boolean existeEmail(String email);
}
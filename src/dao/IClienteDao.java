package dao;

import java.util.ArrayList;
import entidad.Cliente;

public interface IClienteDao {
	public boolean agregarCliente(Cliente cliente);
	public boolean editarCliente(Cliente cliente);
	public boolean eliminarCliente(int idCliente);
	public ArrayList<Cliente> listarClientes(int page, int pageSize);
	public int getTotalClientesCount();
	public int calcularTotalPaginas(int pageSize);
	public Cliente getDetalleCliente(int idCliente);
	public Cliente getClientePorIdUsuario(int idUsuario);
}
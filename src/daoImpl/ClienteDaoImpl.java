package daoImpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import dao.IClienteDao;
import entidad.Cliente;
import entidad.Direccion;
import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Provincia;

public class ClienteDaoImpl implements IClienteDao {

	@Override
	public boolean agregarCliente(Cliente cliente) {
		Connection conexion = null;
		try {
			conexion = Conexion.getConnection();
			conexion.setAutoCommit(false);

			String query = "{CALL SP_AgregarCliente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

			try (CallableStatement statement = conexion.prepareCall(query)) {
				
				statement.setString(1, cliente.getNombreUsuario());
				statement.setString(2, cliente.getPassword());
				statement.setString(3, cliente.getDni());
				statement.setString(4, cliente.getCuil());
				statement.setString(5, cliente.getNombre());
				statement.setString(6, cliente.getApellido());
				statement.setString(7, cliente.getSexo());
				statement.setString(8, cliente.getNumeroTelefono());
				statement.setInt(9, cliente.getNacionalidad().getId());
				statement.setDate(10, new java.sql.Date(cliente.getFechaNacimiento().getTime()));
				statement.setString(11, cliente.getEmail());
				statement.setString(12, cliente.getDireccion().getCodigoPostal());
				statement.setString(13, cliente.getDireccion().getCalle());
				statement.setString(14, cliente.getDireccion().getNumero());
				statement.setInt(15, cliente.getDireccion().getLocalidad().getId());
				statement.setInt(16, cliente.getDireccion().getProvincia().getId());

				statement.executeUpdate();
				conexion.commit();
				return true;
			} catch (SQLException e) {
				conexion.rollback();
				e.printStackTrace();
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if (conexion != null)
					conexion.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	@Override
	public boolean editarCliente(Cliente cliente) {
	    Connection conexion = null;
	    try {
	        conexion = Conexion.getConnection();
	        conexion.setAutoCommit(false); 
	        
	        String query = "{CALL SP_EditarCliente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

	        try (CallableStatement statement = conexion.prepareCall(query)) {

	            statement.setInt(1, cliente.getIdCliente()); 
	            statement.setString(2, cliente.getDni()); 
	            statement.setString(3, cliente.getCuil()); 
	            statement.setString(4, cliente.getNombre()); 
	            statement.setString(5, cliente.getApellido()); 
	            statement.setString(6, cliente.getSexo()); 
	            statement.setString(7, cliente.getNumeroTelefono()); 
	            statement.setInt(8, cliente.getNacionalidad().getId()); 
	            statement.setDate(9, new java.sql.Date(cliente.getFechaNacimiento().getTime())); 
	            statement.setString(10, cliente.getEmail()); 
	            statement.setString(11, cliente.getDireccion().getCodigoPostal()); 
	            statement.setString(12, cliente.getDireccion().getCalle()); 
	            statement.setString(13, cliente.getDireccion().getNumero()); 
	            statement.setInt(14, cliente.getDireccion().getLocalidad().getId()); 
	            statement.setInt(15, cliente.getDireccion().getProvincia().getId()); 

	            statement.executeUpdate();
	            conexion.commit(); 

	            return true;
	        } catch (SQLException e) {
	            conexion.rollback(); 
	            e.printStackTrace();
	            return false;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        try {
	            if (conexion != null) {
	                conexion.close(); 
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}


	@Override
	public ArrayList<Cliente> listarClientes(int page, int pageSize) {
		int offset = (page - 1) * pageSize;

		String query = "{ CALL SP_ListarClientesPaginado(?, ?) }";

		ArrayList<Cliente> listaClientes = new ArrayList<>();

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			statement.setInt(1, pageSize);
			statement.setInt(2, offset);

			try (ResultSet rs = statement.executeQuery()) {
				while (rs.next()) {
					Cliente cliente = new Cliente();
					cliente.setIdCliente(rs.getInt("idCliente"));
					cliente.setDni(rs.getString("dni"));
					cliente.setNombre(rs.getString("nombre"));
					cliente.setApellido(rs.getString("apellido"));
					cliente.setEstado(rs.getInt("estado") == 1);
					cliente.setCantidadCuentas(rs.getInt("cantCuentas"));

					listaClientes.add(cliente);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaClientes;
	}

	@Override
	public int getTotalClientesCount() {
		String query = "SELECT COUNT(*) FROM CLIENTES c " + "LEFT JOIN Usuarios u ON u.IDUsuario = c.IDUsuario "
				+ "WHERE u.TipoUsuario = 2";

		int totalClientes = 0;

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query);
				ResultSet resultSet = statement.executeQuery()) {

			if (resultSet.next()) {
				totalClientes = resultSet.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalClientes;
	}

	@Override
	public int calcularTotalPaginas(int pageSize) {
		int totalClientes = getTotalClientesCount();
		return (int) Math.ceil((double) totalClientes / pageSize);
	}

	@Override
	public Cliente getDetalleCliente(int idCliente) {
		Cliente cliente = null;
		String sp = "{ CALL SP_DetalleCliente(?) }";

		try (Connection conn = Conexion.getConnection(); CallableStatement cs = conn.prepareCall(sp)) {

			cs.setInt(1, idCliente);
			ResultSet rs = cs.executeQuery();

			if (rs.next()) {
				cliente = new Cliente();
				Nacionalidad nacionalidad = new NacionalidadDaoImpl().obtenerNacionalidadPorId(rs.getInt("idNacionalidad"));
				Provincia provincia = new ProvinciaDaoImpl().obtenerProvinciaPorId(rs.getInt("idProvincia"));
				Localidad localidad = new LocalidadDaoImpl().obtenerLocalidadPorId(rs.getInt("idLocalidad"));
				
				cliente.setIdCliente(rs.getInt("idCliente"));
				cliente.setNombreUsuario(rs.getString("usuario"));
				cliente.setNombre(rs.getString("nombre"));
				cliente.setApellido(rs.getString("apellido"));
				cliente.setEmail(rs.getString("email"));
				cliente.setDni(rs.getString("dni"));
				cliente.setCuil(rs.getString("cuil"));
				cliente.setEstado(rs.getBoolean("estado"));
				cliente.setFechaNacimiento(rs.getDate("fechaNacimiento"));
				cliente.setSexo(rs.getString("sexo"));
				cliente.setNumeroTelefono(rs.getString("telefono"));
				cliente.setNacionalidad(nacionalidad);

				Direccion direccion = new Direccion();
				direccion.setCalle(rs.getString("calle"));
				direccion.setNumero(rs.getString("numero"));
				direccion.setCodigoPostal(rs.getString("codigoPostal"));
				direccion.setProvincia(provincia);
				direccion.setLocalidad(localidad);

				cliente.setDireccion(direccion);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cliente;
	}
	
	public Cliente getClientePorIdUsuario(int idUsuario) {
		Cliente cliente = null;
		String sp = "{ CALL SP_ClientePorIdUsuario(?) }";
		
		try (Connection conn = Conexion.getConnection(); CallableStatement cs = conn.prepareCall(sp)) {

			cs.setInt(1, idUsuario);
			ResultSet rs = cs.executeQuery();

			if (rs.next()) {
				cliente = new Cliente();
				Direccion direccion = new Direccion();
				Provincia provincia = new ProvinciaDaoImpl().obtenerProvinciaPorId(rs.getInt("idProvincia"));
				Localidad localidad = new LocalidadDaoImpl().obtenerLocalidadPorId(rs.getInt("idLocalidad"));
				Nacionalidad nacionalidad = new NacionalidadDaoImpl().obtenerNacionalidadPorId(rs.getInt("idNacionalidad"));
				
				cliente.setIdCliente(rs.getInt("idCliente"));
				cliente.setNombreUsuario(rs.getString("nombreUsuario"));
				cliente.setDni(rs.getString("dni"));
				cliente.setCuil(rs.getString("cuil"));
				cliente.setNombre(rs.getString("nombre"));
				cliente.setApellido(rs.getString("apellido"));
				cliente.setSexo(rs.getString("sexo"));
				cliente.setNacionalidad(nacionalidad);
				cliente.setNumeroTelefono(rs.getString("telefono"));
				cliente.setFechaNacimiento(rs.getDate("fechaNacimiento"));
				cliente.setEmail(rs.getString("email"));
				cliente.setEstado(rs.getBoolean("estado"));
				direccion.setIdDireccion(rs.getInt("idDireccion"));
				direccion.setCalle(rs.getString("calle"));
				direccion.setNumero(rs.getString("numero"));
				direccion.setCodigoPostal(rs.getString("codigoPostal"));
				direccion.setProvincia(provincia);
				direccion.setLocalidad(localidad);
				cliente.setDireccion(direccion);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cliente;
	}
	
	
	

}